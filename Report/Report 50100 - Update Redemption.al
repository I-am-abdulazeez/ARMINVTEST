report 50100 "Update Redemption"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Redemption.rdlc';

    dataset
    {
        dataitem(Redemption;Redemption)
        {

            trigger OnAfterGetRecord()
            begin
                Redemption."Document Link":=Redemption."Document Path";
                Redemption.Modify;
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

