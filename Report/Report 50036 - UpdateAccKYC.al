report 50036 UpdateAccKYC
{
    DefaultLayout = RDLC;
    RDLCLayout = './UpdateAccKYC.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {

            trigger OnAfterGetRecord()
            begin
                clientAcc.Reset;
                clientAcc.SetRange("Client ID",Client."Membership ID");
                clientAcc.SetFilter("KYC Tier",'%1','');
                if clientAcc.FindFirst then begin
                  repeat
                    clientAcc.Validate("Client ID");
                    clientAcc.Modify;
                  until clientAcc.Next = 0;
                end;
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
        Message('Complete')
    end;

    var
        clientAcc: Record "Client Account";
}

