page 50216 "Direct Debit Rejected By Reg"
{
    CardPageID = "Direct Debit Setup Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Direct Debit Mandate";
    SourceTableView = WHERE(Status=CONST("Rejected By ARM Reg"),
                            "Request Type"=CONST(Setup));

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
    }
}

