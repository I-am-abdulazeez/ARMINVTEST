codeunit 2315 "O365 Setup Mgmt"
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    var
        ClientTypeManagement: Codeunit ClientTypeManagement;
        IdentityManagement: Codeunit "Identity Management";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";

    [Scope('Personalization')]
    procedure InvoicesExist(): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if SalesInvoiceHeader.FindFirst then
          exit(true);

        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindFirst then
          exit(true);
    end;

    [Scope('Personalization')]
    procedure EstimatesExist(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Quote);
        if SalesHeader.FindFirst then
          exit(true);
    end;

    [Scope('Personalization')]
    procedure DocumentsExist(): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if SalesInvoiceHeader.FindFirst then
          exit(true);

        SalesHeader.SetFilter("Document Type",'%1|%2',SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::Quote);
        if SalesHeader.FindFirst then
          exit(true);
    end;

    [Scope('Personalization')]
    procedure ShowCreateTestInvoice(): Boolean
    begin
        exit(not DocumentsExist);
    end;

    [Scope('Personalization')]
    procedure WizardShouldBeOpenedForInvoicing(): Boolean
    var
        O365GettingStarted: Record "O365 Getting Started";
    begin
        if not GettingStartedSupportedForInvoicing then
          exit(false);

        if O365GettingStarted.Get(UserId,ClientTypeManagement.GetCurrentClientType) then
          exit(false);

        exit(true);
    end;

    [Scope('Personalization')]
    procedure GettingStartedSupportedForInvoicing(): Boolean
    begin
        if not IdentityManagement.IsInvAppId then
          exit(false);

        if not (ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Web) then
          exit(false);

        exit(O365GettingStartedMgt.UserHasPermissionsToRunGettingStarted);
    end;
}

