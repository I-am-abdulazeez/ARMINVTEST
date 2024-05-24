page 910 "Assembly Item - Details"
{
    // version NAVW113.00

    Caption = 'Assembly Item - Details';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Assembly;
                Caption = 'Item No.';
                ToolTip = 'Specifies the number of the item.';
            }
            field("Standard Cost";"Standard Cost")
            {
                ApplicationArea = Assembly;
                ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
            }
            field("Unit Price";"Unit Price")
            {
                ApplicationArea = Assembly;
                ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
            }
        }
    }

    actions
    {
    }
}

