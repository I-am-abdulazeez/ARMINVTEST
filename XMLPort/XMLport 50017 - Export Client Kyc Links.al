xmlport 50017 "Export Client Kyc Links"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(KYCLinks)
        {
            tableelement("KYC Links";"KYC Links")
            {
                XmlName = 'KYCLink';
                fieldelement(ClientID;"KYC Links"."Client ID")
                {
                }
                fieldelement(KYCTYPE;"KYC Links"."KYC Type")
                {
                }
                fieldelement(Link;"KYC Links".Link)
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

