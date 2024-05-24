page 50128 "Posted Unit Switch Header"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Unit Switch Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transaction No";"Transaction No")
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
                field("Transaction Date";"Transaction Date")
                {
                }
            }
            part(Control9;"Unit Switch Lines")
            {
                SubPageLink = "Header No"=FIELD("Transaction No");
            }
        }
    }

    actions
    {
    }
}

