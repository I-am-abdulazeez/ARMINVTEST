codeunit 2107 "O365 Sales Management"
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    var
        CustomerHasBeenBlockedMsg: Label 'The customer has been blocked for further business.';
        IdentityManagement: Codeunit "Identity Management";
        BlockQst: Label 'The customer could not be deleted as there are one or more documents for the customer.\ \Do you want to block the customer for further business?';
        BlockedErr: Label 'The customer could not be deleted as there are one or more documents for the customer.';
        QbVisibleInvNameTxt: Label 'QBVisibleForInv', Comment='{LOCKED}';
        IsQbVisibleOption: Option Hidden,QBO,QBD,"QBD and QBO";

    [Scope('Personalization')]
    procedure BlockOrDeleteCustomerAndDeleteContact(var Customer: Record Customer)
    var
        CustContUpdate: Codeunit "CustCont-Update";
    begin
        if GuiAllowed then
          if Customer.HasAnyOpenOrPostedDocuments then begin
            if Customer.IsBlocked then
              Error(BlockedErr);
            if not Confirm(BlockQst,false) then
              exit;
          end;
        CustContUpdate.DeleteCustomerContacts(Customer);
        if Customer.HasAnyOpenOrPostedDocuments then begin
          Customer.Validate(Blocked,Customer.Blocked::All);
          Customer.Modify(true);
          if GuiAllowed then
            Message(CustomerHasBeenBlockedMsg);
        end else
          Customer.Delete(true);
    end;

    [Scope('Personalization')]
    procedure SetItemDefaultValues(var Item: Record Item)
    var
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        VATProductPostingGroup: Record "VAT Product Posting Group";
        TaxSetup: Record "Tax Setup";
        TaxGroup: Record "Tax Group";
    begin
        Item.Type := Item.Type::Service;
        Item."Costing Method" := Item."Costing Method"::FIFO;

        if TaxSetup.Get then begin
          if TaxSetup."Non-Taxable Tax Group Code" <> '' then
            TaxGroup.SetFilter(Code,'<>%1',TaxSetup."Non-Taxable Tax Group Code");
          if TaxGroup.FindFirst then
            Item."Tax Group Code" := TaxGroup.Code;
        end;

        if Item."Gen. Prod. Posting Group" = '' then
          if GenProductPostingGroup.FindFirst then
            Item."Gen. Prod. Posting Group" := GenProductPostingGroup.Code;

        if Item."VAT Prod. Posting Group" = '' then
          if VATProductPostingGroup.FindFirst then
            Item."VAT Prod. Posting Group" := VATProductPostingGroup.Code;

        if Item.Modify then;
    end;

    [Scope('Personalization')]
    procedure GetO365DocumentBrickStyle(O365SalesDocument: Record "O365 Sales Document";var OutStandingStatusStyle: Text)
    begin
        with O365SalesDocument do begin
          OutStandingStatusStyle := '';

          case true of
            Canceled,"Last Email Sent Status" = "Last Email Sent Status"::Error:
              OutStandingStatusStyle := '';
            IsOverduePostedInvoice:
              OutStandingStatusStyle := 'Unfavorable';
          end;
        end;
    end;

    procedure GetSalesInvoiceBrickStyleAndStatus(SalesInvoiceHeader: Record "Sales Invoice Header";var OutStandingStatusStyle: Text;var Status: Text)
    var
        O365SalesDocument: Record "O365 Sales Document";
    begin
        OutStandingStatusStyle := '';
        O365SalesDocument.SetRange("No.",SalesInvoiceHeader."No.");
        O365SalesDocument.SetRange(Posted,true);
        if O365SalesDocument.OnFind('+') then begin
          Status := O365SalesDocument."Outstanding Status";
          O365SalesDocument.CalcFields("Last Email Sent Status");

          case true of
            O365SalesDocument."Last Email Sent Status" = O365SalesDocument."Last Email Sent Status"::Error:
              OutStandingStatusStyle := 'Attention';
            O365SalesDocument.IsOverduePostedInvoice:
              OutStandingStatusStyle := 'Attention';
            O365SalesDocument.Canceled:
              OutStandingStatusStyle := 'Attention';
            O365SalesDocument.Posted and (O365SalesDocument."Outstanding Amount" <= 0):
              OutStandingStatusStyle := 'Favorable';
          end;
        end;
    end;

    [Scope('Personalization')]
    procedure InsertNewCountryCode(var O365CountryRegion: Record "O365 Country/Region"): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        with O365CountryRegion do begin
          if (Code = '') and (Name = '') then
            exit(false);
          if Name = '' then
            Validate(Name,CopyStr(Code,1,MaxStrLen(Name)));
          if Code = '' then
            Validate(Code,CopyStr(Name,1,MaxStrLen(Code)));

          CountryRegion.Init;
          CountryRegion.Validate(Code,Code);
          CountryRegion.Validate(Name,Name);
          CountryRegion.Validate("VAT Scheme",
            CopyStr("VAT Scheme",1,MaxStrLen(CountryRegion."VAT Scheme"))
            );

          CountryRegion.Insert(true); // Passing on the error if it fails
          exit(true);
        end;
    end;

    [Scope('Personalization')]
    procedure ModifyCountryCode(xO365CountryRegion: Record "O365 Country/Region";O365CountryRegion: Record "O365 Country/Region"): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        if not CountryRegion.Get(xO365CountryRegion.Code) then
          exit(false);

        CountryRegion.Validate(Name,O365CountryRegion.Name);
        CountryRegion.Validate("VAT Scheme",
          CopyStr(O365CountryRegion."VAT Scheme",1,MaxStrLen(CountryRegion."VAT Scheme"))
          );

        CountryRegion.Modify(true); // Passing on the error if it fails
        exit(true);
    end;

    [Scope('Personalization')]
    procedure LookupCountryCodePhone(): Code[10]
    var
        O365CountryRegion: Record "O365 Country/Region";
        O365CountryRegionList: Page "O365 Country/Region List";
    begin
        O365CountryRegionList.LookupMode(true);
        O365CountryRegionList.Editable(false);

        if O365CountryRegionList.RunModal <> ACTION::LookupOK then
          Error('');

        O365CountryRegionList.GetRecord(O365CountryRegion);

        exit(O365CountryRegion.Code);
    end;

    [EventSubscriber(ObjectType::Codeunit, 9170, 'OnBeforeOpenSettings', '', false, false)]
    procedure OpenFullInvoicingSettingsPage(var Handled: Boolean)
    begin
        if Handled then
          exit;

        if not IdentityManagement.IsInvAppId then
          exit;

        Handled := true;
        PAGE.RunModal(PAGE::"BC O365 My Settings");
    end;

    [Scope('Internal')]
    procedure GetQuickBooksVisible(): Boolean
    var
        QboVisible: Boolean;
        QbdVisible: Boolean;
    begin
        GetQboQbdVisibility(QboVisible,QbdVisible);
        exit(QboVisible or QbdVisible);
    end;

    [Scope('Internal')]
    procedure GetQboQbdVisibility(var QboVisible: Boolean;var QbdVisible: Boolean)
    var
        QBOSyncProxy: Codeunit "QBO Sync Proxy";
        QBDSyncProxy: Codeunit "QBD Sync Proxy";
        QboVisibleKV: Boolean;
        QbdVisibleKV: Boolean;
        QboEnabled: Boolean;
        QbdEnabled: Boolean;
        DummyTitle: Text;
        DummyDescription: Text;
        DummyEmail: Text;
    begin
        QBOSyncProxy.GetQBOSyncSettings(DummyTitle,DummyDescription,QboEnabled);
        QBDSyncProxy.GetQBDSyncSettings(DummyTitle,DummyDescription,QbdEnabled,DummyEmail);

        if not TryGetQbVisibilityFromKeyVault(QboVisibleKV,QbdVisibleKV) then begin
          QboVisibleKV := true;
          QbdVisibleKV := true;
        end;

        if QboEnabled then
          QboVisible := true
        else
          if QboVisibleKV then
            OnGetQuickBooksVisible(QboVisible);

        if QbdEnabled then
          QbdVisible := true
        else
          if QbdVisibleKV then
            OnGetQuickBooksVisible(QbdVisible);
    end;

    local procedure TryGetQbVisibilityFromKeyVault(var QboVisibleKV: Boolean;var QbdVisibleKV: Boolean): Boolean
    var
        AzureKeyVaultManagement: Codeunit "Azure Key Vault Management";
        QbVisibleInvSecret: Text;
        IsVisibleInt: Integer;
    begin
        if not AzureKeyVaultManagement.GetAzureKeyVaultSecret(QbVisibleInvSecret,QbVisibleInvNameTxt) then
          exit(false);

        if (QbVisibleInvSecret <> '') and Evaluate(IsVisibleInt,QbVisibleInvSecret) then begin
          QboVisibleKV := false;
          QbdVisibleKV := false;

          case IsVisibleInt of
            IsQbVisibleOption::QBD:
              QbdVisibleKV := true;
            IsQbVisibleOption::QBO:
              QboVisibleKV := true;
            IsQbVisibleOption::"QBD and QBO":
              begin
                QbdVisibleKV := true;
                QboVisibleKV := true;
              end;
          end;

          exit(true);
        end;

        exit(false);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetQuickBooksVisible(var QuickBooksVisible: Boolean)
    begin
    end;
}

