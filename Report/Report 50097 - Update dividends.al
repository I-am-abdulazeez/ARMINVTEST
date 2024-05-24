report 50097 "Update dividends"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update dividends.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
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
        Fund: Record Fund;
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
}

