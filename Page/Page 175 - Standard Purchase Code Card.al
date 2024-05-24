page 175 "Standard Purchase Code Card"
{
    // version NAVW110.0

    Caption = 'Standard Purchase Code Card';
    PageType = ListPlus;
    SourceTable = "Standard Purchase Code";

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
                    ToolTip = 'Specifies a code which identifies this standard purchase code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the standard purchase code.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amounts on the standard purchase lines.';
                }
            }
            part(StdPurchaseLines;"Standard Purchase Code Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Standard Purchase Code"=FIELD(Code);
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
