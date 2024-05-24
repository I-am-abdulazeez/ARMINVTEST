page 50043 "Direct Debits Cancelled"
{
    CardPageID = "Direct Debit Setup Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Direct Debit Mandate";
    SourceTableView = WHERE(Status=CONST("Mandate Cancelled"));

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
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
                field(Frequency;Frequency)
                {
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

