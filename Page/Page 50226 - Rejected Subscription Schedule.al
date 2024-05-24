page 50226 "Rejected Subscription Schedule"
{
    CardPageID = "Subscription Schedule Header";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Subscription Schedules Header";
    SourceTableView = WHERE("Subscription Status"=CONST(Rejected));

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

