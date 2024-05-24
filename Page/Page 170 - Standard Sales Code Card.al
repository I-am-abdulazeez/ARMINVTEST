page 170 "Standard Sales Code Card"
{
    // version NAVW110.0

    Caption = 'Standard Sales Lines Card';
    PageType = ListPlus;
    SourceTable = "Standard Sales Code";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code which identifies this standard sales code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the standard sales code.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amounts on the standard sales lines.';
                }
            }
            part(StdSalesLines;"Standard Sales Code Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Standard Sales Code"=FIELD(Code);
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
