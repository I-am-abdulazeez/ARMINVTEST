xmlport 50018 "Export Joint Holder Details"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(Jointholders)
        {
            tableelement("Joint Account Holders";"Joint Account Holders")
            {
                XmlName = 'JointHolder';
                fieldelement(MembershipNumber;"Joint Account Holders"."Client ID")
                {
                }
                fieldelement(LineNo;"Joint Account Holders"."Line no")
                {
                }
                fieldelement(Title;"Joint Account Holders".Title)
                {
                }
                fieldelement(FirstName;"Joint Account Holders"."First Name")
                {
                }
                fieldelement(Surname;"Joint Account Holders"."Last Name")
                {
                }
                fieldelement(MiddleName;"Joint Account Holders"."Middle Names")
                {
                }
                fieldelement(MailingAddress;"Joint Account Holders".Address1)
                {
                }
                fieldelement(PhoneNumber;"Joint Account Holders".Phone)
                {
                }
                fieldelement(Email;"Joint Account Holders".Email)
                {
                }
                fieldelement(MainHolder;"Joint Account Holders"."Main Holder")
                {
                }
                fieldelement(Signatory;"Joint Account Holders".Signatory)
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

