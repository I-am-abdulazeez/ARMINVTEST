report 50119 "Daily Transaction Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Daily Transaction Details.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            RequestFilterFields = "Value Date";
            column(TransactionDate_ClientTransactions;"Client Transactions"."Transaction Date")
            {
            }
            column(ValueDate_ClientTransactions;"Client Transactions"."Value Date")
            {
            }
            column(TransactionType_ClientTransactions;"Client Transactions"."Transaction Type")
            {
            }
            column(Narration_ClientTransactions;"Client Transactions".Narration)
            {
            }
            column(Amount_ClientTransactions;"Client Transactions".Amount)
            {
            }
            column(TransactionNo_ClientTransactions;"Client Transactions"."Transaction No")
            {
            }
            column(CreatedBy_ClientTransactions;"Client Transactions"."Created By")
            {
            }
            column(CreatedDateTime_ClientTransactions;"Client Transactions"."Created Date Time")
            {
            }
            column(Reversed_ClientTransactions;"Client Transactions".Reversed)
            {
            }
            column(No;No)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }

            trigger OnAfterGetRecord()
            begin
                No:= No +1;
            end;

            trigger OnPreDataItem()
            begin
                ItemFilter := "Client Transactions".GetFilters;
            end;
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

    var
        No: Integer;
        ItemFilter: Text;
}

