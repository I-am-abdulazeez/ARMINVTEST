report 1320 "Notification Email"
{
    // version NAVW113.02

    WordLayout = './Notification Email.docx';
    Caption = 'Notification Email';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));
            column(Line1;Line1)
            {
            }
            column(Line2;Line2)
            {
            }
            column(Line3;Line3Lbl)
            {
            }
            column(Line4;Line4Lbl)
            {
            }
            column(Settings_UrlText;SettingsLbl)
            {
            }
            column(Settings_Url;SettingsURL)
            {
            }
            column(SettingsWin_UrlText;SettingsWinLbl)
            {
            }
            column(SettingsWin_Url;SettingsWinURL)
            {
            }
            dataitem("Notification Entry";"Notification Entry")
            {
                column(UserName;ReceipientUser."Full Name")
                {
                }
                column(DocumentType;DocumentType)
                {
                }
                column(DocumentNo;DocumentNo)
                {
                }
                column(Document_UrlText;DocumentName)
                {
                }
                column(Document_Url;DocumentURL)
                {
                }
                column(CustomLink_UrlText;CustomLinkLbl)
                {
                }
                column(CustomLink_Url;"Custom Link")
                {
                }
                column(ActionText;ActionText)
                {
                }
                column(Field1Label;Field1Label)
                {
                }
                column(Field1Value;Field1Value)
                {
                }
                column(Field2Label;Field2Label)
                {
                }
                column(Field2Value;Field2Value)
                {
                }
                column(Field3Label;Field3Label)
                {
                }
                column(Field3Value;Field3Value)
                {
                }
                column(DetailsLabel;DetailsLabel)
                {
                }
                column(DetailsValue;DetailsValue)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    FindReceipientUser;
                    NotificationSetup.GetNotificationSetupForUser(Type,ReceipientUser."User Name");
                    CreateSettingsLink;
                    DataTypeManagement.GetRecordRef("Triggered By Record",RecRef);
                    SetDocumentTypeAndNumber(RecRef);
                    SetActionText;
                    SetReportFieldPlaceholders(RecRef);
                    SetReportLinePlaceholders;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
    end;

    var
        NotificationSetup: Record "Notification Setup";
        CompanyInformation: Record "Company Information";
        ReceipientUser: Record User;
        PageManagement: Codeunit "Page Management";
        DataTypeManagement: Codeunit "Data Type Management";
        NotificationManagement: Codeunit "Notification Management";
        SettingsURL: Text;
        SettingsWinURL: Text;
        DocumentType: Text;
        DocumentNo: Text;
        DocumentName: Text;
        DocumentURL: Text;
        ActionText: Text;
        Field1Label: Text;
        Field1Value: Text;
        Field2Label: Text;
        Field2Value: Text;
        Field3Label: Text;
        Field3Value: Text;
        SettingsLbl: Label 'Notification Settings';
        SettingsWinLbl: Label '(Windows Client)';
        CustomLinkLbl: Label '(Custom Link)';
        Line1Lbl: Label 'Hello %1,', Comment='%1 = User Name';
        Line2Lbl: Label 'You are registered to receive notifications related to %1.', Comment='%1 = Company Name';
        Line3Lbl: Label 'This is a message to notify you that:';
        Line4Lbl: Label 'Notification messages are sent automatically and cannot be replied to. But you can change when and how you receive notifications:';
        DetailsLabel: Text;
        DetailsValue: Text;
        Line1: Text;
        Line2: Text;
        DetailsLbl: Label 'Details';

    local procedure FindReceipientUser()
    begin
        ReceipientUser.SetRange("User Name","Notification Entry"."Recipient User ID");
        if not ReceipientUser.FindFirst then
          ReceipientUser.Init;
    end;

    local procedure CreateSettingsLink()
    var
        PermissionManager: Codeunit "Permission Manager";
        RecRef: RecordRef;
        PageID: Integer;
    begin
        if SettingsURL <> '' then
          exit;

        DataTypeManagement.GetRecordRef(NotificationSetup,RecRef);
        PageID := PageManagement.GetPageID(RecRef);
        SettingsURL := PageManagement.GetWebUrl(RecRef,PageID);
        if not PermissionManager.SoftwareAsAService then
          SettingsWinURL := PageManagement.GetRTCUrl(RecRef,PageID);
    end;

    local procedure SetDocumentTypeAndNumber(SourceRecRef: RecordRef)
    var
        RecRef: RecordRef;
    begin
        GetTargetRecRef(SourceRecRef,RecRef);
        NotificationManagement.GetDocumentTypeAndNumber(RecRef,DocumentType,DocumentNo);
        DocumentName := DocumentType + ' ' + DocumentNo;
    end;

    local procedure SetActionText()
    begin
        ActionText := NotificationManagement.GetActionTextFor("Notification Entry");
    end;

    local procedure SetReportFieldPlaceholders(SourceRecRef: RecordRef)
    var
        User: Record User;
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        IncomingDocument: Record "Incoming Document";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        RecordDetails: Text;
        HasApprovalEntryAmount: Boolean;
    begin
        Clear(Field1Label);
        Clear(Field1Value);
        Clear(Field2Label);
        Clear(Field2Value);
        Clear(Field3Label);
        Clear(Field3Value);
        Clear(DetailsLabel);
        Clear(DetailsValue);

        DetailsLabel := DetailsLbl;
        DetailsValue := "Notification Entry".FieldCaption("Created By") + ' ';

        User.SetRange("User Name","Notification Entry"."Created By");
        if User.FindFirst and (User."Full Name" <> '') then
          DetailsValue += User."Full Name"
        else
          DetailsValue += "Notification Entry"."Created By";

        if SourceRecRef.Number = DATABASE::"Approval Entry" then begin
          HasApprovalEntryAmount := true;
          SourceRecRef.SetTable(ApprovalEntry);
        end;

        GetTargetRecRef(SourceRecRef,RecRef);

        case RecRef.Number of
          DATABASE::"Incoming Document":
            begin
              Field1Label := IncomingDocument.FieldCaption("Entry No.");
              FieldRef := RecRef.Field(IncomingDocument.FieldNo("Entry No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := IncomingDocument.FieldCaption(Description);
              FieldRef := RecRef.Field(IncomingDocument.FieldNo(Description));
              Field2Value := Format(FieldRef.Value);
            end;
          DATABASE::"Sales Header",
          DATABASE::"Sales Invoice Header",
          DATABASE::"Sales Cr.Memo Header":
            GetSalesDocValues(Field1Label,Field1Value,Field2Label,Field2Value,RecRef,SourceRecRef);
          DATABASE::"Purchase Header",
          DATABASE::"Purch. Inv. Header",
          DATABASE::"Purch. Cr. Memo Hdr.":
            GetPurchaseDocValues(Field1Label,Field1Value,Field2Label,Field2Value,RecRef,SourceRecRef);
          DATABASE::"Gen. Journal Line":
            begin
              RecRef.SetTable(GenJournalLine);
              Field1Label := GenJournalLine.FieldCaption("Document No.");
              Field1Value := Format(GenJournalLine."Document No.");
              Field2Label := GenJournalLine.FieldCaption(Amount);
              if GenJournalLine."Currency Code" <> '' then
                Field2Value := GenJournalLine."Currency Code" + ' ';
              if HasApprovalEntryAmount then
                Field2Value += FormatAmount(ApprovalEntry.Amount)
              else
                Field2Value += FormatAmount(GenJournalLine.Amount)
            end;
          DATABASE::"Gen. Journal Batch":
            begin
              Field1Label := GenJournalBatch.FieldCaption(Description);
              FieldRef := RecRef.Field(GenJournalBatch.FieldNo(Description));
              Field1Value := Format(FieldRef.Value);
              Field2Label := GenJournalBatch.FieldCaption("Template Type");
              FieldRef := RecRef.Field(GenJournalBatch.FieldNo("Template Type"));
              Field2Value := Format(FieldRef.Value);
            end;
          DATABASE::Customer:
            begin
              Field1Label := Customer.FieldCaption("No.");
              FieldRef := RecRef.Field(Customer.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Customer.FieldCaption(Name);
              FieldRef := RecRef.Field(Customer.FieldNo(Name));
              Field2Value := Format(FieldRef.Value);
            end;
          DATABASE::Vendor:
            begin
              Field1Label := Vendor.FieldCaption("No.");
              FieldRef := RecRef.Field(Vendor.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Vendor.FieldCaption(Name);
              FieldRef := RecRef.Field(Vendor.FieldNo(Name));
              Field2Value := Format(FieldRef.Value);
            end;
          DATABASE::Item:
            begin
              Field1Label := Item.FieldCaption("No.");
              FieldRef := RecRef.Field(Item.FieldNo("No."));
              Field1Value := Format(FieldRef.Value);
              Field2Label := Item.FieldCaption(Description);
              FieldRef := RecRef.Field(Item.FieldNo(Description));
              Field2Value := Format(FieldRef.Value);
            end;
          else
            OnSetReportFieldPlaceholders(RecRef,Field1Label,Field1Value,Field2Label,Field2Value);
        end;

        case "Notification Entry".Type of
          "Notification Entry".Type::Approval:
            begin
              SourceRecRef.SetTable(ApprovalEntry);
              Field3Label := ApprovalEntry.FieldCaption("Due Date");
              Field3Value := Format(ApprovalEntry."Due Date");
              RecordDetails := ApprovalEntry.GetChangeRecordDetails;
              if RecordDetails <> '' then
                DetailsValue += RecordDetails;
            end;
          "Notification Entry".Type::Overdue:
            begin
              Field3Label := OverdueApprovalEntry.FieldCaption("Due Date");
              FieldRef := SourceRecRef.Field(OverdueApprovalEntry.FieldNo("Due Date"));
              Field3Value := Format(FieldRef.Value);
            end;
        end;

        if NotificationSetup."Display Target" = NotificationSetup."Display Target"::Windows then
          DocumentURL := PageManagement.GetRTCUrl(RecRef,"Notification Entry"."Link Target Page")
        else
          DocumentURL := PageManagement.GetWebUrl(RecRef,"Notification Entry"."Link Target Page");
    end;

    local procedure SetReportLinePlaceholders()
    begin
        Line1 := StrSubstNo(Line1Lbl,ReceipientUser."Full Name");
        Line2 := StrSubstNo(Line2Lbl,CompanyInformation.Name);
    end;

    local procedure GetTargetRecRef(RecRef: RecordRef;var TargetRecRefOut: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
    begin
        case "Notification Entry".Type of
          "Notification Entry".Type::"New Record":
            TargetRecRefOut := RecRef;
          "Notification Entry".Type::Approval:
            begin
              RecRef.SetTable(ApprovalEntry);
              TargetRecRefOut.Get(ApprovalEntry."Record ID to Approve");
            end;
          "Notification Entry".Type::Overdue:
            begin
              RecRef.SetTable(OverdueApprovalEntry);
              TargetRecRefOut.Get(OverdueApprovalEntry."Record ID to Approve");
            end;
        end;
    end;

    local procedure GetSalesDocValues(var Field1Label: Text;var Field1Value: Text;var Field2Label: Text;var Field2Value: Text;RecRef: RecordRef;SourceRecRef: RecordRef)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        AmountFieldRef: FieldRef;
        CurrencyCode: Code[10];
        CustomerNo: Code[20];
    begin
        case RecRef.Number of
          DATABASE::"Sales Header":
            begin
              RecRef.SetTable(SalesHeader);
              AmountFieldRef := RecRef.Field(SalesHeader.FieldNo(Amount));
              CurrencyCode := SalesHeader."Currency Code";
              CustomerNo := SalesHeader."Sell-to Customer No.";
            end;
          DATABASE::"Sales Invoice Header":
            begin
              RecRef.SetTable(SalesInvoiceHeader);
              AmountFieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo(Amount));
              CurrencyCode := SalesInvoiceHeader."Currency Code";
              CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";
            end;
          DATABASE::"Sales Cr.Memo Header":
            begin
              RecRef.SetTable(SalesCrMemoHeader);
              AmountFieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo(Amount));
              CurrencyCode := SalesCrMemoHeader."Currency Code";
              CustomerNo := SalesCrMemoHeader."Sell-to Customer No.";
            end;
        end;

        GetSalesPurchDocAmountValue(Field1Label,Field1Value,SourceRecRef,AmountFieldRef,CurrencyCode);

        Field2Label := Customer.TableCaption;
        if Customer.Get(CustomerNo) then
          Field2Value := Customer.Name + ' (#' + Format(Customer."No.") + ')';
    end;

    local procedure GetPurchaseDocValues(var Field1Label: Text;var Field1Value: Text;var Field2Label: Text;var Field2Value: Text;RecRef: RecordRef;SourceRecRef: RecordRef)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        AmountFieldRef: FieldRef;
        CurrencyCode: Code[10];
        VendorNo: Code[20];
    begin
        case RecRef.Number of
          DATABASE::"Purchase Header":
            begin
              RecRef.SetTable(PurchaseHeader);
              AmountFieldRef := RecRef.Field(PurchaseHeader.FieldNo(Amount));
              CurrencyCode := PurchaseHeader."Currency Code";
              VendorNo := PurchaseHeader."Buy-from Vendor No.";
            end;
          DATABASE::"Purch. Inv. Header":
            begin
              RecRef.SetTable(PurchInvHeader);
              AmountFieldRef := RecRef.Field(PurchInvHeader.FieldNo(Amount));
              CurrencyCode := PurchInvHeader."Currency Code";
              VendorNo := PurchInvHeader."Buy-from Vendor No.";
            end;
          DATABASE::"Purch. Cr. Memo Hdr.":
            begin
              RecRef.SetTable(PurchCrMemoHdr);
              AmountFieldRef := RecRef.Field(PurchCrMemoHdr.FieldNo(Amount));
              CurrencyCode := PurchCrMemoHdr."Currency Code";
              VendorNo := PurchCrMemoHdr."Buy-from Vendor No.";
            end;
        end;

        GetSalesPurchDocAmountValue(Field1Label,Field1Value,SourceRecRef,AmountFieldRef,CurrencyCode);

        Field2Label := Vendor.TableCaption;
        if Vendor.Get(VendorNo) then
          Field2Value := Vendor.Name + ' (#' + Format(Vendor."No.") + ')';
    end;

    local procedure GetSalesPurchDocAmountValue(var Field1Label: Text;var Field1Value: Text;SourceRecRef: RecordRef;AmountFieldRef: FieldRef;CurrencyCode: Code[10])
    var
        ApprovalEntry: Record "Approval Entry";
        Amount: Decimal;
    begin
        Field1Label := AmountFieldRef.Caption;
        if CurrencyCode <> '' then
          Field1Value := CurrencyCode + ' ';

        if SourceRecRef.Number = DATABASE::"Approval Entry" then begin
          SourceRecRef.SetTable(ApprovalEntry);
          Field1Value += FormatAmount(ApprovalEntry.Amount);
        end else begin
          AmountFieldRef.CalcField;
          Amount := AmountFieldRef.Value;
          Field1Value += FormatAmount(Amount);
        end;
    end;

    local procedure FormatAmount(Amount: Decimal): Text
    begin
        exit(Format(Amount,0,'<Precision,2><Standard Format,0>'));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetReportFieldPlaceholders(RecRef: RecordRef;var Field1Label: Text;var Field1Value: Text;var Field2Label: Text;var Field2Value: Text)
    begin
    end;
}

