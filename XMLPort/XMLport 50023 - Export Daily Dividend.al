xmlport 50023 "Export Daily Dividend"
{
    Direction = Export;
    FileName = 'Daily Dividend.csv';
    Format = VariableText;

    schema
    {
        textelement(Incomelines)
        {
            tableelement("Daily Income Distrib Lines";"Daily Income Distrib Lines")
            {
                XmlName = 'IncomeLines';
                fieldelement(LineNo;"Daily Income Distrib Lines"."Line No")
                {
                }
                fieldelement(ValueDate;"Daily Income Distrib Lines"."Value Date")
                {
                }
                fieldelement(AccountNo;"Daily Income Distrib Lines"."Account No")
                {
                }
                fieldelement(ClientID;"Daily Income Distrib Lines"."Client ID")
                {
                }
                fieldelement(ClientName;"Daily Income Distrib Lines"."Client Name")
                {
                }
                fieldelement(FundCode;"Daily Income Distrib Lines"."Fund Code")
                {
                }
                fieldelement(Units;"Daily Income Distrib Lines"."No of Units")
                {
                }
                fieldelement(DividendPerUnit;"Daily Income Distrib Lines"."Income Per unit")
                {
                }
                fieldelement(IncomeAccrued;"Daily Income Distrib Lines"."Income accrued")
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

