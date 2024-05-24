page 1240 "SWIFT Codes"
{
    // version NAVW113.04

    ApplicationArea = Basic,Suite;
    Caption = 'SWIFT Codes';
    PageType = List;
    SourceTable = "SWIFT Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the SWIFT code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank for the corresponding SWIFT code.';
                }
            }
        }
    }

    actions
    {
    }
}

