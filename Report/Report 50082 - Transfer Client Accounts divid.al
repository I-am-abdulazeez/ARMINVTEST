report 50082 "Transfer Client Accounts divid"
{
    // version 5

    DefaultLayout = RDLC;
    RDLCLayout = './Transfer Client Accounts divid.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            DataItemTableView = WHERE("New Client ID"=FILTER(<>''));
            column(new;Client."New Client ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                window.Update(1,Client."Membership ID");
                Accno:='';

                ClientAccount.Reset;
                ClientAccount.SetRange("Client ID",Client."Membership ID");
                if ClientAccount.FindFirst then
                  repeat
                    ClientAccount2.Reset;
                    ClientAccount2.SetRange("Account No",ClientAccount."New Account No");
                    if ClientAccount2.FindFirst then begin
                      DailyIncomeDistribLines.Reset;
                      DailyIncomeDistribLines.SetRange("Client ID",Client."Membership ID");
                      DailyIncomeDistribLines.SetRange("Account No",ClientAccount."Account No");
                      if DailyIncomeDistribLines.FindFirst then
                        repeat
                          entryno:=entryno+1;
                          DailyIncomeDistribLines2.Init;
                          DailyIncomeDistribLines2:=DailyIncomeDistribLines;
                          DailyIncomeDistribLines2."Line No":=entryno;
                          DailyIncomeDistribLines2."Client ID":=ClientAccount2."Client ID";
                          DailyIncomeDistribLines2."Account No":=ClientAccount2."Account No";
                          DailyIncomeDistribLines2.Insert;

                        until DailyIncomeDistribLines.Next=0;


                    end else
                    Error('No new Account exist for client account %1');





                  until ClientAccount.Next=0;
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
}

