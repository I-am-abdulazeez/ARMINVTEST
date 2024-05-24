report 50069 "update red"
{
    DefaultLayout = RDLC;
    RDLCLayout = './update red.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {

            trigger OnAfterGetRecord()
            begin
                ClientAccount.Reset;
                ClientAccount.SetRange("Client ID",Client."Membership ID");
                if ClientAccount.FindFirst then
                  repeat
                    ClientAccount."Agent Code":=Client."Account Executive Code";
                    ClientAccount.Modify;
                  until ClientAccount.Next=0
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

    var
        ClientAccount: Record "Client Account";
}

