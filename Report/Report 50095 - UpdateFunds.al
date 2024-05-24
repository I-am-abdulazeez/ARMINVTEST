report 50095 UpdateFunds
{
    DefaultLayout = RDLC;
    RDLCLayout = './UpdateFunds.rdlc';

    dataset
    {
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

    trigger OnPreReport()
    begin
        Fund.ModifyAll("Fund Group",'');
    end;

    var
        Fund: Record Fund;
}

