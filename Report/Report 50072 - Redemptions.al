report 50072 Redemptions
{
    DefaultLayout = RDLC;
    RDLCLayout = './Redemptions.rdlc';

    dataset
    {
        dataitem(Redemption;Redemption)
        {

            trigger OnAfterGetRecord()
            begin
                Redemption."Redemption Status":=Redemption."Redemption Status"::Rejected;
                Redemption."Bank Code":='GTBINGLA';
                Redemption."Bank Account No":='0006588859';
                //Redemption.MODIFY;
            end;

            trigger OnPreDataItem()
            begin
                Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
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

