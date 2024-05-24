xmlport 50101 "Export Nominee Client Dividend"
{
    // version MFD-1.0

    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement("<nomineedividend>")
        {
            XmlName = 'NomineeDividend';
            tableelement("Nominee Client Dividend";"Nominee Client Dividend")
            {
                XmlName = 'Nominee';
                SourceTableView = WHERE(Sent=CONST(false));
                fieldelement(PortfolioCode;"Nominee Client Dividend".PortfolioCode)
                {
                }
                fieldelement(MutualfundCode;"Nominee Client Dividend".SecurityCode)
                {
                }
                fieldelement(AssetClassId;"Nominee Client Dividend".InstrumentId)
                {
                }
                fieldelement(DeclaredDate;"Nominee Client Dividend".DeclaredDate)
                {
                }
                fieldelement(PaymentDate;"Nominee Client Dividend".PaymentDate)
                {
                }
                fieldelement(HoldingUnits;"Nominee Client Dividend".HoldingUnits)
                {
                }
                fieldelement(Amount;"Nominee Client Dividend".Amount)
                {
                }
                fieldelement(TaxAmount;"Nominee Client Dividend".TaxAmount)
                {
                }
                fieldelement(ProcessedDate;"Nominee Client Dividend".CreatedDate)
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

