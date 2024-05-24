page 5651 "Insurance Journal"
{
    // version NAVW113.00

    ApplicationArea = FixedAssets;
    AutoSplitKey = true;
    Caption = 'Fixed Asset Insurance Journals';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Insurance Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    InsuranceJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    InsuranceJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date to use as the posting date on the insurance coverage ledger entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the appropriate document type for the amount you want to post.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the insurance number to post an insurance coverage entry to.';

                    trigger OnValidate()
                    begin
                        InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the related fixed asset. ';

                    trigger OnValidate()
                    begin
                        InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("FA Description";"FA Description")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the fixed asset.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description that is entered in the Insurance No. field.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the total amount the journal line consists of. Credit amounts must be entered with a minus sign.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(5),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(6),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(7),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(8),
                                                                  "Dimension Value Type"=CONST(Standard),
                                                                  Blocked=CONST(false));
                    ToolTip = 'Specifies the dimension value code linked to the journal line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Index Entry";"Index Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to post an indexation (that is, to index the total value insured).';
                    Visible = false;
                }
            }
            group(Control38)
            {
                ShowCaption = false;
                fixed(Control1902204901)
                {
                    ShowCaption = false;
                    group("Insurance Description")
                    {
                        Caption = 'Insurance Description';
                        field(InsuranceDescription;InsuranceDescription)
                        {
                            ApplicationArea = FixedAssets;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the insurance.';
                        }
                    }
                    group(Control1901313501)
                    {
                        Caption = 'FA Description';
                        field(FADescription;FADescription)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'FA Description';
                            Editable = false;
                            ToolTip = 'Specifies a description of the fixed asset that is entered in the FA No. field on the line.';
                        }
                    }
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("Ins&urance")
            {
                Caption = 'Ins&urance';
                Image = Insurance;
                action(Card)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Insurance Card";
                    RunPageLink = "No."=FIELD("Insurance No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action("Coverage Ledger E&ntries")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Coverage Ledger E&ntries';
                    Image = GeneralLedger;
                    RunObject = Page "Ins. Coverage Ledger Entries";
                    RunPageLink = "Insurance No."=FIELD("Insurance No.");
                    RunPageView = SORTING("Insurance No.","Disposed FA","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View insurance ledger entries that were created when you post to an insurance account from a purchase invoice, credit memo or journal line.';
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintInsuranceJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Insurance Jnl.-Post",Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Insurance Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        InsuranceJnlManagement: Codeunit InsuranceJnlManagement;
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
          exit;
        end;
        InsuranceJnlManagement.TemplateSelection(PAGE::"Insurance Journal",Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
    end;

    var
        InsuranceJnlManagement: Codeunit InsuranceJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        InsuranceDescription: Text[30];
        FADescription: Text[30];
        ShortcutDimCode: array [8] of Code[20];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        InsuranceJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

