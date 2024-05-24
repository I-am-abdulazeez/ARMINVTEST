xmlport 50105 "Export MF Dividend Payment"
{
    // version MFD-1.0

    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement("<nomineedividend>")
        {
            XmlName = 'DividendPayment';
            tableelement("MF Dividend";"MF Dividend")
            {
                XmlName = 'Dividend';
                fieldelement(PortfolioCode;"MF Dividend".PortfolioCode)
                {
                }
                fieldelement(MutualfundCode;"MF Dividend".FundCode)
                {
                }
                fieldelement(AssetClassId;"MF Dividend".AssetClassId)
                {
                }
                fieldelement(DeclaredDate;"MF Dividend".DeclaredDate)
                {
                }
                fieldelement(TransDate;"MF Dividend".TransactionDate)
                {
                }
                fieldelement(Amount;"MF Dividend".Amount)
                {
                }
                fieldelement(ReInvestmentPrice;"MF Dividend".ReinvestmentPrice)
                {
                }
                fieldelement(UnitsHolding;"MF Dividend".Unit)
                {
                }
                fieldelement(TaxAmount;"MF Dividend".TaxAmount)
                {
                }
                fieldelement(IsReinvestment;"MF Dividend".IsReinvestment)
                {
                }
                fieldelement(ProcessedDate;"MF Dividend".CreatedDate)
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

