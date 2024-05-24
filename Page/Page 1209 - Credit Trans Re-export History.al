page 1209 "Credit Trans Re-export History"
{
    // version NAVW110.0

    Caption = 'Credit Trans Re-export History';
    Editable = false;
    PageType = List;
    SourceTable = "Credit Trans Re-export History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Re-export Date";"Re-export Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the payment file was re-exported.';
                }
                field("Re-exported By";"Re-exported By")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user who re-exported the payment file.';
                }
            }
        }
    }

    actions
    {
    }
}
