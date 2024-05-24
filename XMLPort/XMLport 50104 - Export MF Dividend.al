xmlport 50104 "Export MF Dividend"
{
    // version MFD-1.0

    Direction = Export;
    FileName = 'Daily Dividend.csv';
    Format = VariableText;

    schema
    {
        textelement(Incomelines)
        {
            tableelement("MF Income Distrib Lines";"MF Income Distrib Lines")
            {
                XmlName = 'IncomeLines';
                fieldelement(LineNo;"MF Income Distrib Lines"."Line No")
                {
                }
                fieldelement(ValueDate;"MF Income Distrib Lines"."Value Date")
                {
                }
                fieldelement(AccountNo;"MF Income Distrib Lines"."Account No")
                {
                }
                fieldelement(ClientID;"MF Income Distrib Lines"."Client ID")
                {
                }
                fieldelement(ClientName;"MF Income Distrib Lines"."Client Name")
                {
                }
                fieldelement(FundCode;"MF Income Distrib Lines"."Fund Code")
                {
                }
                fieldelement(Units;"MF Income Distrib Lines"."No of Units")
                {
                }
                fieldelement(DividendPerUnit;"MF Income Distrib Lines"."Income Per unit")
                {
                }
                fieldelement(IncomeAccrued;"MF Income Distrib Lines"."Income accrued")
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

