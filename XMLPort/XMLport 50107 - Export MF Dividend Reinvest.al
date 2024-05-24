xmlport 50107 "Export MF Dividend Reinvest"
{
    // version MFD-1.0

    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement("<dividendreinvest>")
        {
            XmlName = 'DividendReinvest';
            tableelement("MF Dividend Reinvest Summary";"MF Dividend Reinvest Summary")
            {
                XmlName = 'Dividend';
                fieldelement(MutualfundCode;"MF Dividend Reinvest Summary".FundCode)
                {
                }
                fieldelement(DeclaredDate;"MF Dividend Reinvest Summary".DeclaredDate)
                {
                }
                fieldelement(TransDate;"MF Dividend Reinvest Summary".TransactionDate)
                {
                }
                fieldelement(Amount;"MF Dividend Reinvest Summary".Amount)
                {
                }
                fieldelement(UnitsHolding;"MF Dividend Reinvest Summary".Unit)
                {
                }
                fieldelement(TaxAmount;"MF Dividend Reinvest Summary".TaxAmount)
                {
                }
                fieldelement(IsReinvestment;"MF Dividend Reinvest Summary".IsReinvestment)
                {
                }
                fieldelement(BankAccountNo;"MF Dividend Reinvest Summary"."Bank Account No")
                {
                }
                fieldelement(ProcessedDate;"MF Dividend Reinvest Summary".CreatedDate)
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

