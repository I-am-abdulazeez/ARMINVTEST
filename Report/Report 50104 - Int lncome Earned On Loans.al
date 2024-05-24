report 50104 "Int lncome Earned On Loans"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Int lncome Earned On Loans.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE(Disbursed=CONST(true));
            RequestFilterFields = "Application Date",Status;
            column(Logo;CompInfo.Picture)
            {
            }
            column(StaffID;"Loan Application"."Staff ID")
            {
            }
            column(Name;"Loan Application"."Client Name")
            {
            }
            column(LoanAmount;"Loan Application"."Approved Amount")
            {
            }
            column(Tenure;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(Fund;"Loan Application"."Fund Code")
            {
            }
            column(RepaymentStyle;"Loan Application"."Principal Repayment Method")
            {
            }
            column(StartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(InterestRate;"Loan Application"."Interest Rate")
            {
            }
            column(Principal;"Loan Application".Principal)
            {
            }
            column(Interest;"Loan Application".Interest)
            {
            }
            column(LoanValuation;LoanValuation)
            {
            }
            column(PrincipalPayment;"Loan Application"."Total Principal Repaid")
            {
            }
            column(InterestPayment;"Loan Application"."Total Interest Repaid")
            {
            }
            column(TotalPayment;"Loan Application"."Total Amount Repaid")
            {
            }
            column(OutstandingTenure;"Loan Application"."No. of Outstanding Periods")
            {
            }
            column(OutstandingPrincipal;"Loan Application"."Outstanding Principal")
            {
            }
            column(OutstandingInterest;"Loan Application"."Outstanding Interest")
            {
            }
            column(TotalAmountOutstanding;"Loan Application"."Total Amount Outstanding")
            {
            }
            column(TotalLoanValuation;"Loan Application"."Effective Loan Amount")
            {
            }
            column(liquidationDate;liquidationDate)
            {
            }
            column(SerialNo;SerialNo)
            {
            }
            column(InterestEarned;InterestEarned)
            {
            }

            trigger OnAfterGetRecord()
            begin

                //get liquidated date
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                //Schedule.SETRANGE("Fully Paid",TRUE);
                if Schedule.FindLast then begin
                  liquidationDate := Schedule."Settlement Date";
                end;
                SerialNo := SerialNo+1;
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                Schedule.SetRange(Settled,false);
                if Schedule.FindFirst then begin
                  FirstUnsettledAmount:=Schedule."Loan Amount";
                end;
                //MAXWELL: 26/08/2019 - Dynamically Get Loan Due Date
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                Schedule.SetRange("Repayment Date",0D,DateFilter);
                ScheduleUnsettled.Copy(Schedule);
                Schedule.SetRange(Settled,true);
                ScheduleUnsettled.SetRange (Settled,false);
                if Schedule.FindLast then
                  LoanDueDate := Schedule."Repayment Date"
                else
                  LoanDueDate := "Loan Application"."Repayment Start Date";
                //MESSAGE('%1',LoanDueDate);
                //

                if ScheduleUnsettled.FindFirst then
                InterestPerDay := Round((ScheduleUnsettled."Interest Due"/31),0.01,'=');
                DueDuration := DateFilter - LoanDueDate;
                DueDurationAmount := DueDuration * InterestPerDay;

                //Maxwell: To get the Loan Product Type.
                LoanProduct.Reset;
                LoanProduct.SetRange(Code, Schedule."Loan Product Type");
                if LoanProduct.FindFirst then
                  ClientLoanProduct := LoanProduct."Loan Type";

                if ClientLoanProduct = ClientLoanProduct::Bullet then begin
                  LoanValuation := FirstUnsettledAmount + DueDurationAmount
                end else
                   LoanValuation := (FirstUnsettledAmount*("Loan Application"."Interest Rate"/100)*(DueDuration/365)) + FirstUnsettledAmount;

                //interest earned
                interestSchedule.Reset;
                interestSchedule.SetRange("Loan No.","Loan Application"."Loan No.");
                // IF interestSchedule."Settlement Date" = 0D THEN
                //  CurrReport.SKIP;
                // IF interestSchedule."Settlement Date" > EndDate THEN
                //  CurrReport.SKIP;
                interestSchedule.SetRange("Settlement Date",StartDate,EndDate);
                interestSchedule.CalcSums("Interest Settlement");
                InterestEarned := interestSchedule."Interest Settlement";
            end;

            trigger OnPreDataItem()
            begin
                 if "Loan Application".GetFilter("Date Filter")<>'' then
                 DateFilter:="Loan Application".GetRangeMax("Date Filter")
                 else
                  DateFilter:= Today;
                liquidationDate := 0D;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate;StartDate)
                {
                }
                field(EndDate;EndDate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        DateFilter: Date;
        Schedule: Record "Loan Repayment Schedule";
        FirstUnsettledAmount: Decimal;
        LoanDueDate: Date;
        NoofRepayment: Integer;
        counter: Integer;
        reccount: Integer;
        EndingBalance: Decimal;
        CumulativeInterest: Decimal;
        InterestPerDay: Decimal;
        LoanValuation: Decimal;
        DueDuration: Integer;
        DueDurationAmount: Decimal;
        LoanProduct: Record "Loan Product";
        ClientLoanProduct: Option Annuitized,Bullet,"Zero Interest";
        ScheduleUnsettled: Record "Loan Repayment Schedule";
        liquidationDate: Date;
        SerialNo: Integer;
        InterestEarned: Decimal;
        interestSchedule: Record "Loan Repayment Schedule";
        StartDate: Date;
        EndDate: Date;
}

