report 50086 "Transfer Client subscriptions"
{
    // version 7

    DefaultLayout = RDLC;
    RDLCLayout = './Transfer Client subscriptions.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            DataItemTableView = WHERE("New Client ID"=FILTER(<>''));
            column(old;Client."Membership ID")
            {
            }
            column(new;Client."New Client ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                window.Update(1,Client."Membership ID");
                Accno:='';

                ClientAccount.Reset;
                ClientAccount.SetRange("Client ID",Client."Membership ID");
                if ClientAccount.FindFirst then  begin
                  repeat
                    ClientAccount2.Reset;
                    ClientAccount2.SetRange("Account No",ClientAccount."New Account No");
                    if ClientAccount2.FindFirst then begin

                        Subscription.Reset;
                        Subscription.SetRange("Client ID",Client."Membership ID");
                        Subscription.SetRange("Account No",ClientAccount."Account No");
                        if Subscription.FindFirst then begin
                          repeat

                           until Subscription.Next=0;
                        end else
                        CurrReport.Skip;

                    end else
                    Error('No new Account exist for client account %1');





                  until ClientAccount.Next=0;

                end  else
                CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                //Client.SETRANGE("Membership ID",'1143660');
                entryno:=1040000;
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

    trigger OnPostReport()
    begin
        window.Close
    end;

    trigger OnPreReport()
    begin
        window.Open('updating... #1######');
    end;

    var
        ClientAccount: Record "Client Account";
        ClientAccount2: Record "Client Account";
        Accno: Code[40];
        window: Dialog;
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        entryno: Integer;
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        DailyIncomeDistribLines2: Record "Daily Income Distrib Lines";
        Subscription: Record Subscription;
}

