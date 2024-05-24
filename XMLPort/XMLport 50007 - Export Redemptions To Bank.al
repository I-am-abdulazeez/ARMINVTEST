xmlport 50007 "Export Redemptions To Bank"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(RedemptionsPushtoBank)
        {
            tableelement("Posted Redemption";"Posted Redemption")
            {
                XmlName = 'Lines';
                SourceTableView = WHERE("Sent to Treasury"=CONST(false));
                fieldelement(TransactionNo;"Posted Redemption".No)
                {
                }
                fieldelement(AccountNo;"Posted Redemption"."Account No")
                {
                }
                fieldelement(ClientID;"Posted Redemption"."Client ID")
                {
                }
                fieldelement(ClientName;"Posted Redemption"."Client Name")
                {
                }
                fieldelement(FundCode;"Posted Redemption"."Fund Code")
                {
                }
                fieldelement(Price;"Posted Redemption"."Price Per Unit")
                {
                }
                fieldelement(NoofUnits;"Posted Redemption"."No. Of Units")
                {
                }
                fieldelement(Amount;"Posted Redemption".Amount)
                {
                }
                fieldelement(DividendPaid;"Posted Redemption"."Accrued Dividend Paid")
                {
                }
                fieldelement(valueDate;"Posted Redemption"."Value Date")
                {
                }
                fieldelement(TransactionDate;"Posted Redemption"."Transaction Date")
                {
                }
                textelement(BankName)
                {
                }
                textelement(BankSortCode)
                {
                }
                textelement(BankAccountNo)
                {
                }
                textelement(BankAccountName)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    BankSortCode:='';
                    BankName:='';
                    Bank.Reset;
                    if Bank.Get("Posted Redemption"."Bank Code") then
                    begin
                      BankName:=Bank.Name;
                      BankSortCode:=Bank."Sort Code";
                    end
                end;
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

