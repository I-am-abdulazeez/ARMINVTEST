report 50064 "update switch"
{
    DefaultLayout = RDLC;
    RDLCLayout = './update switch.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            column(EntryNo_ClientTransactions;"Client Transactions"."Entry No")
            {
            }
            column(AccountNo_ClientTransactions;"Client Transactions"."Account No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                redemption:=0;
                subscription:=0;
                startdate:=0D;
                startdate:=CalcDate('-1D',"Client Transactions"."Value Date");
                ClientAccount.Reset;
                ClientAccount.SetRange("Account No","Client Transactions"."Account No");
                ClientAccount.SetFilter("Date Filter",'..%1',startdate);
                if ClientAccount.FindFirst then begin

                  ClientAccount.CalcFields("No of Units");
                  ClientTransactions3.Reset;
                    ClientTransactions3.SetRange("Account No","Client Transactions"."Account No");
                    ClientTransactions3.SetRange("Value Date",reddate);
                    ClientTransactions3.SetRange("Transaction Type",ClientTransactions3."Transaction Type"::Redemption);;
                    if ClientTransactions3.FindFirst then
                      repeat
                        redemption:=redemption+ClientTransactions3."No of Units";
                      until ClientTransactions3.Next=0;
                  if (Abs(ClientAccount."No of Units")-Abs(redemption))<10 then begin
                    ClientTransactions2.Reset;
                    ClientTransactions2.SetRange("Client ID","Client Transactions"."Client ID");
                    if "Client Transactions"."Fund Code"='EMSPC' then
                      ClientTransactions2.SetRange("Fund Code",'EMRSC')
                    else
                      ClientTransactions2.SetRange("Fund Code",'EMSPC');
                    ClientTransactions2.SetRange("Value Date",subdate);
                    ClientTransactions2.SetRange("Transaction Type",ClientTransactions2."Transaction Type"::Subscription);
                    if ClientTransactions2.FindFirst then
                      repeat
                        subscription:=subscription+ClientTransactions2.Amount;
                      until ClientTransactions2.Next=0;

                      if (Abs(redemption*"Client Transactions"."Price Per Unit")-Abs(subscription))<100 then begin
                        "Client Transactions"."Transaction Sub Type 3":="Client Transactions"."Transaction Sub Type 3"::"Unit Switch";
                        "Client Transactions".Modify;
                         ClientTransactions2.Reset;
                         ClientTransactions2.Reset;
                    ClientTransactions2.SetRange("Client ID","Client Transactions"."Client ID");
                    if "Client Transactions"."Fund Code"='EMSPC' then
                      ClientTransactions2.SetRange("Fund Code",'EMRSC')
                    else
                      ClientTransactions2.SetRange("Fund Code",'EMSPC');
                    ClientTransactions2.SetRange("Value Date",subdate);
                    ClientTransactions2.SetRange("Transaction Type",ClientTransactions2."Transaction Type"::Subscription);
                    if ClientTransactions2.FindFirst then
                      repeat
                        ClientTransactions2."Transaction Sub Type 3":=ClientTransactions2."Transaction Sub Type 3"::"Unit Switch";
                        ClientTransactions2.Modify;
                      until ClientTransactions2.Next=0;


                      end
                      else CurrReport.Skip;
                      end
                   else CurrReport.Skip;



                end ;
            end;

            trigger OnPreDataItem()
            begin
                "Client Transactions".SetFilter("Client Transactions"."Fund Code",'=%1|%2','EMRSC','EMSPC');
                "Client Transactions".SetRange("Client Transactions"."Transaction Type","Client Transactions"."Transaction Type"::Redemption);
                "Client Transactions".SetRange("Client Transactions"."Value Date",reddate);
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

    trigger OnPreReport()
    begin
        reddate:=20130621D;
        subdate:=20130626D;
    end;

    var
        ClientAccount: Record "Client Account";
        startdate: Date;
        ClientTransactions2: Record "Client Transactions";
        ClientTransactions3: Record "Client Transactions";
        redemption: Decimal;
        subscription: Decimal;
        reddate: Date;
        subdate: Date;
}

