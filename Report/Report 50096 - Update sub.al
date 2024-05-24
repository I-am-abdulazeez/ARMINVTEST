report 50096 "Update sub"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update sub.rdlc';

    dataset
    {
        dataitem(Subscription;Subscription)
        {

            trigger OnAfterGetRecord()
            begin
                Subscription."No. Of Units":=Round(Subscription."No. Of Units",0.0004,'=');
                Subscription.Modify;
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
        Fund: Record Fund;
}

