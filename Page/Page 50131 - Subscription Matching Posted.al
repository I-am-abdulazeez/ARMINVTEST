page 50131 "Subscription Matching Posted"
{
    CardPageID = "Subscription Match Header pstd";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Subscription Matching header";
    SourceTableView = WHERE(Posted=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field(Narration;Narration)
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
            }
        }
    }

    actions
    {
    }
}

