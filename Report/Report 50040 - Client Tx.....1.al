report 50040 "Client Tx.....1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Tx.....1.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            DataItemTableView = WHERE("Value Date"=CONST(20120727D),"Fund Code"=FILTER('EMRSC'|'EMSPC'));

            trigger OnAfterGetRecord()
            begin
                TransX.Init;
                TransX.TransferFields("Client Transactions");
                TransX.Insert;
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
        TransX: Record "Client TransactionsX";
}

