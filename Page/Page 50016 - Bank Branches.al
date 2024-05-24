page 50016 "Bank Branches"
{
    PageType = List;
    SourceTable = "Bank Branches";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code";"Bank Code")
                {
                    Editable = false;
                }
                field(Name;Name)
                {
                }
                field("Branch Code";"Branch Code")
                {
                }
                field("Branch Name";"Branch Name")
                {
                }
                field(State;State)
                {
                }
                field(Address;Address)
                {
                }
                field(Email;Email)
                {
                }
                field("Phone Number";"Phone Number")
                {
                }
                field("Sort Code";"Sort Code")
                {
                }
                field("Swift Code";"Swift Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

