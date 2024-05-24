page 50167 "Client Verification"
{
    CardPageID = "Client Verification Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Client;
    SourceTableView = WHERE("AOD Verified"=CONST("Pending Approval"));

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
                field("E-Mail";"E-Mail")
                {
                }
                field("Client Type";"Client Type")
                {
                }
                field("Last Modified By";"Last Modified By")
                {
                }
                field("Last Modified DateTime";"Last Modified DateTime")
                {
                }
            }
        }
    }

    actions
    {
    }
}

