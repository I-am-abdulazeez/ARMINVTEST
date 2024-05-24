report 50116 "Client transaction R"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client transaction R.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            column(ClientID_ClientTransactions;"Client Transactions"."Client ID")
            {
            }
            column(NoofUnits_ClientTransactions;"Client Transactions"."No of Units")
            {
            }

            trigger OnPreDataItem()
            begin
                "Client Transactions".SetRange("Client Transactions"."Fund Code",'ARMMMF');
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
}

