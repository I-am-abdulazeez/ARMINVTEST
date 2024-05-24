page 5190 "Rating Answers"
{
    // version NAVW110.0

    AutoSplitKey = true;
    Caption = 'Rating Answers';
    PageType = List;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profile question or answer.';
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
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Answer;
    end;
}
