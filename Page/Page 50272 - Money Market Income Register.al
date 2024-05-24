page 50272 "Money Market Income Register"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Daily Distributable Income";
    SourceTableView = WHERE("Quarter Closed"=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field(Date;Date)
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Daily Distributable Income";"Daily Distributable Income")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                    Editable = false;
                }
                field("Total Fund Units";"Total Fund Units")
                {
                    Editable = false;
                }
                field(Distributed;Distributed)
                {
                }
                field("Reversed Dividend";"Reversed Dividend")
                {
                }
                field("Total Distributable Income";"Total Distributable Income")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Distribute Income")
            {
                Image = DistributionGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundTransMgt: Codeunit "Fund Transaction Management";
                begin
                    TestField(Distributed,false);
                    FundProcessing.GenerateIncomeLines(Rec);
                    Distributed := true;
                    Modify;
                    FundTransMgt.SendNomineeDividend(Rec.Date);
                    Message('Income distributed successfully.')
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
}

