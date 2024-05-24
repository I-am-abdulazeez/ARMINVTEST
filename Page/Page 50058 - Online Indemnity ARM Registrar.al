page 50058 "Online Indemnity ARM Registrar"
{
    CardPageID = "Online Indemnity Card";
    PageType = List;
    SourceTable = "Online Indemnity Mandate";
    SourceTableView = WHERE("Request Type"=CONST(Setup),
                            Status=CONST("ARM Registrar"));

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
                field("Account No";"Account No")
                {
                    Editable = false;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Sub Fund Code";"Sub Fund Code")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Request Type";"Request Type")
                {
                }
                field("Bank Code";"Bank Code")
                {
                    Editable = false;
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                    Editable = false;
                }
                field("Bank Account Name";"Bank Account Name")
                {
                    Editable = false;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    Editable = false;
                }
                field("Created Date Time";"Created Date Time")
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
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.SelectALLOIndemnity(Statusoptions::"ARM Registrar");
                end;
            }
            action("Un Select All")
            {
                Image = UnApply;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.UnSelectALLOIndemnity(Statusoptions::"ARM Registrar");
                end;
            }
            action("Send to  Ext Registrar/Verified")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusbatch(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar");
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusbatch(Statusoptions::"ARM Registrar",Statusoptions::"Verification Rejected");
                end;
            }
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ViewOnlineIndemnityTracker(Rec.No);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Request Type":="Request Type"::Setup;
    end;
}

