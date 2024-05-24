report 50044 "Total Funds in Holding"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Total Funds in Holding.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            DataItemTableView = WHERE("On Hold"=FILTER(true));
            column(ValueDate_ClientTransactions;"Client Transactions"."Value Date")
            {
            }
            column(AccountNo_ClientTransactions;"Client Transactions"."Account No")
            {
            }
            column(FundCode_ClientTransactions;"Client Transactions"."Fund Code")
            {
            }
            column(Amount_ClientTransactions;"Client Transactions".Amount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*BankCharge := 52.5;
                NetPayout := "Client Account"."Accrued Interest" - BankCharge;
                
                BankSortCode:='';
                BankName:='';
                Bank.RESET;
                IF Bank.GET("Client Account"."Bank Code") THEN
                BEGIN
                  BankName:=Bank.Name;
                  BankSortCode:=Bank."Sort Code";
                END;*/
                
                /*IF "Client Account".GET("Client Account"."Bank Code") THEN
                  BankName := bank.Name*/

            end;

            trigger OnPreDataItem()
            begin
                /*IF EndDate=0D THEN
                  EndDate:=TODAY;
                "Client Account".SETFILTER("Date Filter",'%1..%2',StartDate,EndDate);*/

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
}

