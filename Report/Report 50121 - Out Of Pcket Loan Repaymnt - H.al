report 50121 "Out Of Pcket Loan Repaymnt - H"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Out Of Pcket Loan Repaymnt - H.rdlc';

    dataset
    {
        dataitem("Historical Repayment Schedules";"Historical Repayment Schedules")
        {
            RequestFilterFields = "Settlement Date";
            column(ClientNo_LoanRepaymentSchedule;"Historical Repayment Schedules"."Client No.")
            {
            }
            column(ClientName_LoanRepaymentSchedule;"Historical Repayment Schedules"."Client Name")
            {
            }
            column(LoanNo_LoanRepaymentSchedule;"Historical Repayment Schedules"."Loan No.")
            {
            }
            column(SettlementDate_LoanRepaymentSchedule;"Historical Repayment Schedules"."Settlement Date")
            {
            }
            column(PrincipalSettlement_LoanRepaymentSchedule;"Historical Repayment Schedules"."Principal Settlement")
            {
            }
            column(InterestSettlement_LoanRepaymentSchedule;"Historical Repayment Schedules"."Interest Settlement")
            {
            }
            column(TotalSettlement_LoanRepaymentSchedule;"Historical Repayment Schedules"."Total Settlement")
            {
            }
            column(ValueRef;ValueRef)
            {
            }
            column(fundcode;fundcode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // IF "Loan Repayment Schedule"."Total Due" < "Loan Repayment Schedule"."Total Settlement" THEN
                //  CurrReport.SKIP;
                loanApp.Reset;
                loanApp.SetRange("Client No.");
                loanApp.SetRange("Loan No.","Historical Repayment Schedules"."Loan No.");
                if loanApp.FindFirst then
                  fundcode := loanApp."Fund Code";
                if "Historical Repayment Schedules"."Entry Type" = "Historical Repayment Schedules"."Entry Type"::Scheduled then
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
        ValueRef := "Historical Repayment Schedules".GetFilters;
    end;

    var
        ValueRef: Text;
        loanApp: Record "Historical Loans";
        fundcode: Code[20];
}

