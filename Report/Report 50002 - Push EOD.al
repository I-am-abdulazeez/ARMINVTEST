report 50002 "Push EOD"
{
    ProcessingOnly = true;
    UseRequestPage = false;

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
        FundTransactionManagement.RunEOD;
    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

