report 50062 "Repayments Received Schedule"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Repayments Received Schedule.rdlc';

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
            column(PaymentMade;PaymentMade)
            {
            }
            column(Shortfall;Shortfall)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Loan Application".CalcFields("Total Amount Repaid","Total Amount Outstanding");
                ExpectedRepayment := 0;
                PaymentMade := 0;
                Shortfall := 0;

                if "Loan Application"."Total Amount Repaid" = 0 then
                  CurrReport.Skip;

                ExpectedRepayment := "Loan Application"."Total Amount Outstanding";
                PaymentMade := "Loan Application"."Total Amount Repaid";
                Shortfall := ExpectedRepayment - PaymentMade;

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
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                  ReportPeriod := StrSubstNo('Received repayments For the Period beginning %1 to %2',Format(StartDate,0,4),Format(EndDate,0,4));
                  "Loan Application".SetFilter("Date Filter",'%1..%2',StartDate,EndDate);
                end;
                if (StartDate = 0D) and (EndDate <> 0D) then begin
                ReportPeriod := StrSubstNo('Received repayments from Inception to %1',Format(EndDate,0,4));
                "Loan Application".SetFilter("Date Filter",'..%2',EndDate);
                end;
                if (StartDate <> 0D) and (EndDate = 0D) then begin
                ReportPeriod := StrSubstNo('Received repayments from %1 onwards',Format(StartDate,0,4));
                "Loan Application".SetFilter("Date Filter",'%1..',StartDate);
                end;
                if (StartDate = 0D) and (EndDate = 0D) then
                ReportPeriod := StrSubstNo('Total Received repayments for All Loans',Format(StartDate,0,4));
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
                field(StartDate;StartDate)
                {
                    Caption = 'From';
                }
                field(EndDate;EndDate)
                {
                    Caption = 'To';
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

    var
        PeriodInYears: Integer;
        RepaymentsPerYear: Decimal;
        StartDate: Date;
        EndDate: Date;
        ExpectedRepayment: Decimal;
        ReportPeriod: Text;
        PaymentMade: Decimal;
        Shortfall: Decimal;
}

