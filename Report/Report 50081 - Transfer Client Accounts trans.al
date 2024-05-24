report 50081 "Transfer Client Accounts trans"
{
    // version 4

    DefaultLayout = RDLC;
    RDLCLayout = './Transfer Client Accounts trans.rdlc';

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
                      ClientTransactions.Reset;
                      ClientTransactions.SetRange("Client ID",Client."Membership ID");
                      ClientTransactions.SetRange("Account No",ClientAccount."Account No");
                      if ClientTransactions.FindFirst then
                        repeat
                          entryno:=entryno+1;
                          ClientTransactions2.Init;
                          ClientTransactions2:=ClientTransactions;
                          ClientTransactions2."Entry No":=entryno;
                          ClientTransactions2."Client ID":=ClientAccount2."Client ID";
                          ClientTransactions2."Account No":=ClientAccount2."Account No";
                          ClientTransactions2."Fund Sub Code":=ClientAccount2."Fund Sub Account";
                          ClientTransactions2.Insert;

                        until ClientTransactions.Next=0;


                    end else
                    Error('No new Account exist for client account %1');





                  until ClientAccount.Next=0;
            end;

            trigger OnPreDataItem()
            begin
                //Client.SETRANGE("Membership ID",'1143660');
                entryno:=1500000;
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
}

