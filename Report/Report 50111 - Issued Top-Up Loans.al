report 50111 "Issued Top-Up Loans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Issued Top-Up Loans.rdlc';

    dataset
    {
        dataitem("Historical Loan Variation";"Historical Loan Variation")
        {
            DataItemTableView = WHERE("Type of Variation"=CONST("Top Up"));
            RequestFilterFields = Date;
            column(StaffID;"Historical Loan Variation"."Staff ID")
            {
            }
            column(Name;"Historical Loan Variation"."Client Name")
            {
            }
            column(Date;"Historical Loan Variation".Date)
            {
            }
            column(LoanNo;"Historical Loan Variation"."Old Loan No.")
            {
            }
            column(NewLoanNo;"Historical Loan Variation"."New Loan No.")
            {
            }
            column(Principal;"Historical Loan Variation"."Total Outstanding Loan")
            {
            }
            column(Interest;"Historical Loan Variation"."Top Up Amount")
            {
            }
            column(Total;"Historical Loan Variation"."New Principal")
            {
            }
            column(Scheme;"Historical Loan Variation"."Fund Code")
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
                ARMIM := 0;
                Vetiva := 0;
                IBTC := 0;

                FundManagerRatios.Reset;
                FundManagerRatios.SetFilter(From,'<%1',"Historical Loan Variation".Date);
                FundManagerRatios.SetFilter("To",'>%1',"Historical Loan Variation".Date);
                if FundManagerRatios.FindSet then begin repeat
                  if FundManagerRatios."Fund Manager" = 'ARM' then
                    ARMIM := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."New Principal"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'IBTC' then
                    IBTC := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."New Principal"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'VETIVA' then
                    Vetiva := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."New Principal"/100,0.01);
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

    var
        FundManagerRatios: Record "Product Fund Manager Ratio";
        Vetiva: Decimal;
        IBTC: Decimal;
        ARMIM: Decimal;
}

