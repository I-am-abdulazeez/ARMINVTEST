page 50160 "Commission Header"
{
    PageType = Card;
    SourceTable = "Commission Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field("Start Date";"Start Date")
                {
                }
                field("End Date";"End Date")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
            }
            part(Control8;"Commission Summary")
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
            part(Control9;"Fum & Fees")
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
            part(Control10;Inflows)
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
            part(Control11;Commissions)
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
            part(Control12;"New Clients")
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Commission")
            {
                Image = CalculateSalesTax;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CommissionCalculation.CalculateCommission(Rec);
                end;
            }
        }
    }

    var
        CommissionCalculation: Codeunit "Commission Calculation";
}

