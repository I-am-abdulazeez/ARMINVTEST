page 1122 "Chart of Cost Centers"
{
    // version NAVW113.01

    ApplicationArea = CostAccounting;
    Caption = 'Chart of Cost Centers';
    CardPageID = "Cost Center Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Cost Center";
    SourceTableView = SORTING("Sorting Order");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control16)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = CostAccounting;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the code for the cost center.';
                }
                field(Name;Name)
                {
                    ApplicationArea = CostAccounting;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the name of the cost center.';
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
                field("Sorting Order";"Sorting Order")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the sorting order of the cost centers.';
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = CostAccounting;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = CostAccounting;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the cost type balance on the last date that is included in the Date Filter field. The contents of the field are calculated by using the entries in the Amount field in the Cost Entry table.';
                    Visible = false;
                }
                field("Balance to Allocate";"Balance to Allocate")
                {
                    ApplicationArea = CostAccounting;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the balance that has not yet been allocated. The entry in the Allocated field determines if the entry is included in the Balance to Allocate field. The value in the Allocated field is set automatically during the cost allocation.';
                }
                field("Cost Subtype";"Cost Subtype")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the subtype of the cost center. This is an information field and is not used for any other purposes. Choose the field to select the cost subtype.';
                }
                field("Responsible Person";"Responsible Person")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies the person who is responsible for the chart of cost centers.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.';
                    Visible = false;
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = CostAccounting;
                    ToolTip = 'Specifies a comment that applies.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cost Center")
            {
                Caption = '&Cost Center';
                Image = CostCenter;
                action("Cost E&ntries")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Center Code"=FIELD(Code);
                    RunPageView = SORTING("Cost Center Code","Cost Type No.",Allocated,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.';
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
                    ToolTip = 'View a summary of the balance at date or the net change for different time periods for the cost center that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.';

                    trigger OnAction()
                    begin
                        if Totaling = '' then
                          CostType.SetFilter("Cost Center Filter",Code)
                        else
                          CostType.SetFilter("Cost Center Filter",Totaling);

                        PAGE.Run(PAGE::"Cost Type Balance",CostType);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("I&ndent Cost Centers")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'I&ndent Cost Centers';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Indent the selected lines.';

                    trigger OnAction()
                    begin
                        CostAccMgt.IndentCostCentersYN;
                    end;
                }
                action("Get Cost Centers From Dimension")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Get Cost Centers From Dimension';
                    Image = ChangeTo;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Transfer dimension values to the chart of cost centers.';

                    trigger OnAction()
                    begin
                        CostAccMgt.CreateCostCenters;
                    end;
                }
            }
            action(PageDimensionValues)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimension Values';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View or edit the dimension values for the current dimension.';

                trigger OnAction()
                begin
                    CostAccMgt.OpenDimValueListFiltered(CostAccSetup.FieldNo("Cost Center Dimension"));
                end;
            }
        }
        area(reporting)
        {
            action("Cost Center with Budget")
            {
                ApplicationArea = CostAccounting;
                Caption = 'Cost Center with Budget';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Balance/Budget";
                ToolTip = 'View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        CodeOnFormat;
        NameOnFormat;
        NetChangeOnFormat;
        BalanceatDateC15OnFormat;
        BalancetoAllocateOnFormat;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SetSelectionFilter(Rec);
        ConfirmDeleteIfEntriesExist(Rec,false);
        Reset;
    end;

    var
        CostType: Record "Cost Type";
        CostAccSetup: Record "Cost Accounting Setup";
        CostAccMgt: Codeunit "Cost Account Mgt";
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure CodeOnFormat()
    begin
        Emphasize := "Line Type" <> "Line Type"::"Cost Center";
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Indentation;
        Emphasize := "Line Type" <> "Line Type"::"Cost Center";
    end;

    local procedure NetChangeOnFormat()
    begin
        Emphasize := "Line Type" <> "Line Type"::"Cost Center";
    end;

    local procedure BalanceatDateC15OnFormat()
    begin
        Emphasize := "Line Type" <> "Line Type"::"Cost Center";
    end;

    local procedure BalancetoAllocateOnFormat()
    begin
        Emphasize := "Line Type" <> "Line Type"::"Cost Center";
    end;

    [Scope('Personalization')]
    procedure GetSelectionFilter(): Text
    var
        CostCenter: Record "Cost Center";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CostCenter);
        exit(SelectionFilterManagement.GetSelectionFilterForCostCenter(CostCenter));
    end;
}

