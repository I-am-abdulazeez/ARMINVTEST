xmlport 50010 "Export Dividend Settled"
{
    Direction = Export;
    Format = VariableText;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Dividend Income Settled";"Dividend Income Settled")
            {
                XmlName = 'Lines';
                fieldelement(OwnNumber;"Dividend Income Settled".OwnNumber)
                {
                }
                fieldelement(SchemeDividend;"Dividend Income Settled".SchemeDividendID)
                {
                }
                fieldelement(LogId;"Dividend Income Settled"."Log ID")
                {
                }
                fieldelement(Reference;"Dividend Income Settled".ReferenceNumber)
                {
                }
                fieldelement(Plancode;"Dividend Income Settled".PlanCode)
                {
                }
                fieldelement(FolioNumber;"Dividend Income Settled"."Folio Number")
                {
                }
                fieldelement(TransactionType;"Dividend Income Settled"."Transaction Type")
                {
                }
                fieldelement(RecordDate;"Dividend Income Settled"."Record Date")
                {
                }
                fieldelement(ExDate;"Dividend Income Settled"."Ex Date")
                {
                }
                fieldelement(Nav;"Dividend Income Settled".Nav)
                {
                }
                fieldelement(Units;"Dividend Income Settled".Units)
                {
                }
                fieldelement(Amount;"Dividend Income Settled".Amount)
                {
                }
                fieldelement(LoadAmount;"Dividend Income Settled"."Load Amount")
                {
                }
                fieldelement(SettledDate;"Dividend Income Settled"."Settled Date")
                {
                }
                fieldelement(SettledAmount;"Dividend Income Settled"."Settled Amount")
                {
                }
                fieldelement(BankID;"Dividend Income Settled"."Bank ID")
                {
                }
                fieldelement(BankAcnumber;"Dividend Income Settled"."Bank Account Number")
                {
                }
                fieldelement(ReinvestPlan;"Dividend Income Settled"."Reinvest Plan Code")
                {
                }
                fieldelement(IsPreSettlement;"Dividend Income Settled".Response)
                {
                }
                fieldelement(RefundAmount;"Dividend Income Settled"."Is Valid")
                {
                }
                fieldelement(Processed;"Dividend Income Settled"."is Processed")
                {
                }
                fieldelement(Status;"Dividend Income Settled"."Transaction Status")
                {
                }
                fieldelement(Other;"Dividend Income Settled"."Other charges")
                {
                }
                fieldelement(Batchno;"Dividend Income Settled"."Dividend Settlement Batch No")
                {
                }
                fieldelement(settlementReference;"Dividend Income Settled"."Dividend Settlement Reference")
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

    var
        Bank: Record Bank;
}

