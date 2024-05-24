page 5140 "Saved Segment Criteria Card"
{
    // version NAVW110.0

    Caption = 'Saved Segment Criteria Card';
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = "Saved Segment Criteria";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the saved segment criteria.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the saved segment criteria.';
                }
            }
            part(Control11;"Saved Segment Criteria Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Segment Criteria Code"=FIELD(Code);
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
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Close;
    end;
}

