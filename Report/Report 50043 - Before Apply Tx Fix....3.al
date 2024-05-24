report 50043 "Before Apply Tx Fix....3"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Before Apply Tx Fix....3.rdlc';

    dataset
    {
        dataitem("Client TransactionsX";"Client TransactionsX")
        {

            trigger OnAfterGetRecord()
            begin
                if "Client TransactionsX"."Entry No" <> "Client TransactionsX"."New Entry No" then begin
                 if Trans.Get("Client TransactionsX"."Entry No") then
                  Trans.Delete;
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
        Message('Complete');
    end;

    var
        Trans: Record "Client Transactions";
}

