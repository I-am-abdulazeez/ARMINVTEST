page 50076 "Posted Redemptions"
{
    CardPageID = "Posted Redemption Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Redemption";
    SourceTableView = WHERE("Redemption Status"=CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field(No;No)
                {
                    Editable = false;
                }
                field("Recon No";"Recon No")
                {
                }
                field("Account No";"Account No")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field("Client Name";"Client Name")
                {
                }
                field("Fund Sub Account";"Fund Sub Account")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Editable = false;
                }
                field("Agent Code";"Agent Code")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("Accrued Dividend Paid";"Accrued Dividend Paid")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
                field("Fee Units";"Fee Units")
                {
                }
                field("Fee Amount";"Fee Amount")
                {
                }
                field("Charges On Accrued Interest";"Charges On Accrued Interest")
                {
                }
                field("Net Amount Payable";"Net Amount Payable")
                {
                }
                field("Treasury Batch";"Treasury Batch")
                {
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
                field("Price Per Unit";"Price Per Unit")
                {
                    Editable = false;
                }
                field("No. Of Units";"No. Of Units")
                {
                    Editable = false;
                }
                field("Redemption Type";"Redemption Type")
                {
                }
                field(Reversed;Reversed)
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Account No";"Bank Account No")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Unit Balance after Redmption";"Unit Balance after Redmption")
                {
                }
                field("Current Unit Balance";"Current Unit Balance")
                {
                }
                field("OLD Account No";"OLD Account No")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ViewRedemptionTracker(Rec.No);
                end;
            }
            action("View Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Document Link");
                end;
            }
            action(AODS)
            {
                Image = DocInBrowser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    ClientAdministration.ViewKYCLinks("Client ID");
                end;
            }
        }
    }
}

