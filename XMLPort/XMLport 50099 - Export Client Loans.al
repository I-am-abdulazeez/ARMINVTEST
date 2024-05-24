xmlport 50099 "Export Client Loans"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Loans)
        {
            tableelement("Loan Application";"Loan Application")
            {
                XmlName = 'LoanDetails';
                SourceTableView = WHERE(Disbursed=CONST(true));
                fieldelement(LoanNo;"Loan Application"."Loan No.")
                {
                }
                fieldelement(ClientID;"Loan Application"."Client No.")
                {
                }
                fieldelement(ClientName;"Loan Application"."Client Name")
                {
                }
                fieldelement(LoanProductType;"Loan Application"."Loan Product Type")
                {
                }
                fieldelement(LoanProductName;"Loan Application"."Loan Product Name")
                {
                }
                fieldelement(LoanRepaymentMethod;"Loan Application"."Repayment Method")
                {
                }
                fieldelement(PrincipalRepymentMethod;"Loan Application"."Principal Repayment Method")
                {
                }
                fieldelement(PrincipalRepymentFrequency;"Loan Application"."Principal Repayment Frequency")
                {
                }
                fieldelement(InterestRepymentFrequency;"Loan Application"."Interest Repayment Frequency")
                {
                }
                fieldelement(LoanPeriodInMonths;"Loan Application"."Loan Period (in Months)")
                {
                }
                fieldelement(NoOfPrincipalRepyments;"Loan Application"."No. of Principal Repayments")
                {
                }
                fieldelement(NoOfInterestRepyments;"Loan Application"."No. of Interest Repayments")
                {
                }
                fieldelement(InterestRate;"Loan Application"."Interest Rate")
                {
                }
                fieldelement(OnRepaymentHoliday;"Loan Application"."On Repayment Holiday")
                {
                }
                fieldelement(ApplicationDate;"Loan Application"."Application Date")
                {
                }
                fieldelement(RequestedAmount;"Loan Application"."Requested Amount")
                {
                }
                fieldelement(InvestmentBalance;"Loan Application"."Investment Balance")
                {
                }
                fieldelement(Principal;"Loan Application".Principal)
                {
                }
                fieldelement(Interest;"Loan Application".Interest)
                {
                }
                fieldelement(RepaymentStartDate;"Loan Application"."Repayment Start Date")
                {
                }
                fieldelement(Status;"Loan Application".Status)
                {
                }
                fieldelement(ExistingLoanAmount;"Loan Application"."Existing Loan Amount")
                {
                }
                fieldelement(ApprovedAmount;"Loan Application"."Approved Amount")
                {
                }
                fieldelement(DatePlacedOnHoliday;"Loan Application"."Date Placed On Holiday")
                {
                }
                fieldelement(LoanDisbursementDate;"Loan Application"."Loan Disbursement Date")
                {
                }
                fieldelement(PrincipalRepaymentMonth;"Loan Application"."Principal Repayment Month")
                {
                }
                fieldelement(Disbursed;"Loan Application".Disbursed)
                {
                }
                fieldelement(RepaymentEndDate;"Loan Application"."Repayment End Date")
                {
                }
                fieldelement(PaymentCompleted;"Loan Application"."Payment Completed")
                {
                }
                fieldelement(NoOfRepaidPeriods;"Loan Application"."No. of Repaid Periods")
                {
                }
                fieldelement(TotalInterestRepaid;"Loan Application"."Total Interest Repaid")
                {
                }
                fieldelement(TotalPrincipalRepaid;"Loan Application"."Total Principal Repaid")
                {
                }
                fieldelement(TotalAmountRepaid;"Loan Application"."Total Amount Repaid")
                {
                }
                fieldelement(NoOfOutstandingPeriods;"Loan Application"."No. of Outstanding Periods")
                {
                }
                fieldelement(OutstandingInterest;"Loan Application"."Outstanding Interest")
                {
                }
                fieldelement(OutstandingPrincipal;"Loan Application"."Outstanding Principal")
                {
                }
                fieldelement(TotalAmountOutstanding;"Loan Application"."Total Amount Outstanding")
                {
                }
                fieldelement(EffectiveLoanAmount;"Loan Application"."Effective Loan Amount")
                {
                }
                fieldelement(AccountNo;"Loan Application"."Account No")
                {
                }
                fieldelement(StaffID;"Loan Application"."Staff ID")
                {
                }
                fieldelement(LoanYears;"Loan Application"."Loan Years")
                {
                }
                fieldelement(AnnualInstallment;"Loan Application"."Annual Installment")
                {
                }
                fieldelement(MonthlyInstallment;"Loan Application"."Monthly Installment")
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
}

