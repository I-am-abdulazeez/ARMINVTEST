page 50108 "Closed Income Register"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Income Register";
    SourceTableView = WHERE("Quarter Closed"=CONST(true));

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
            }
        }
    }

    actions
    {
        area(processing)
        {
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
}

