xmlport 50013 "Import Prices"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Prices)
        {
            tableelement("Fund Prices";"Fund Prices")
            {
                XmlName = 'FundPrices';
                fieldelement(Fund;"Fund Prices"."Fund No.")
                {
                }
                fieldelement(Valuedate;"Fund Prices"."Value Date")
                {
                }
                fieldelement(MidPrice;"Fund Prices"."Mid Price")
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

