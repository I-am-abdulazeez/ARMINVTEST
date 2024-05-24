page 50244 "Rejected Reversed Transactions"
{
    // version Rev-1.0

    CardPageID = "Reversal Card Approve";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Client Account";
    SourceTableView = WHERE("Reversal Approval"=FILTER(reject));

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
                field("Accrued Interest";"Accrued Interest")
                {
                }
                field("Old MembershipID";"Old MembershipID")
                {
                }
                field("Old Account Number";"Old Account Number")
                {
                }
                field("Staff ID";"Staff ID")
                {
                }
                field("Portfolio Code";"Portfolio Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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
        ClientAdministration: Codeunit "Client Administration";

    procedure GetClientID(pClientID: Code[40])
    begin
        clientID:=pClientID
    end;
}

