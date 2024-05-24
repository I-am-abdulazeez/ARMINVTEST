xmlport 50006 "Export Client Transactions"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(ClientTransactions)
        {
            tableelement("Client Transactions";"Client Transactions")
            {
                XmlName = 'Lines';
                fieldelement(EntryNo;"Client Transactions"."Entry No")
                {
                }
                fieldelement(AccountNo;"Client Transactions"."Account No")
                {
                }
                fieldelement(ClientID;"Client Transactions"."Client ID")
                {
                }
                fieldelement(FundCode;"Client Transactions"."Fund Code")
                {
                }
                fieldelement(AgentCode;"Client Transactions"."Agent Code")
                {
                }
                fieldelement(Amount;"Client Transactions".Amount)
                {
                }
                fieldelement(Price;"Client Transactions"."Price Per Unit")
                {
                }
                fieldelement(NoofUnits;"Client Transactions"."No of Units")
                {
                }
                fieldelement(TransactionType;"Client Transactions"."Transaction Type")
                {
                }
                fieldelement(TransactionSubtype;"Client Transactions"."Transaction Sub Type")
                {
                }
                fieldelement(valueDate;"Client Transactions"."Value Date")
                {
                }
                fieldelement(TransactionDate;"Client Transactions"."Transaction Date")
                {
                }
                fieldelement(Reversed;"Client Transactions".Reversed)
                {
                }
                fieldelement(contributiontype;"Client Transactions"."Contribution Type")
                {
                }
                fieldelement(Narration;"Client Transactions".Narration)
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

