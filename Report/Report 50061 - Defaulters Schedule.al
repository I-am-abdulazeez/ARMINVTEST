report 50061 "Defaulters Schedule"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Defaulters Schedule.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE("Interest Repayment Frequency"=FILTER(<>None));
            column(ReportPeriod;ReportPeriod)
            {
            }
            column(StaffID;"Loan Application"."Staff ID")
            {
            }
            column(StaffName;"Loan Application"."Client Name")
            {
            }
            column(LoanAmount;"Loan Application"."Approved Amount")
            {
            }
            column(Tenor;PeriodInYears)
            {
            }
            column(Fund;"Loan Application"."Fund Code")
            {
            }
            column(RepaymentOption;"Loan Application"."Principal Repayment Method")
            {
            }
            column(StartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(InterestRate;"Loan Application"."Interest Rate")
            {
            }
            column(RepaymentsPerYear;RepaymentsPerYear)
            {
            }
            column(ExpectedRepayment;ExpectedRepayment)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Loan Application".CalcFields("Total Amount Outstanding");
                ExpectedRepayment := 0;
                if "Loan Application"."Total Amount Outstanding" = 0 then
                  CurrReport.Skip;

                ExpectedRepayment := "Loan Application"."Total Amount Outstanding";

                PeriodInYears := Round("Loan Application"."Loan Period (in Months)"/12,1);
                RepaymentsPerYear := 0;
                if "Loan Application"."Interest Repayment Frequency" = "Loan Application"."Interest Repayment Frequency"::Annually then
                  RepaymentsPerYear := 1
                else if "Loan Application"."Interest Repayment Frequency" = "Loan Application"."Interest Repayment Frequency"::Monthly then
                  RepaymentsPerYear := 12
                else if "Loan Application"."Interest Repayment Frequency" = "Loan Application"."Interest Repayment Frequency"::None then
                  RepaymentsPerYear := 0
                else if "Loan Application"."Interest Repayment Frequency" = "Loan Application"."Interest Repayment Frequency"::Quarterly then
                  RepaymentsPerYear := 4
                else if "Loan Application"."Interest Repayment Frequency" = "Loan Application"."Interest Repayment Frequency"::"Semi-Annually" then
                  RepaymentsPerYear := 2;
            end;

            trigger OnPreDataItem()
            begin
                ReportPeriod := StrSubstNo('Defaulters Schedule for %1',MonthName);
                "Loan Application".SetFilter("Date Filter",'%1..%2',StartDate,EndDate);

                ReportPeriod := UpperCase(ReportPeriod);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(RefDate;RefDate)
                {
                    Caption = 'Month';
                    ToolTip = 'Select any date in the month you want to report for';
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

    trigger OnPreReport()
    begin
        if RefDate = 0D then
          Error('Please specify the reference date for the month.');

        if RefDate > Today then
          Error('You cannot specify a date that is ahead.');

        StartDate := CalcDate ('CM-1M+1D', RefDate);
        EndDate := CalcDate('CM',RefDate);
        MonthName := Format(RefDate,0,'<Month Text> <Year4>');
    end;

    var
        PeriodInYears: Integer;
        RepaymentsPerYear: Decimal;
        StartDate: Date;
        EndDate: Date;
        ExpectedRepayment: Decimal;
        ReportPeriod: Text;
        RefDate: Date;
        MonthName: Text;
}

