report 50056 "Variation Repayment Schedule"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Variation Repayment Schedule.rdlc';

    dataset
    {
        dataitem("Loan Variation";"Loan Variation")
        {
            RequestFilterFields = "No.","Old Loan No.","New Loan No.";
            column(LoanNo;"Loan Variation"."New Loan No.")
            {
            }
            column(ClientNo;"Loan Variation"."Staff ID")
            {
            }
            column(AccountNo;"Loan Variation"."Account No.")
            {
            }
            column(ClientName;"Loan Variation"."Client Name")
            {
            }
            column(LoanProductName;Loan."Loan Product Name")
            {
            }
            column(RepaymentMethod;"Loan Variation"."New Loan Type")
            {
            }
            column(Tenure;"Loan Variation"."New Tenure(Months)")
            {
            }
            column(PrincipalRepaymentFreq;Loan."Principal Repayment Frequency")
            {
            }
            column(InterestRepaymentFreq;Loan."Interest Repayment Frequency")
            {
            }
            column(InterestRate;"Loan Variation"."New Interest Rate")
            {
            }
            column(ApplicationDate;"Loan Variation".Date)
            {
            }
            column(RequestedAmount;"Loan Variation"."New Principal")
            {
            }
            column(ApprovedAmount;"Loan Variation"."New Principal")
            {
            }
            column(LoanPrincipal;"Loan Variation"."New Principal")
            {
            }
            column(LoanInterest;"Loan Variation"."New Interest")
            {
            }
            column(RepaymentStartDate;"Loan Variation"."New Loan Start Date")
            {
            }
            column(LoanValuation;"Loan Variation"."New Principal"+"Loan Variation"."New Interest")
            {
            }
            column(RepaidPeriods;"Loan Variation"."New Tenure(Months)")
            {
            }
            column(Fund;Loan."Fund Code")
            {
            }
            dataitem("Variation Repayment Schedule";"Variation Repayment Schedule")
            {
                DataItemLink = "Loan No."=FIELD("New Loan No.");
                column(Installment;"Variation Repayment Schedule"."Installment No.")
                {
                }
                column(Date;"Variation Repayment Schedule"."Repayment Date")
                {
                }
                column(Principal;"Variation Repayment Schedule".Principal)
                {
                }
                column(Interest;"Variation Repayment Schedule".Interest)
                {
                }
                column(Total;"Variation Repayment Schedule".Total)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Loan.Get("Loan Variation"."Old Loan No.");
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
        Loan: Record "Loan Application";
}

