page 50248 "MF Income Distrib Card"
{
    // version MFD-1.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "MF Distributable Income";

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
                field("Sub Units";"Sub Units")
                {
                }
                field("Redemption Units";"Redemption Units")
                {
                }
                field("EOD Nav";"EOD Nav")
                {
                }
                field("Total Fund Units";"Total Fund Units")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                }
                field("Total Line Units";"Total Line Units")
                {
                }
                field("Total Line Amount";"Total Line Amount")
                {
                }
            }
            part(Control12;"MF Income distrib Lines")
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
                    Clear(ExportDividend);
                    MFIncomeDistribLines.Reset;
                    MFIncomeDistribLines.SetRange(No,No);
                    ExportDividend.SetTableView(MFIncomeDistribLines);
                    ExportDividend.Run;
                end;
            }
        }
    }

    var
        ExportDividend: XMLport "Export MF Dividend";
        MFIncomeDistribLines: Record "MF Income Distrib Lines";
}

