page 50006 "Fund Prices"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Fund Prices";
    SourceTableView = WHERE(Activated=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund No.";"Fund No.")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                }
                field("Mid Price";"Mid Price")
                {
                }
                field("Bid Price";"Bid Price")
                {
                }
                field("Offer Price";"Offer Price")
                {
                }
                field("Bid Price Factor";"Bid Price Factor")
                {
                }
                field("Offer Price Factor";"Offer Price Factor")
                {
                }
                field(Comments;Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

