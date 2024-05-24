page 50130 "Unit Switch Posted"
{
    CardPageID = "Posted Unit Switch Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Unit Switch Header";
    SourceTableView = WHERE("Switch Status"=CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction No";"Transaction No")
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
                field("Value Date";"Value Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

