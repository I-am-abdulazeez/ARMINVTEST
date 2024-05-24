page 50042 "Direct Debits Rejected by Bank"
{
    CardPageID = "Direct Debit Setup Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Direct Debit Mandate";
    SourceTableView = WHERE(Status=CONST("Rejected By Bank"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field("Rejected By";"Rejected By")
                {
                }
                field(Comments;Comments)
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
                    Editable = false;
                }
                field("Sub Fund Code";"Sub Fund Code")
                {
                    Editable = false;
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

