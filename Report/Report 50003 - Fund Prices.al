report 50003 "Fund Prices"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Fund Prices.rdlc';

    dataset
    {
        dataitem("Fund Prices";"Fund Prices")
        {
            RequestFilterFields = "Fund No.","Value Date";
            column(FundNo_FundPrices;"Fund Prices"."Fund No.")
            {
            }
            column(ValueDate_FundPrices;"Fund Prices"."Value Date")
            {
            }
            column(MidPrice_FundPrices;"Fund Prices"."Mid Price")
            {
            }
            column(BidPrice_FundPrices;"Fund Prices"."Bid Price")
            {
            }
            column(OfferPrice_FundPrices;"Fund Prices"."Offer Price")
            {
            }
            column(BidPriceFactor_FundPrices;"Fund Prices"."Bid Price Factor")
            {
            }
            column(OfferPriceFactor_FundPrices;"Fund Prices"."Offer Price Factor")
            {
            }
            column(Company;COMPANYPROPERTY.DisplayName)
            {
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

    labels
    {
    }
}

