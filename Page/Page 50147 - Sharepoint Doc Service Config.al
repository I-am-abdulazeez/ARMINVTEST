page 50147 "Sharepoint Doc Service Config"
{
    // version NAVW113.00

    ApplicationArea = Advanced;
    Caption = 'Microsoft SharePoint Connection Setup';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sharepoint Document Service";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Service ID";"Service ID")
                {
                    ApplicationArea = Service;
                    Caption = 'Service ID';
                    ToolTip = 'Specifies a unique code for the service that you use for document storage and usage.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description for the document service.';
                }
                field(Location;Location)
                {
                    ApplicationArea = Location;
                    Caption = 'Location';
                    ToolTip = 'Specifies the URI for where your documents are stored, such as your site on SharePoint Online.';
                }
                field(Folder;Folder)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Folder';
                    ToolTip = 'Specifies the folder in the document repository for this document service that you want documents to be stored in.';
                }
            }
            group("Shared documents")
            {
                Caption = 'Shared Documents';
                field("Document Repository";"Document Repository")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document Repository';
                    ToolTip = 'Specifies the location where your document service provider stores your documents, if you want to store documents in a shared document repository.';
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User Name';
                    ToolTip = 'Specifies the account that Business Central Server must use to log on to the document service, if you want to use a shared document repository.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Connection")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Test Connection';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Test the configuration settings against the online document storage service.';

                trigger OnAction()
                var
                    DocumentServiceManagement: Codeunit "Document Service Management";
                begin
                    // Save record to make sure the credentials are reset.
                    MODIFY;
                    DocumentServiceManagement.TestSharepointConnection;
                    MESSAGE(ValidateSuccessMsg);
                end;
            }
            action("Set Password")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Password';
                Enabled = DynamicEditable;
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Set the password for the current User Name';

                trigger OnAction()
                var
                    DocumentServiceAccPwd: Page "Document Service Acc. Pwd.";
                begin
                    IF DocumentServiceAccPwd.RUNMODAL = ACTION::OK THEN BEGIN
                      IF CONFIRM(ChangePwdQst) THEN
                        Password := DocumentServiceAccPwd.GetData;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.EDITABLE;
    end;

    trigger OnInit()
    begin
        DynamicEditable := FALSE;
    end;

    trigger OnOpenPage()
    begin
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          "Service ID" := 'Service 1';
          INSERT(FALSE);
        END;
    end;

    var
        ChangePwdQst: Label 'Are you sure that you want to change your password?';
        DynamicEditable: Boolean;
        ValidateSuccessMsg: Label 'The connection settings validated correctly, and the current configuration can connect to the document storage service.';
}

