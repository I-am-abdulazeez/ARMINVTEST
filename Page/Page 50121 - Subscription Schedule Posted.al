page 50121 "Subscription Schedule Posted"
{
    CardPageID = "Subscription Sch Card  Posted";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Subscription Schedules Header";
    SourceTableView = WHERE("Subscription Status"=CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No";"Schedule No")
                {
                }
                field(Narration;Narration)
                {
                }
                field("Main Account";"Main Account")
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Total Amount";"Total Amount")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

