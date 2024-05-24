page 7120 "Sales Analysis Lines"
{
    // version NAVW113.00

    AutoSplitKey = true;
    Caption = 'Sales Analysis Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Worksheet;
    SourceTable = "Analysis Line";

    layout
    {
        area(content)
        {
            field(CurrentAnalysisLineTempl;CurrentAnalysisLineTempl)
            {
                ApplicationArea = SalesAnalysis;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the record.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    AnalysisReportMgt.LookupAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    AnalysisReportMgt.CheckAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
                    CurrentAnalysisLineTemplOnAfte;
                end;
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowCaption = false;
                field("Row Ref. No.";"Row Ref. No.")
                {
                    ApplicationArea = SalesAnalysis;
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies a row reference number for the analysis line.';

                    trigger OnValidate()
                    begin
                        RowRefNoOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = SalesAnalysis;
                    StyleExpr = 'Strong';
                    ToolTip = 'Specifies a description for the analysis line.';
                }
                field(Type;Type)
                {
                    ApplicationArea = SalesAnalysis;
                    OptionCaption = 'Item,Item Group,Customer,Customer Group,,Sales/Purchase person,Formula';
                    ToolTip = 'Specifies the type of totaling for the analysis line. The type determines which items within the totaling range that you specify in the Range field will be totaled.';
                }
                field(Range;Range)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies the number or formula of the type to use to calculate the total for this line.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookupTotalingRange(Text));
                    end;
                }
                field("Dimension 1 Totaling";"Dimension 1 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 1 Code"));
                    end;
                }
                field("Dimension 2 Totaling";"Dimension 2 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line. If the type on the line is Formula, this field must be blank. Also, if you do not want the amounts on the line to be filtered by dimensions, this field must be blank.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 2 Code"));
                    end;
                }
                field("Dimension 3 Totaling";"Dimension 3 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line. If the type on the line is Formula, this field must be blank. Also, if you do not want the amounts on the line to be filtered by dimensions, this field must be blank.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 3 Code"));
                    end;
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies if you want a page break after the current line when you print the analysis report.';
                }
                field(Show;Show)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies whether you want the analysis line to be included when you print the report.';
                }
                field(Bold;Bold)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies if you want the amounts on this line to be printed in bold.';
                }
                field(Indentation;Indentation)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies the indentation of the line.';
                    Visible = false;
                }
                field(Italic;Italic)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies if you want the amounts in this line to be printed in italics.';
                }
                field(Underline;Underline)
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies if you want the amounts in this line to be underlined when printed.';
                }
                field("Show Opposite Sign";"Show Opposite Sign")
                {
                    ApplicationArea = SalesAnalysis;
                    ToolTip = 'Specifies if you want sales and negative adjustments to be shown as positive amounts and purchases and positive adjustments to be shown as negative amounts.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Insert &Item")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Insert &Item';
                    Image = Item;
                    ToolTip = 'Insert one or more items that you want to include in the sales analysis report.';

                    trigger OnAction()
                    begin
                        InsertLine(0);
                    end;
                }
                action("Insert &Customers")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Insert &Customers';
                    Ellipsis = true;
                    Image = Customer;
                    ToolTip = 'Insert one or more customers that you want to include in the sales analysis report.';

                    trigger OnAction()
                    begin
                        InsertLine(1);
                    end;
                }
                separator(Separator36)
                {
                }
                action("Insert Ite&m Groups")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Insert Ite&m Groups';
                    Image = ItemGroup;
                    ToolTip = 'Insert one or more item groups that you want to include in the sales analysis report.';

                    trigger OnAction()
                    begin
                        InsertLine(3);
                    end;
                }
                action("Insert Customer &Groups")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Insert Customer &Groups';
                    Ellipsis = true;
                    Image = CustomerGroup;
                    ToolTip = 'Insert one or more customer groups that you want to include in the sales analysis report.';

                    trigger OnAction()
                    begin
                        InsertLine(4);
                    end;
                }
                action("Insert &Sales/Purchase Persons")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Insert &Sales/Purchase Persons';
                    Ellipsis = true;
                    Image = SalesPurchaseTeam;
                    ToolTip = 'Insert one or more sales people of purchasers that you want to include in the sales analysis report.';

                    trigger OnAction()
                    begin
                        InsertLine(5);
                    end;
                }
                separator(Separator48)
                {
                }
                action("Renumber Lines")
                {
                    ApplicationArea = SalesAnalysis;
                    Caption = 'Renumber Lines';
                    Image = Refresh;
                    ToolTip = 'Renumber lines in the analysis report sequentially from a number that you specify.';

                    trigger OnAction()
                    var
                        AnalysisLine: Record "Analysis Line";
                        RenAnalysisLines: Report "Renumber Analysis Lines";
                    begin
                        CurrPage.SetSelectionFilter(AnalysisLine);
                        RenAnalysisLines.Init(AnalysisLine);
                        RenAnalysisLines.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        DescriptionOnFormat;
    end;

    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
        AnalysisLineTemplate: Record "Analysis Line Template";
    begin
        AnalysisReportMgt.OpenAnalysisLines(CurrentAnalysisLineTempl,Rec);

        GLSetup.Get;

        if AnalysisLineTemplate.Get(GetRangeMax("Analysis Area"),CurrentAnalysisLineTempl) then
          if AnalysisLineTemplate."Item Analysis View Code" <> '' then
            ItemAnalysisView.Get(GetRangeMax("Analysis Area"),AnalysisLineTemplate."Item Analysis View Code")
          else begin
            Clear(ItemAnalysisView);
            ItemAnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            ItemAnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
          end;
    end;

    var
        ItemAnalysisView: Record "Item Analysis View";
        AnalysisReportMgt: Codeunit "Analysis Report Management";
        CurrentAnalysisLineTempl: Code[10];
        [InDataSet]
        DescriptionIndent: Integer;

    local procedure InsertLine(Type: Option Item,Customer,Vendor,ItemGroup,CustGroup,SalespersonGroup)
    var
        AnalysisLine: Record "Analysis Line";
        InsertAnalysisLine: Codeunit "Insert Analysis Line";
    begin
        CurrPage.Update(true);
        AnalysisLine.Copy(Rec);
        if "Line No." = 0 then begin
          AnalysisLine := xRec;
          if AnalysisLine.Next = 0 then
            AnalysisLine."Line No." := xRec."Line No." + 10000;
        end;
        case Type of
          Type::Item:
            InsertAnalysisLine.InsertItems(AnalysisLine);
          Type::Customer:
            InsertAnalysisLine.InsertCust(AnalysisLine);
          Type::Vendor:
            InsertAnalysisLine.InsertVend(AnalysisLine);
          Type::ItemGroup:
            InsertAnalysisLine.InsertItemGrDim(AnalysisLine);
          Type::CustGroup:
            InsertAnalysisLine.InsertCustGrDim(AnalysisLine);
          Type::SalespersonGroup:
            InsertAnalysisLine.InsertSalespersonPurchaser(AnalysisLine);
        end;
    end;

    [Scope('Personalization')]
    procedure SetCurrentAnalysisLineTempl(AnalysisLineTemlName: Code[10])
    begin
        CurrentAnalysisLineTempl := AnalysisLineTemlName;
    end;

    local procedure RowRefNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CurrentAnalysisLineTemplOnAfte()
    var
        ItemSchedName: Record "Analysis Line Template";
    begin
        CurrPage.SaveRecord;
        AnalysisReportMgt.SetAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
        if ItemSchedName.Get(GetRangeMax("Analysis Area"),CurrentAnalysisLineTempl) then
          CurrPage.Update(false);
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Indentation;
    end;
}

