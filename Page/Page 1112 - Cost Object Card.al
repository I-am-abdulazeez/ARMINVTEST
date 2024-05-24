page 1112 "Cost Object Card"
{
    // version NAVW113.01

    Caption = 'Cost Object Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Cost Object";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the code for the cost object.';
                }
                field(Name;Name)
                {
                    ApplicationArea = CostAccounting;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the cost object card.';
                }
                field("Line Type";"Line Type")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the purpose of the cost object, such as Cost Object, Heading, or Begin-Total. Newly created cost objects are automatically assigned the Cost Object type, but you can change this.';
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies a comment that applies to the cost object.';
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = CostAccounting;
                    Importance = Promoted;
                    ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                }
                field("Sorting Order";"Sorting Order")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the sorting order of the cost object.';
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.';
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cost Object")
            {
                Caption = '&Cost Object';
                Image = Costs;
                action("E&ntries")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Object Code"=FIELD(Code);
                    RunPageView = SORTING("Cost Object Code","Cost Type No.",Allocated,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the entries for the cost object.';
                }
                separator(Separator4)
                {
                }
                action("&Balance")
                {
                    ApplicationArea = CostAccounting;
                    Caption = '&Balance';
                    Image = Balance;
                    ShortCutKey = 'F7';
                    ToolTip = 'View a summary of the balance at date or the net change for different time periods for the cost object that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.';

                    trigger OnAction()
                    var
                        CostType: Record "Cost Type";
                    begin
                        if Totaling = '' then
                          CostType.SetFilter("Cost Object Filter",Code)
                        else
                          CostType.SetFilter("Cost Object Filter",Totaling);

                        PAGE.Run(PAGE::"Cost Type Balance",CostType);
                    end;
                }
            }
        }
        area(processing)
        {
            action(PageDimensionValues)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimension Values';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View or edit the dimension values for the current dimension.';

                trigger OnAction()
                var
                    CostAccSetup: Record "Cost Accounting Setup";
                    CostAccMgt: Codeunit "Cost Account Mgt";
                begin
                    CostAccMgt.OpenDimValueListFiltered(CostAccSetup.FieldNo("Cost Object Dimension"));
                end;
            }
        }
    }
}

