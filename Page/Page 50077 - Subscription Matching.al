page 50077 "Subscription Matching"
{
    CardPageID = "Subscription Matching Header";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Subscription Matching header";
    SourceTableView = WHERE(Posted=CONST(false));

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
                field("Total No of Lines";"Total No of Lines")
                {
                }
            }
        }
    }

    actions
    {
    }
}

