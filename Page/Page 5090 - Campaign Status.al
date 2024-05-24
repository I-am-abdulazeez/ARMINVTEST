page 5090 "Campaign Status"
{
    // version NAVW113.00

    ApplicationArea = Basic,Suite,RelationshipMgmt;
    Caption = 'Campaign Status';
    PageType = List;
    SourceTable = "Campaign Status";
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
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code for the campaign status.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the description of the campaign status.';
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
