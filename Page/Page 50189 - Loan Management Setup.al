page 50189 "Loan Management Setup"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Loan Management Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Min Investment Bal for Loan";"Min Investment Bal for Loan")
                {
                }
                field("Non-Performing Loan Months";"Non-Performing Loan Months")
                {
                    ToolTip = 'This is the number of months a loan can default in repayment before it is declared as non-performing';
                }
            }
        }
    }

    actions
    {
    }
}

