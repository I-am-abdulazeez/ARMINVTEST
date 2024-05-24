report 50051 "Fund Managers Loans Report"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Fund Managers Loans Report.rdlc';

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
            column(FMDescOne;FMcode[1])
            {
            }
            column(FMDescTwo;FMcode[2])
            {
            }
            column(FMDescThree;FMcode[3])
            {
            }
            column(LoanBalancesOne;LoanBalances[1])
            {
            }
            column(LoanBalancesTwo;LoanBalances[2])
            {
            }
            column(LoanBalancesThree;LoanBalances[3])
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Loan Application".CalcFields("Total Amount Outstanding");
                if "Loan Application"."Total Amount Outstanding" < 1 then
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


                for i:=1 to 5 do
                begin
                Clear(LoanBalances[i]);
                end;

                for i:=1 to 3 do
                begin
                  FMRatios.Reset;
                  FMRatios.SetRange("Fund Manager",FMcode[i]);
                  FMRatios.SetRange(Product,"Loan Application"."Loan Product Type");
                  //FMRatios.SETRANGE("To",0D);
                  FMRatios.SetFilter(From,'<=%1',"Loan Application"."Application Date");
                  FMRatios.SetFilter("To",'>=%1',"Loan Application"."Application Date");
                  if FMRatios.FindLast then
                  LoanBalances[i] := Round("Total Amount Outstanding"*FMRatios.Percentage/100,0.01)
                  else
                  LoanBalances[i] := 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                  ReportPeriod := StrSubstNo('Fund Managers Loans For the Period beginning %1 to %2',Format(StartDate,0,4),Format(EndDate,0,4));
                  "Loan Application".SetFilter("Date Filter",'%1..%2',StartDate,EndDate);
                end;
                if (StartDate = 0D) and (EndDate <> 0D) then begin
                ReportPeriod := StrSubstNo('Fund Managers Loans from Inception to %1',Format(EndDate,0,4));
                "Loan Application".SetFilter("Date Filter",'..%2',EndDate);
                end;
                if (StartDate <> 0D) and (EndDate = 0D) then begin
                ReportPeriod := StrSubstNo('Fund Managers Loans from %1 onwards',Format(StartDate,0,4));
                "Loan Application".SetFilter("Date Filter",'%1..',StartDate);
                end;
                if (StartDate = 0D) and (EndDate = 0D) then
                ReportPeriod := StrSubstNo('Total Fund Managers Loans on All Loans',Format(StartDate,0,4));
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

    trigger OnPreReport()
    begin
         FM.Reset;
         if FM.Find('-') then
         repeat
         i:=i+1;
         FMcode[i]:=FM.Code;
         FMDesc[i]:=FM.Name;
         until FM.Next=0;
    end;

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

