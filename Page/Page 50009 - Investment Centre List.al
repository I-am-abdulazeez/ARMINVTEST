page 50009 "Investment Centre List"
{
    CardPageID = "Investment Centre Card";
    PageType = List;
    SourceTable = "Investment Centres";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Name;Name)
                {
                }
                field(State;State)
                {
                }
                field(Address;Address)
                {
                }
                field(Manager;Manager)
                {
                }
                field("Manager Name";"Manager Name")
                {
                }
                field(Email;Email)
                {
                }
                field("Phone Number";"Phone Number")
                {
                }
            }
        }
    }

    actions
    {
    }
}

