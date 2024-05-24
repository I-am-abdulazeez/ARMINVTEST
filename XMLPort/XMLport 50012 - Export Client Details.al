xmlport 50012 "Export Client Details"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(Clients)
        {
            tableelement(Client;Client)
            {
                XmlName = 'Client';
                fieldelement(MembershipNumber;Client."Membership ID")
                {
                }
                fieldelement(FirstName;Client."First Name")
                {
                }
                fieldelement(Surname;Client.Surname)
                {
                }
                fieldelement(MiddleName;Client."Other Name/Middle Name")
                {
                }
                fieldelement(MailingAddress;Client."Mailing Address")
                {
                }
                fieldelement(PhoneNumber;Client."Phone Number")
                {
                }
                fieldelement(Email;Client."E-Mail")
                {
                }
                fieldelement(DateofBirth;Client."Date Of Birth")
                {
                }
                fieldelement(BVN;Client."BVN Number")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

