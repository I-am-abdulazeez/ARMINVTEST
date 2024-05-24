report 50126 "Charges on Interest Accrued"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Charges on Interest Accrued.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            DataItemTableView = WHERE("Charges On Interest"=FILTER(<0));
            RequestFilterFields = "Fund Code","Value Date";
            column(sNo;sNo)
            {
            }
            column(ValueDate_ClientTransactions;"Client Transactions"."Value Date")
            {
            }
            column(FundCode_ClientTransactions;"Client Transactions"."Fund Code")
            {
            }
            column(ClientID_ClientTransactions;"Client Transactions"."Client ID")
            {
            }
            column(AccountNo_ClientTransactions;"Client Transactions"."Account No")
            {
            }
            column(NetAmountOnHold_ClientTransactions;"Client Transactions"."Net Amount On Hold")
            {
            }
            column(ChargesOnInterest_ClientTransactions;"Client Transactions"."Charges On Interest")
            {
            }

            trigger OnAfterGetRecord()
            begin
                sNo := sNo +1;
                "Client Transactions".CalcFields("Net Amount On Hold");
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
        client: Record Client;
        sNo: Integer;
        ExceptionDetails: Text;
}

