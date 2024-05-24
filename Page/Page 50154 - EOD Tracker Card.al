page 50154 "EOD Tracker Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "EOD Tracker";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fund Code";"Fund Code")
                {
                }
                field(Date;Date)
                {
                }
                field("Push Start Time";"Push Start Time")
                {
                }
                field("Push End Time";"Push End Time")
                {
                }
                field("EOD Generated";"EOD Generated")
                {
                }
                field("EOD Pushed";"EOD Pushed")
                {
                }
            }
            part(Control8;"EOD Tracker Line")
            {
                SubPageLink = PostDate=FIELD(Date),
                              PlanCode=FIELD("Fund Code");
            }
            part(Control12;"Dividend Settled")
            {
                SubPageLink = "Record Date"=FIELD(Date),
                              PlanCode=FIELD("Fund Code");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Export Redeem& Subscrip To CSV")
            {
                Image = EXCEL;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ExportRedeemSubscriptions);
                    SubscriptionRedempFundware.Reset;
                    SubscriptionRedempFundware.SetRange(PostDate,Date);
                    SubscriptionRedempFundware.SetRange(PlanCode,"Fund Code");
                    ExportRedeemSubscriptions.SetTableView(SubscriptionRedempFundware);
                    ExportRedeemSubscriptions.Run;
                end;
            }
            action("Export Dividend Settled to CSV")
            {
                Image = excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ExportDividendSettled);
                    DividendIncomeSettled.Reset;
                    DividendIncomeSettled.SetRange("Settled Date",Date);
                    DividendIncomeSettled.SetRange(PlanCode,"Fund Code");
                    ExportDividendSettled.SetTableView(DividendIncomeSettled);
                    ExportDividendSettled.Run;
                end;
            }
        }
    }

    var
        SubscriptionRedempFundware: Record "Subscription & Redemp Fundware";
        ExportRedeemSubscriptions: Report "Export Redemptions & subscrip";
        ExportDividendSettled: Report "Export Dividend Settlement";
        DividendIncomeSettled: Record "Dividend Income Settled";
}

