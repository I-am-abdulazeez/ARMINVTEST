page 28 "Vend. Invoice Discounts"
{
    // version NAVW113.00

    Caption = 'Vend. Invoice Discounts';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Vendor Invoice Disc.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contents of the Invoice Disc. Code field on the vendor card.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for invoice discount terms.';
                }
                field("Minimum Amount";"Minimum Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the minimum amount that your order must total for the discount to be granted or the service charge levied.';
                }
                field("Discount %";"Discount %")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the discount percentage that the vendor will grant if your company buys at least the amount in the Minimum Amount field.';
                }
                field("Service Charge";"Service Charge")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount of the service charge that the vendor will charge if your company purchases for at least the amount in the Minimum Amount field.';
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

