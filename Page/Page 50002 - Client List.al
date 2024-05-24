page 50002 "Client List"
{
    CardPageID = "Client Card";
    DeleteAllowed = false;
    Editable = true;
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
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Clients")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = XMLport ImportClients;
            }
        }
    }
}

