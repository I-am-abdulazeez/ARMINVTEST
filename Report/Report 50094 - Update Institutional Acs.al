report 50094 "Update Institutional Acs"
{
    // version 14

    DefaultLayout = RDLC;
    RDLCLayout = './Update Institutional Acs.rdlc';

    dataset
    {
        dataitem("Fund Groups";"Fund Groups")
        {

            trigger OnAfterGetRecord()
            begin
                ClientAccount.Reset;
                ClientAccount.SetRange("Fund Group","Fund Groups".code);
                if ClientAccount.FindFirst then
                  repeat
                    ClientAccount.CalcFields("No of Units");
                    if ClientAccount."No of Units">1 then begin
                      ClientAccount.Validate("Institutional Active Fund",true);
                      ClientAccount.Modify;
                    end;
                  until ClientAccount.Next=0;
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

