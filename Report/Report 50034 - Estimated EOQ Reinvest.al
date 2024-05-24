report 50034 "Estimated EOQ Reinvest"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Estimated EOQ Reinvest.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            DataItemTableView = WHERE("Dividend Mandate"=FILTER(<>Payout),"Fund No"=CONST('ARMMMF'),"Accrued Interest"=FILTER(>0));
            column(ClientID;"Client Account"."Client ID")
            {
            }
            column(AccountNo;"Client Account"."Account No")
            {
            }
            column(ClientName;"Client Account"."Client Name")
            {
            }
            column(DividendMandate;"Client Account"."Dividend Mandate")
            {
            }
            column(IncomeAccurred;"Client Account"."Accrued Interest")
            {
            }
            column(BankAccountNumber;"Client Account"."Bank Account Number")
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*IF "Client Account".GET("Client Account"."Bank Code") THEN
                  BankName := bank.Name*/

            end;

            trigger OnPreDataItem()
            begin
                if EndDate=0D then
                  EndDate:=Today;
                "Client Account".SetFilter("Date Filter",'%1..%2',StartDate,EndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Start Date";StartDate)
                    {
                    }
                    field("End Date";EndDate)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BankName: Code[40];
        StartDate: Date;
        EndDate: Date;
        IncomeAccurred: Decimal;
        bank: Record Bank;
        ClientAccount: Record "Client Account";
}

