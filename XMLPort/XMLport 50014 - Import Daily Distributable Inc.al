xmlport 50014 "Import Daily Distributable Inc"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Prices)
        {
            tableelement("Income Register";"Income Register")
            {
                XmlName = 'Income';
                fieldelement(Fund;"Income Register"."Fund ID")
                {
                }
                fieldelement(Valuedate;"Income Register"."Value Date")
                {
                }
                fieldelement(TotalIncome;"Income Register"."Total Income")
                {
                }
                fieldelement(TotalExpenses;"Income Register"."Total Expenses")
                {
                }
                fieldelement(DistributedIncome;"Income Register"."Distributed Income")
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

