page 50037 "Direct Debit Setup Requests"
{
    CardPageID = "Direct Debit Setup Card";
    DeleteAllowed = false;
    Editable = true;
    PageType = List;
    SourceTable = "Direct Debit Mandate";
    SourceTableView = WHERE(Status=CONST(Received));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field(Comments;Comments)
                {
                }
                field(No;No)
                {
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
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.SelectALLDirectDebitSetup(Statusoptions::Received);
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
                    FundAdministration.UnSelectALLDirectDebitSetup(Statusoptions::Received);
                end;
            }
            action("Forward to Operations")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ChangeDirectDebitSetupStatusBatch(Statusoptions::Received,Statusoptions::"ARM Registrar");
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

