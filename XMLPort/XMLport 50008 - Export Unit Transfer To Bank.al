xmlport 50008 "Export Unit Transfer To Bank"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(PostedTransfers)
        {
            tableelement("Posted Fund Transfer";"Posted Fund Transfer")
            {
                XmlName = 'Lines';
                SourceTableView = WHERE("Sent to treasury"=CONST(false),Type=CONST("Across Funds"));
                fieldelement(TransactionNo;"Posted Fund Transfer".No)
                {
                }
                fieldelement(AccountNo;"Posted Fund Transfer"."To Account No")
                {
                }
                fieldelement(ClientID;"Posted Fund Transfer"."To Client ID")
                {
                }
                fieldelement(ClientName;"Posted Fund Transfer"."To Client Name")
                {
                }
                fieldelement(FundCode;"Posted Fund Transfer"."To Fund Code")
                {
                }
                fieldelement(Price;"Posted Fund Transfer"."Price Per Unit")
                {
                }
                fieldelement(NoofUnits;"Posted Fund Transfer"."No. Of Units")
                {
                }
                fieldelement(Amount;"Posted Fund Transfer".Amount)
                {
                }
                textelement(DividendPaid)
                {
                }
                fieldelement(TotalAmountPayable;"Posted Fund Transfer"."Total Amount Payable")
                {
                }
                fieldelement(valueDate;"Posted Fund Transfer"."Value Date")
                {
                }
                fieldelement(TransactionDate;"Posted Fund Transfer"."Transaction Date")
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
                    if Bank.Get("Posted Fund Transfer"."Bank Code") then
                    begin
                      BankName:=Bank.Name;
                      BankSortCode:=Bank."Sort Code";
                    end;
                    DividendPaid:=Format("Posted Fund Transfer"."Total Amount Payable"-"Posted Fund Transfer".Amount);
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

