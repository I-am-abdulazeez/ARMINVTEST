page 50046 "Cancel DD Batch Generated"
{
    CardPageID = "Direct Debit Cancellation Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Direct Debit Mandate";
    SourceTableView = WHERE(Status=CONST(Cancelled),
                            "Request Type"=CONST(Cancellation),
                            "Cancellation Channel"=CONST("Online Channels"));

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
                field(Frequency;Frequency)
                {
                    Editable = false;
                }
                field(Status;Status)
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
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.SelectALLDirectDebitCancel(Statusoptions::"Batch ID Generated");
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
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.UnSelectALLDirectDebitCancel(Statusoptions::"Batch ID Generated");
                end;
            }
            action("Logged On Bank Platform")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ChangeDirectDebitCancelStatusBatch(Statusoptions::"Batch ID Generated",Statusoptions::"Logged on Bank Platform");
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
                    FundAdministration.ViewDirectDebitTracker(Rec.No);
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
        }
    }
}

