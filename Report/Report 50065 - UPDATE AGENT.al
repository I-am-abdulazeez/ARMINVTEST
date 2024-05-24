report 50065 "UPDATE AGENT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './UPDATE AGENT.rdlc';

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
                  until ClientAccount.Next=0;
            end;
        }
        dataitem("Account Manager";"Account Manager")
        {

            trigger OnAfterGetRecord()
            begin
                "Account Manager"."Commission Structure":='AGC';
                "Account Manager".Modify;
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

