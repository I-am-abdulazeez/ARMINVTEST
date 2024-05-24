page 50088 "All Fund Transfer Requests"
{
    CardPageID = "Unit Transfer Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Fund Transfer";

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
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Editable = false;
                }
                field("From Account No";"From Account No")
                {
                    Editable = false;
                }
                field("From Client Name";"From Client Name")
                {
                    Enabled = false;
                }
                field("To Account No";"To Account No")
                {
                    Editable = false;
                }
                field("To Client Name";"To Client Name")
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
                field("From Fund Code";"From Fund Code")
                {
                    Editable = false;
                }
                field("From Fund Name";"From Fund Name")
                {
                    Editable = false;
                }
                field("From Client ID";"From Client ID")
                {
                    Editable = false;
                }
                field("From Fund Sub Account";"From Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Code";"To Fund Code")
                {
                    Editable = false;
                }
                field("To Client ID";"To Client ID")
                {
                    Editable = false;
                }
                field("To Fund Sub Account";"To Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Name";"To Fund Name")
                {
                    Editable = false;
                }
                field("Transfer Type";"Transfer Type")
                {
                }
                field("Fund Transfer Status";"Fund Transfer Status")
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
                    FundAdministration.SelectALLFundTransfer(Statusoptions::Received);
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
                    FundAdministration.UnSelectALLFundTransfer(Statusoptions::Received);
                end;
            }
            action("Forward to ARM Registrar")
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
                    FundAdministration.ChangeFundTransferStatusBatch(Statusoptions::Received,Statusoptions::"ARM Registrar");
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
                    FundAdministration.ViewFundTransferTracker(Rec.No);
                end;
            }
        }
    }
}
