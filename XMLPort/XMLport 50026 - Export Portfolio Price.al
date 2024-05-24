xmlport 50026 "Export Portfolio Price"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(PortfolioPriceResponse)
        {
            tableelement("Fund Prices";"Fund Prices")
            {
                XmlName = 'Lines';
                SourceTableView = WHERE(Activated=CONST(true));
                fieldelement(FundCode;"Fund Prices"."Fund No.")
                {
                }
                fieldelement(ValueDate;"Fund Prices"."Value Date")
                {
                }
                fieldelement(BidPrice;"Fund Prices"."Bid Price")
                {
                }
                fieldelement(MidPrice;"Fund Prices"."Mid Price")
                {
                }
                fieldelement(OfferPrice;"Fund Prices"."Offer Price")
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

