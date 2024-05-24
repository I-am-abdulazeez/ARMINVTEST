report 50084 "Update Client Accounts old mem"
{
    // version 2

    DefaultLayout = RDLC;
    RDLCLayout = './Update Client Accounts old mem.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
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

                    ClientAccount."Old MembershipID":=ClientAccount."Client ID";
                    ClientAccount.Modify;





                  until ClientAccount.Next=0;
            end;

            trigger OnPreDataItem()
            begin
                //Client.SETRANGE("Membership ID",'1143660');
                //Client.SETRANGE("New Client ID",'1003002');
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
        ClientAccount3: Record "Client Account";
}

