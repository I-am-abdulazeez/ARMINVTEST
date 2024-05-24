report 50127 "Suspicious Withdrawals"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Suspicious Withdrawals.rdlc';

    dataset
    {
        dataitem("Suspicious Transactions";"Suspicious Transactions")
        {
            column(AccountNo_SuspiciousTransactions;"Suspicious Transactions"."Account No")
            {
            }
            column(ClientID_SuspiciousTransactions;"Suspicious Transactions"."Client ID")
            {
            }
            column(ValueDate_SuspiciousTransactions;"Suspicious Transactions"."Value Date")
            {
            }
            column(Reason_SuspiciousTransactions;"Suspicious Transactions".Reason)
            {
            }
            column(FundCode_SuspiciousTransactions;"Suspicious Transactions"."Fund Code")
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

    var
        ClientTrans: Record "Client Transactions";
        NoOfRedemptions: Integer;
}

