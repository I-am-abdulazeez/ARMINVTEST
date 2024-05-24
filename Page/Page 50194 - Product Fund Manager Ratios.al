page 50194 "Product Fund Manager Ratios"
{
    // version THL-LOAN-1.0.0

    PageType = List;
    SourceTable = "Product Fund Manager Ratio";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund Manager";"Fund Manager")
                {
                }
                field(From;From)
                {
                }
                field("To";"To")
                {
                }
                field("Fund Manager Name";"Fund Manager Name")
                {
                    Editable = false;
                }
                field(Percentage;Percentage)
                {
                }
            }
        }
    }

    actions
    {
    }
}

