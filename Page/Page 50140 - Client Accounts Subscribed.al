page 50140 "Client Accounts Subscribed"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Client Account";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Fund No";"Fund No")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
                field("Dividend Mandate";"Dividend Mandate")
                {
                }
                field("E-Mail";"E-Mail")
                {
                }
                field("KYC Tier";"KYC Tier")
                {
                }
                field("Phone No.";"Phone No.")
                {
                }
                field("No of Units";"No of Units")
                {
                }
                field(NAV;NAV)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Account")
            {
                Image = New;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(CreateAccountDialog);
                    if "Client ID"<>'' then clientID:="Client ID";
                    CreateAccountDialog.getClientId(clientID);
                    CreateAccountDialog.Run;
                end;
            }
            action("View Account")
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Account No","Account No");
                    Clear(ClientAccountCard);
                    ClientAccountCard.SetTableView(ClientAccount);
                    ClientAccountCard.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund No","No of Units");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Validate("Client ID",clientID);
    end;

    trigger OnOpenPage()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund No","No of Units");
    end;

    var
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
        clientID: Code[40];
        ClientAccount: Record "Client Account";
        ClientAccountCard: Page "Client Account Card";
        ClientAdministration: Codeunit "Client Administration";
        CreateAccountDialog: Page "Create Account Dialog";

    procedure GetClientID(pClientID: Code[40])
    begin
        clientID:=pClientID
    end;
}

