report 50057 "Update Loan Status"
{
    // version THL-LOAN-1.0.0

    ProcessingOnly = true;

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE(Disbursed=CONST(true),Status=FILTER(<>"Fully Repaid"));

            trigger OnAfterGetRecord()
            begin
                LoanMgt.UpdateLoanStatus("Loan Application");
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
        LoanMgt: Codeunit "Loan Management";
}

