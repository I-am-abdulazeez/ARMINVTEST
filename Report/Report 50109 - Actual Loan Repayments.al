report 50109 "Actual Loan Repayments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Actual Loan Repayments.rdlc';

    dataset
    {
        dataitem("Loan Repayment Lines";"Loan Repayment Lines")
        {
            DataItemTableView = WHERE(Posted=CONST(true));
            RequestFilterFields = Application,"Sheduled Repayment Date";
            column(PersNo;"Loan Repayment Lines"."Pers. No.")
            {
            }
            column(Name;"Loan Repayment Lines"."Last Name and First Name")
            {
            }
            column(LoanNoS;"Loan Repayment Lines"."Applies To Loan")
            {
            }
            column(Date;"Loan Repayment Lines"."Sheduled Repayment Date")
            {
            }
            column(Principal;"Loan Repayment Lines"."Principal Applied")
            {
            }
            column(Interest;"Loan Repayment Lines"."Interest Applied")
            {
            }
            column(Total;"Loan Repayment Lines"."Total Payment")
            {
            }
            column(Title;Title)
            {
            }
            column(Scheme;Scheme)
            {
            }
            column(ARMIM;ARMIM)
            {
            }
            column(Vetiva;Vetiva)
            {
            }
            column(IBTC;IBTC)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Scheme := '';
                if LoanActive.Get("Loan Repayment Lines"."Loan No.") then
                  Scheme := LoanActive."Fund Code"
                else if LoanHist.Get("Loan Repayment Lines"."Loan No.") then
                  Scheme := LoanHist."Fund Code"
                else
                  Scheme := '';

                ARMIM := 0;
                Vetiva := 0;
                IBTC := 0;

                FundManagerRatios.Reset;
                FundManagerRatios.SetFilter(From,'<%1',EndDate);
                FundManagerRatios.SetFilter("To",'>%1',EndDate);
                if FundManagerRatios.FindSet then begin repeat
                  if FundManagerRatios."Fund Manager" = 'ARM' then
                    ARMIM := Round(FundManagerRatios.Percentage * "Loan Repayment Lines"."Total Payment"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'IBTC' then
                    IBTC := Round(FundManagerRatios.Percentage * "Loan Repayment Lines"."Total Payment"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'VETIVA' then
                    Vetiva := Round(FundManagerRatios.Percentage * "Loan Repayment Lines"."Total Payment"/100,0.01);
                until FundManagerRatios.Next = 0
                end;
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
        StartDateText := Format("Loan Repayment Lines".GetRangeMin("Sheduled Repayment Date"),0,4);
        EndDateText := Format("Loan Repayment Lines".GetRangeMax("Sheduled Repayment Date"),0,4);
        if "Loan Repayment Lines".GetFilter(Application) = '' then
          Error('Please select application.');

        if "Loan Repayment Lines".GetFilter(Application) = 'Apply to Interest First' then
        Title := StrSubstNo(Text000,'Scheduled ',StartDateText,EndDateText)
        else
        Title := StrSubstNo(Text000,'Out of Pocket ',StartDateText,EndDateText);

        EndDate := "Loan Repayment Lines".GetRangeMax("Sheduled Repayment Date");
    end;

    var
        Text000: Label '%1 Loan Repayments between %2 and %3';
        Title: Text;
        StartDateText: Text;
        EndDateText: Text;
        LoanActive: Record "Loan Application";
        LoanHist: Record "Historical Loans";
        Scheme: Code[10];
        FundManagerRatios: Record "Product Fund Manager Ratio";
        Vetiva: Decimal;
        IBTC: Decimal;
        ARMIM: Decimal;
        EndDate: Date;
}

