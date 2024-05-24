page 5617 "FA Locations"
{
    // version NAVW113.00

    ApplicationArea = FixedAssets;
    Caption = 'FA Locations';
    PageType = List;
    SourceTable = "FA Location";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies a location code for the fixed asset.';
                }
                field(Name;Name)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the fixed asset location.';
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
