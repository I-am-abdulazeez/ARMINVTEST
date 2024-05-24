page 50092 "Income Register"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Income Register";
    SourceTableView = WHERE("Quarter Closed"=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Value Date";"Value Date")
                {
                }
                field("Fund ID";"Fund ID")
                {
                }
                field("Fund Name";"Fund Name")
                {
                }
                field("Total Income";"Total Income")
                {
                }
                field("Total Expenses";"Total Expenses")
                {
                }
                field("Distributed Income";"Distributed Income")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                }
                field(Distributed;Distributed)
                {
                    Editable = false;
                }
                field(Processed;Processed)
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
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*TESTFIELD(Distributed,FALSE);
                    FundProcessing.DistributeIncome(Rec);
                    Distributed:=TRUE;
                    MODIFY;
                    FundTransMgt.SendNomineeDividend(Rec."Value Date");
                    MESSAGE('Income distribution completed successfully');*/
                    
                    Error('This is no longer in use');

                end;
            }
            action("View Distributed Income")
            {
                Image = ViewWorksheet;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ViewDistributedIncome(Rec);
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
        FundTransMgt: Codeunit "Fund Transaction Management";
}

