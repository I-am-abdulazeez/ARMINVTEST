report 50029 "Archive Fully Repaid Loans"
{
    // version THL-LOAN-1.0.0

    ProcessingOnly = true;

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE(Disbursed=CONST(true),Status=CONST("Fully Repaid"));

            trigger OnAfterGetRecord()
            begin
                LoanMgt.ArchiveFullyRepaidLoan("Loan Application");
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
        Message('Completed');
    end;

    var
        LoanMgt: Codeunit "Loan Management";
}

