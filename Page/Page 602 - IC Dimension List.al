page 602 "IC Dimension List"
{
    // version NAVW113.00

    Caption = 'Intercompany Dimension List';
    Editable = false;
    PageType = List;
    SourceTable = "IC Dimension";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the intercompany dimension code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the intercompany dimension name.';
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

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}
