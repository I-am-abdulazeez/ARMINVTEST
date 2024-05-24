page 50127 "Unit Switch Received"
{
    CardPageID = "Unit Switch Header";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Unit Switch Header";
    SourceTableView = WHERE("Switch Status"=CONST(Received));

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

