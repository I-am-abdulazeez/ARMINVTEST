report 50110 "Liquidated Loans from Top-Ups"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Liquidated Loans from Top-Ups.rdlc';

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
            column(Principal;"Historical Loan Variation"."Current Outstanding Principal")
            {
            }
            column(Interest;"Historical Loan Variation"."Current Outstanding Interest")
            {
            }
            column(Total;"Historical Loan Variation"."Total Outstanding Loan")
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
                    ARMIM := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."Total Outstanding Loan"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'IBTC' then
                    IBTC := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."Total Outstanding Loan"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'VETIVA' then
                    Vetiva := Round(FundManagerRatios.Percentage * "Historical Loan Variation"."Total Outstanding Loan"/100,0.01);
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

