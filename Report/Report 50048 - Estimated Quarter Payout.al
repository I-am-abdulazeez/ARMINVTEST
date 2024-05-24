report 50048 "Estimated Quarter Payout"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Estimated Quarter Payout.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            DataItemTableView = WHERE("Dividend Mandate"=CONST(Payout),"Accrued Interest"=FILTER(>=500),"Fund No"=CONST('ARMMMF'));
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
            column(BankCharge;BankCharge)
            {
            }
            column(NetPayout;NetPayout)
            {
            }
            column(BankName;BankName)
            {
            }
            column(BankAccountNumber;"Client Account"."Bank Account Number")
            {
            }
            column(BankSortCode;BankSortCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BankCharge := 52.5;
                NetPayout := "Client Account"."Accrued Interest" - BankCharge;
                
                BankSortCode:='';
                BankName:='';
                Bank.Reset;
                if Bank.Get("Client Account"."Bank Code") then
                begin
                  BankName:=Bank.Name;
                  BankSortCode:=Bank."Sort Code";
                end;
                
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
        Bank: Record Bank;
        BankCharge: Decimal;
        NetPayout: Decimal;
        BankSortCode: Code[40];
}

