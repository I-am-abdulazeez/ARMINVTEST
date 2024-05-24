page 50091 Quarters
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Quarters;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Description;Description)
                {
                }
                field("Start Date";"Start Date")
                {
                }
                field("End Date";"End Date")
                {
                }
                field(Closed;Closed)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Run EOQ")
            {
                Image = Replan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ProcessEOQBatch(Rec);
                end;
            }
            action("View EOQ")
            {
                Image = ViewWorksheet;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ViewEOQ(Rec);
                end;
            }
            action("Close Quarter")
            {
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.CloseQuarter(Rec);
                end;
            }
            action("Create New Quarter")
            {
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    FundProcessing.CreateNewQuarter(Today);
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
}

