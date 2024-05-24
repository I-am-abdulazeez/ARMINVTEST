page 208 "Work Types"
{
    // version NAVW113.00

    ApplicationArea = Jobs;
    Caption = 'Work Types';
    PageType = List;
    SourceTable = "Work Type";
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
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a code to identify the work type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of this work type.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
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

