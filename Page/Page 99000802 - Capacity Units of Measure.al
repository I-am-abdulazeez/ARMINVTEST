page 99000802 "Capacity Units of Measure"
{
    // version NAVW113.00

    ApplicationArea = Manufacturing;
    Caption = 'Capacity Units of Measure';
    PageType = List;
    SourceTable = "Capacity Unit of Measure";
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
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the unit code.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the type of unit of measure.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the description of the unit of measure.';
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

