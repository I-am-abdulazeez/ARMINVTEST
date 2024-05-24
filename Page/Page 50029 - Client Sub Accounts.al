page 50029 "Client Sub Accounts"
{
    CardPageID = "Client Card";
    Editable = false;
    PageType = List;
    SourceTable = Client;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Membership ID";"Membership ID")
                {
                }
                field(Name;Name)
                {
                }
                field("First Name";"First Name")
                {
                }
                field(Surname;Surname)
                {
                }
                field("Other Name/Middle Name";"Other Name/Middle Name")
                {
                }
                field("Mailing Address";"Mailing Address")
                {
                }
                field("City/Town";"City/Town")
                {
                }
                field(Contact;Contact)
                {
                }
                field("Phone Number";"Phone Number")
                {
                }
                field(Title;Title)
                {
                }
            }
        }
    }

    actions
    {
    }
}

