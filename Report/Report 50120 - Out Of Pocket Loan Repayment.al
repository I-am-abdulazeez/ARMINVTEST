report 50120 "Out Of Pocket Loan Repayment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Out Of Pocket Loan Repayment.rdlc';

    dataset
    {
        dataitem("Loan Repayment Schedule";"Loan Repayment Schedule")
        {
            RequestFilterFields = "Settlement Date";
            column(ClientNo_LoanRepaymentSchedule;"Loan Repayment Schedule"."Client No.")
            {
            }
            column(ClientName_LoanRepaymentSchedule;"Loan Repayment Schedule"."Client Name")
            {
            }
            column(LoanNo_LoanRepaymentSchedule;"Loan Repayment Schedule"."Loan No.")
            {
            }
            column(SettlementDate_LoanRepaymentSchedule;"Loan Repayment Schedule"."Settlement Date")
            {
            }
            column(PrincipalSettlement_LoanRepaymentSchedule;"Loan Repayment Schedule"."Principal Settlement")
            {
            }
            column(InterestSettlement_LoanRepaymentSchedule;"Loan Repayment Schedule"."Interest Settlement")
            {
            }
            column(TotalSettlement_LoanRepaymentSchedule;"Loan Repayment Schedule"."Total Settlement")
            {
            }
            column(ValueRef;ValueRef)
            {
            }
            column(fundCode;fundCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // IF "Loan Repayment Schedule"."Total Due" < "Loan Repayment Schedule"."Total Settlement" THEN
                //  CurrReport.SKIP;
                loanApp.Reset;
                loanApp.SetRange("Client No.");
                loanApp.SetRange("Loan No.","Loan Repayment Schedule"."Loan No.");
                if loanApp.FindFirst then
                  fundCode := loanApp."Fund Code";
                if "Loan Repayment Schedule"."Entry Type" = "Loan Repayment Schedule"."Entry Type"::Scheduled then
                  CurrReport.Skip;
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

    trigger OnPreReport()
    begin
        ValueRef := "Loan Repayment Schedule".GetFilters;
    end;

    var
        ValueRef: Text;
        loanApp: Record "Loan Application";
        fundCode: Code[20];
}

