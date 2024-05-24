report 50053 "Loan Repayment Schedule"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Loan Repayment Schedule.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            RequestFilterFields = "Loan No.";
            column(LoanNo;"Loan Application"."Loan No.")
            {
            }
            column(ClientNo;"Loan Application"."Staff ID")
            {
            }
            column(AccountNo;"Loan Application"."Account No")
            {
            }
            column(ClientName;"Loan Application"."Client Name")
            {
            }
            column(LoanProductName;"Loan Application"."Loan Product Name")
            {
            }
            column(RepaymentMethod;"Loan Application"."Repayment Method")
            {
            }
            column(Tenure;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(PrincipalRepaymentFreq;"Loan Application"."Principal Repayment Frequency")
            {
            }
            column(InterestRepaymentFreq;"Loan Application"."Interest Repayment Frequency")
            {
            }
            column(InterestRate;"Loan Application"."Interest Rate")
            {
            }
            column(ApplicationDate;"Loan Application"."Application Date")
            {
            }
            column(RequestedAmount;"Loan Application"."Requested Amount")
            {
            }
            column(ApprovedAmount;"Loan Application"."Approved Amount")
            {
            }
            column(LoanPrincipal;"Loan Application".Principal)
            {
            }
            column(LoanInterest;"Loan Application".Interest)
            {
            }
            column(RepaymentStartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(LoanValuation;"Loan Application"."Total Amount Outstanding")
            {
            }
            column(RepaidPeriods;"Loan Application"."No. of Repaid Periods")
            {
            }
            column(Fund;"Loan Application"."Fund Code")
            {
            }
            dataitem("Loan Repayment Schedule";"Loan Repayment Schedule")
            {
                DataItemLink = "Loan No."=FIELD("Loan No.");
                column(Installment;"Loan Repayment Schedule"."Installment No.")
                {
                }
                column(Date;"Loan Repayment Schedule"."Repayment Date")
                {
                }
                column(Principal;"Loan Repayment Schedule"."Principal Due")
                {
                }
                column(Interest;"Loan Repayment Schedule"."Interest Due")
                {
                }
                column(Total;"Loan Repayment Schedule"."Total Due")
                {
                }
            }
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

