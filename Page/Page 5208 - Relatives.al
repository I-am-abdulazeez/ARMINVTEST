page 5208 Relatives
{
    // version NAVW113.02

    ApplicationArea = BasicHR;
    Caption = 'Relatives';
    PageType = List;
    SourceTable = Relative;
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
                    ToolTip = 'Specifies a code for the employee''s relative or other close contact.';
                }
                field(Description;Description)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a description for the employee''s relative or other close contact.';
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

