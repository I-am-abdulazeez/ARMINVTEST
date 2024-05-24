report 50114 "Detail Interest Income-Annuity"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Detail Interest Income-Annuity.rdlc';

    dataset
    {
        dataitem("Loan Application";"Reversed Accrued Income")
        {
            DataItemTableView = WHERE("Accrued Income"=CONST("0"));
            RequestFilterFields = No,"Client ID",Field15;
            column(LoanNo;"Loan Application".No)
            {
            }
            column(Filters;DateFilter)
            {
            }
            column(counter;counter)
            {
            }
            column(Logo;CompInfo.Picture)
            {
            }
            column(StaffID;StaffID)
            {
            }
            column(Name;"Loan Application"."Account No")
            {
            }
            column(LoanAmount;"Loan Application"."Approved Amount")
            {
            }
            column(Tenure;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(Fund;Fund)
            {
            }
            column(RepaymentStyle;"Loan Application"."Accrued Income")
            {
            }
            column(StartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(InterestRate;"Loan Application"."Interest Rate")
            {
            }
            column(Interest;"Loan Application".Interest)
            {
            }
            column(InterestPayment;InterestPayment)
            {
            }
            column(OriginalIssueDate;"Loan Application"."Application Date")
            {
            }
            column(TerminationDate;TerminationDate)
            {
            }
            column(PrincipalTerminated;PrincipalTerminated)
            {
            }
            column(CalculationStartDate;CalculationStartDate)
            {
            }
            column(CalculationEndDate;CalculationEndDate)
            {
            }
            column(VestedTenure;VestedTenure)
            {
            }
            column(DaysInTheYear;DaysInTheYear)
            {
            }
            dataitem("Accounting Period";"Accounting Period")
            {
                column(PeriodName;PeriodName)
                {
                }
                column(Principal;RunningPrincipal)
                {
                }
                column(InterestIncomeInThePeriod;InterestIncomeInThePeriod)
                {
                }
                column(PeriodDays;PeriodDays)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RunningPrincipal := 0;
                    PeriodName := '';
                    InterestIncomeInThePeriod := 0;
                    PeriodDays := CalcDate('CM',"Accounting Period"."Starting Date")-"Accounting Period"."Starting Date"+1;
                    
                    PeriodName := "Accounting Period".Name+'-'+Format(Date2DMY("Accounting Period"."Starting Date",3));
                    
                    if ActiveLoans.Get("Loan Application".No) then begin
                      Schedule.Reset;
                      Schedule.SetRange("Loan No.","Loan Application".No);
                      Schedule.SetRange("Repayment Date","Accounting Period"."Starting Date",CalcDate('CM',"Accounting Period"."Starting Date"));
                      if Schedule.FindSet then begin
                        RunningPrincipal := RunningPrincipal + Schedule."Loan Amount"
                      end;/* ELSE
                        RunningPrincipal := ActiveLoans."Approved Amount";*/
                    end else if HistoricalLoans.Get("Loan Application".No) then begin
                    
                      ScheduleHist.Reset;
                      ScheduleHist.SetRange("Loan No.","Loan Application".No);
                      ScheduleHist.SetRange("Repayment Date","Accounting Period"."Starting Date",CalcDate('CM',"Accounting Period"."Starting Date"));
                      if ScheduleHist.FindSet then begin
                        RunningPrincipal := RunningPrincipal + ScheduleHist."Loan Amount";
                      end;/* ELSE
                        RunningPrincipal := HistoricalLoans."Approved Amount";*/
                    end;
                    InterestIncomeInThePeriod := Round(RunningPrincipal*"Loan Application"."Interest Rate"/100*(PeriodDays/DaysInTheYear),0.01);

                end;

                trigger OnPreDataItem()
                begin
                    "Accounting Period".SetRange("Starting Date",StartDate,DateFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                InterestPayment := 0;
                RunningPrincipal := 0;
                TerminationDate := 0D;
                PrincipalTerminated := 0;
                CalculationStartDate := StartDate;
                CalculationEndDate := DateFilter;
                VestedTenure := 0;
                InterestIncomeInThePeriod := 0;

                  StaffID := '';
                  Fund := SchemeCode;

                if ActiveLoans.Get("Loan Application".No) then begin
                  if (ActiveLoans.Status = ActiveLoans.Status::New) or (ActiveLoans.Status = ActiveLoans.Status::"Pending Approval") or (ActiveLoans.Status = ActiveLoans.Status::Rejected) then
                    CurrReport.Skip;

                if (ActiveLoans."Fund Code" <> Fund) and (Fund <> '') then
                  CurrReport.Skip;

                  StaffID := ActiveLoans."Staff ID";
                  Fund := ActiveLoans."Fund Code";
                  if ActiveLoans."Application Date" > StartDate then
                    CalculationStartDate := ActiveLoans."Application Date";

                  //Termination Date
                  Schedule.Reset;
                  Schedule.SetRange("Loan No.","Loan Application".No);
                  Schedule.SetFilter("Principal Due",'<>%1',0);
                  if Schedule.FindLast then begin
                    TerminationDate := Schedule."Repayment Date";
                    PrincipalTerminated := Schedule."Principal Due";
                  end;

                end else if HistoricalLoans.Get("Loan Application".No) then begin
                  if (HistoricalLoans."Fund Code" <> Fund) and (Fund <> '') then
                  CurrReport.Skip;

                  StaffID := HistoricalLoans."Staff ID";
                  Fund := HistoricalLoans."Fund Code";
                  if HistoricalLoans."Application Date" > StartDate then
                    CalculationStartDate := HistoricalLoans."Application Date";

                  //Termination Date
                  ScheduleHist.Reset;
                  ScheduleHist.SetRange("Loan No.","Loan Application".No);
                  ScheduleHist.SetRange(Settled,true);
                  if ScheduleHist.FindLast then begin

                    ScheduleHist2.Reset;
                    ScheduleHist2.CopyFilters(ScheduleHist);
                    ScheduleHist2.SetRange("Repayment Date",ScheduleHist."Repayment Date");
                    if ScheduleHist2.FindSet then begin repeat
                      if ScheduleHist2."Settlement Date" <> 0D then
                      TerminationDate := ScheduleHist2."Settlement Date";
                      if ScheduleHist2."Principal Settlement"  <> 0 then
                        PrincipalTerminated := ScheduleHist2."Principal Settlement"
                      else
                      PrincipalTerminated := PrincipalTerminated + ScheduleHist2."Principal Due";
                      until ScheduleHist2.Next = 0;
                    end;
                  end;

                end;
                if TerminationDate < StartDate then
                  CurrReport.Skip;


                  if TerminationDate < DateFilter then
                    CalculationEndDate := TerminationDate
                  else
                    CalculationEndDate := DateFilter;

                VestedTenure := CalculationEndDate-CalculationStartDate;
                //InterestIncomeInThePeriod := ROUND(RunningPrincipal*"Loan Application"."Interest Rate"/100*VestedTenure/365,0.01);

                counter := counter + 1;
            end;

            trigger OnPreDataItem()
            begin
                if DateFilter=0D then
                  Error('Reference Date Filter is a MUST');

                StartDate := DMY2Date(1,1,Date2DMY(DateFilter,3));
                counter := 0;

                "Loan Application".SetRange("Application Date",0D,DateFilter);
                "Loan Application".SetFilter("Date Filter",'%1..%2',StartDate,DateFilter);

                DaysInTheYear := DMY2Date(31,12,Date2DMY(DateFilter,3))-DMY2Date(1,1,Date2DMY(DateFilter,3));
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateFilter;DateFilter)
                {
                    Caption = 'As At Date';
                }
                field(SchemeCode;SchemeCode)
                {
                    Caption = 'Scheme';
                    TableRelation = Fund WHERE ("Fund Code"=FILTER('EMRSC'|'EMSPC'));
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
        Schedule2: Record "Loan Repayment Schedule";
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
        PrincipalPayment: Decimal;
        InterestPayment: Decimal;
        TotalPayment: Decimal;
        OutstandingTenure: Decimal;
        OutstandingPrincipal: Decimal;
        OutstandingInterest: Decimal;
        TotalAmountOutstanding: Decimal;
        TotalLoanValuation: Decimal;
        ActiveLoans: Record "Loan Application";
        HistoricalLoans: Record "Historical Loans";
        ScheduleHist: Record "Historical Repayment Schedules";
        ScheduleUnsettledHist: Record "Historical Repayment Schedules";
        Fund: Code[10];
        StaffID: Code[20];
        StartDate: Date;
        RunningPrincipal: Decimal;
        ScheduleHist2: Record "Historical Repayment Schedules";
        TerminationDate: Date;
        PrincipalTerminated: Decimal;
        CalculationStartDate: Date;
        CalculationEndDate: Date;
        VestedTenure: Integer;
        InterestIncomeInThePeriod: Decimal;
        PeriodName: Text;
        PeriodDays: Integer;
        DaysInTheYear: Integer;
        SchemeCode: Code[10];
}

