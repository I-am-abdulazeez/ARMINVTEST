xmlport 50011 "Export Client Accounts"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(ClientAccounts)
        {
            tableelement("Client Account";"Client Account")
            {
                XmlName = 'ClientAccount';
                fieldelement(AccountNo;"Client Account"."Account No")
                {
                }
                fieldelement(MembershipID;"Client Account"."Client ID")
                {
                }
                fieldelement(FundCode;"Client Account"."Fund No")
                {
                }
                fieldelement(KYCTier;"Client Account"."KYC Tier")
                {
                }
                fieldelement(Mandate;"Client Account"."Dividend Mandate")
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

