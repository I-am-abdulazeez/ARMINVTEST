page 50273 "Money Markt Income Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Daily Distributable Income";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Total Fund Units";"Total Fund Units")
                {
                    Editable = false;
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                    Editable = false;
                }
                field("Total Line Amount";"Total Line Amount")
                {
                    Editable = false;
                }
            }
            part(Control12;"Daily Income distrib Lines")
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
            action("Export Dividend Lines")
            {
                Image = ExportElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ExportDailyDividend);
                    DailyIncomeDistribLines.Reset;
                    DailyIncomeDistribLines.SetRange(No,No);
                    ExportDailyDividend.SetTableView(DailyIncomeDistribLines);
                    ExportDailyDividend.Run;
                end;
            }
            action("Distribute Income")
            {
                Image = DistributionGroup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestField(Distributed,false);
                    FundProcessing.CreateNewQuarter(Rec);
                    Distributed := true;
                    Modify;
                    Message('Income distributed successfully.')
                    /*IF IncomeRegister.GET(Rec.Date,Rec."Fund Code") THEN BEGIN
                      IncomeRegister.Distributed := TRUE;
                      IncomeRegister.MODIFY;
                      MESSAGE('Income distributed successfully.')
                    END;*/

                end;
            }
        }
    }

    var
        ExportDailyDividend: XMLport "Export Daily Dividend";
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        FundProcessing: Codeunit "Fund Processing";
        IncomeRegister: Record "Income Register";
}

