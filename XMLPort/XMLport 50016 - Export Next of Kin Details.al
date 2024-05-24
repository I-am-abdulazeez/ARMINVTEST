xmlport 50016 "Export Next of Kin Details"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(ClientsNOK)
        {
            tableelement("Client Next of Kin";"Client Next of Kin")
            {
                XmlName = 'ClientNOK';
                fieldelement(MembershipNumber;"Client Next of Kin"."Client ID")
                {
                }
                fieldelement(Lineno;"Client Next of Kin"."Line No")
                {
                }
                fieldelement(FirstName;"Client Next of Kin"."NOK First Name")
                {
                }
                fieldelement(Surname;"Client Next of Kin"."NOK Last Name")
                {
                }
                fieldelement(MiddleName;"Client Next of Kin"."NOK Middle Name")
                {
                }
                fieldelement(MailingAddress;"Client Next of Kin"."NOK Address")
                {
                }
                fieldelement(PhoneNumber;"Client Next of Kin"."NOK Telephone No")
                {
                }
                fieldelement(Email;"Client Next of Kin"."NOK Email")
                {
                }
                fieldelement(RelationShip;"Client Next of Kin"."NOK Relationship")
                {
                }
                fieldelement(Title;"Client Next of Kin"."NOK Title")
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

