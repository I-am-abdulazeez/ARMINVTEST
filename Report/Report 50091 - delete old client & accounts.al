report 50091 "delete old client & accounts"
{
    // version 12

    DefaultLayout = RDLC;
    RDLCLayout = './delete old client & accounts.rdlc';

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

                //delete account

                ClientAccount."New Account No":=Accno;
                ClientAccount.Modify;

                  until ClientAccount.Next=0;
                  //delete client
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

