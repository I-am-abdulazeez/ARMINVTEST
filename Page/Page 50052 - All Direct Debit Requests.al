page 50052 "All Direct Debit Requests"
{
    CardPageID = "Direct Debit Setup Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Direct Debit Mandate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(Status;Status)
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
                field("Created Date Time";"Created Date Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

