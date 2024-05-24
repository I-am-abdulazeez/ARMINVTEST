page 5218 "Misc. Articles"
{
    // version NAVW113.02

    ApplicationArea = BasicHR;
    Caption = 'Employee Miscellaneous Articles';
    PageType = List;
    SourceTable = "Misc. Article";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a code for the miscellaneous article.';
                }
                field(Description;Description)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a description for the miscellaneous articles.';
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
}

