report 50071 "AMT Payable"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AMT Payable.rdlc';

    dataset
    {
        dataitem("Posted Redemption";"Posted Redemption")
        {

            trigger OnAfterGetRecord()
            begin
                "Posted Redemption".CalcFields("Accrued Dividend Paid");
                "Posted Redemption"."Total Amount Payable":="Posted Redemption".Amount+"Posted Redemption"."Accrued Dividend Paid";
                //"Posted Redemption"."Sent to Treasury":=FALSE;
                "Posted Redemption".Modify;
            end;

            trigger OnPreDataItem()
            begin
                //"Posted Redemption".SETRANGE("Posted Redemption"."Value Date",040819D);
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

