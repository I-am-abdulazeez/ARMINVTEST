xmlport 50106 "Export Redemptions"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(REDResponse)
        {
            tableelement("Posted Redemption";"Posted Redemption")
            {
                XmlName = 'Lines';
                SourceTableView = WHERE(Posted=CONST(true));
                fieldelement(No;"Posted Redemption"."Recon No")
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
                fieldelement(NoOfUnits;"Posted Redemption"."No. Of Units")
                {
                }
                fieldelement(Amount;"Posted Redemption".Amount)
                {
                }
                fieldelement(DividendPaid;"Posted Redemption"."Accrued Dividend Paid")
                {
                }
                fieldelement(TotalAmountPayable;"Posted Redemption"."Total Amount Payable")
                {
                }
                fieldelement(ValueDate;"Posted Redemption"."Value Date")
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
                fieldelement(BankAccountNo;"Posted Redemption"."Bank Account No")
                {
                }
                fieldelement(BankAccountName;"Posted Redemption"."Bank Account Name")
                {
                }
                fieldelement(NetAmountPayable;"Posted Redemption"."Net Amount Payable")
                {
                }
                fieldelement(RedemptionType;"Posted Redemption"."Redemption Type")
                {
                }
                fieldelement(CreatedAt;"Posted Redemption"."Creation Date")
                {
                }
                fieldelement(PostedAt;"Posted Redemption"."Date And Time Posted")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    
                      /*ClientTransaction.GET;
                      ClientTransaction.SETRANGE("Client ID","Posted Redemption"."Client ID");
                      EntryNo := ClientTransaction."Entry No";*/
                    
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
        ClientTransaction: Record "Client Transactions";
}

