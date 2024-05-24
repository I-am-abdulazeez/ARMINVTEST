report 50045 "Penalty Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Penalty Charges.rdlc';

    dataset
    {
        dataitem("Charges on Accrued Interest";"Charges on Accrued Interest")
        {
            RequestFilterFields = "Account No","Paid To Fund Managers";
            column(ValueDate_ChargesonAccruedInterest;"Charges on Accrued Interest"."Value Date")
            {
            }
            column(AccountNo_ChargesonAccruedInterest;"Charges on Accrued Interest"."Account No")
            {
            }
            column(FundCode_ChargesonAccruedInterest;"Charges on Accrued Interest"."Fund Code")
            {
            }
            column(AmountCharged_ChargesonAccruedInterest;"Charges on Accrued Interest"."Amount Charged")
            {
            }
            column(PaidToFundManagers_ChargesonAccruedInterest;"Charges on Accrued Interest"."Paid To Fund Managers")
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

