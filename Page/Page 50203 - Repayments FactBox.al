page 50203 "Repayments FactBox"
{
    // version THL-LOAN-1.0.0

    PageType = CardPart;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            group("Loan Statistics")
            {
                Caption = 'Loan Statistics';
                field("Effective Loan Amount";"Effective Loan Amount")
                {
                }
            }
            group("Repayment Statistics")
            {
                Caption = 'Repayment Statistics';
                field("Repayment Start Date";"Repayment Start Date")
                {
                }
                field("No. of Repaid Periods";"No. of Repaid Periods")
                {
                }
                field("Total Interest Repaid";"Total Interest Repaid")
                {
                }
                field("Total Principal Repaid";"Total Principal Repaid")
                {
                }
                field("Total Amount Repaid";"Total Amount Repaid")
                {
                }
            }
            group("Outstanding Loan Statistics")
            {
                Caption = 'Outstanding Loan Statistics';
                field("No. of Outstanding Periods";"No. of Outstanding Periods")
                {
                    Caption = 'Outstanding Tenure (Months)';
                }
                field("Outstanding Interest";"Outstanding Interest")
                {
                    Caption = 'Outstanding Interest';
                }
                field("Outstanding Principal";"Outstanding Principal")
                {
                    Caption = 'Outstanding Principal';
                }
                field("Total Amount Outstanding";"Total Amount Outstanding")
                {
                    Caption = 'Loan Valuation';
                }
            }
        }
    }

    actions
    {
    }
}

