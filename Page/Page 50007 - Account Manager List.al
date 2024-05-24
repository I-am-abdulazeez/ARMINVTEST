page 50007 "Account Manager List"
{
    CardPageID = "Account Manager Card";
    PageType = List;
    SourceTable = "Account Manager";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agent Code";"Agent Code")
                {
                }
                field("First Name";"First Name")
                {
                }
                field(Surname;Surname)
                {
                }
                field("Middle Name";"Middle Name")
                {
                }
                field("RM Code";"RM Code")
                {
                }
                field("RM Name";"RM Name")
                {
                }
                field("Email Address";"Email Address")
                {
                }
                field("No of Agents Managed";"No of Agents Managed")
                {
                }
                field("Investment Center";"Investment Center")
                {
                }
            }
        }
    }

    actions
    {
    }
}

