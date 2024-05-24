report 50050 "Loan Variations"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Loan Variations.rdlc';

    dataset
    {
        dataitem("Historical Loan Variation";"Historical Loan Variation")
        {
            RequestFilterFields = "Type of Variation";
            column(ReportPeriod;ReportPeriod)
            {
            }
            column(StaffID;"Historical Loan Variation"."Staff ID")
            {
            }
            column(StaffName;"Historical Loan Variation"."Client Name")
            {
            }
            column(TypeOfVariation;"Historical Loan Variation"."Type of Variation")
            {
            }
            column(OldLoanNo;"Historical Loan Variation"."Old Loan No.")
            {
            }
            column(OldLoanOutstandingPrincipal;"Historical Loan Variation"."Current Outstanding Principal")
            {
            }
            column(OldLoanOutstandingInterest;"Historical Loan Variation"."Current Outstanding Interest")
            {
            }
            column(OldLoanOutstandingTenure;"Historical Loan Variation"."Current Outstanding Tenure")
            {
            }
            column(OldLoanInterestRate;"Historical Loan Variation"."Current Interest Rate")
            {
            }
            column(OldLoanType;"Historical Loan Variation"."Current Loan Type")
            {
            }
            column(NewLoanNo;"Historical Loan Variation"."New Loan No.")
            {
            }
            column(NewPrincipal;"Historical Loan Variation"."New Principal")
            {
            }
            column(NewInterest;"Historical Loan Variation"."New Interest")
            {
            }
            column(NewTenure;"Historical Loan Variation"."New Tenure(Months)")
            {
            }
            column(NewLoanType;"Historical Loan Variation"."New Loan Type")
            {
            }
            column(NewStartDate;"Historical Loan Variation"."New Loan Start Date")
            {
            }
            column(NewInterestRate;"Historical Loan Variation"."New Interest Rate")
            {
            }
            column(TopUpAmount;"Historical Loan Variation"."Top Up Amount")
            {
            }
            column(FundCode;"Historical Loan Variation"."Fund Code")
            {
            }

            trigger OnPreDataItem()
            begin
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                  ReportPeriod := StrSubstNo('Loan Variations For the Period beginning %1 to %2',Format(StartDate,0,4),Format(EndDate,0,4));
                  "Historical Loan Variation".SetRange(Date,StartDate,EndDate);
                end;
                if (StartDate = 0D) and (EndDate <> 0D) then begin
                ReportPeriod := StrSubstNo('Loan Variations from Inception to %1',Format(EndDate,0,4));
                "Historical Loan Variation".SetRange(Date,0D,EndDate);
                end;
                if (StartDate <> 0D) and (EndDate = 0D) then begin
                ReportPeriod := StrSubstNo('Loan Variations from %1 onwards',Format(StartDate,0,4));
                "Historical Loan Variation".SetRange(Date,StartDate,0D);
                end;
                if (StartDate = 0D) and (EndDate = 0D) then
                ReportPeriod := StrSubstNo('Total Loan Variations on All Loans',Format(StartDate,0,4));
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
        FM: Record "Fund Managers";
        i: Integer;
        FMcode: array [5] of Code[10];
        FMDesc: array [5] of Text;
        LoanBalances: array [5] of Decimal;
        FMRatios: Record "Product Fund Manager Ratio";
}

