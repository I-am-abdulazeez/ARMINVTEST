page 50071 "Redemptions ARM Registrar"
{
    CardPageID = "Redemption Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = Redemption;
    SourceTableView = WHERE("Redemption Status"=CONST("ARM Registrar"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field("Transaction No";"Transaction No")
                {
                    Editable = false;
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
                field("Accrued Dividend";"Accrued Dividend")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
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
            action("Select All")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.SelectALLRedemption(Statusoptions::"ARM Registrar");
                end;
            }
            action("Un Select All")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.UnSelectALLRedemption(Statusoptions::"ARM Registrar");
                end;
            }
            action("Send to EXT Registrar/Verified")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.ChangeRedemptionStatusBatch(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar");
                end;
            }
            action(Rejected)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.ChangeRedemptionStatusBatch(Statusoptions::"ARM Registrar",Statusoptions::Rejected);
                end;
            }
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
                    FundAdministration.ViewRedemptionTracker(Rec."Transaction No");
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

