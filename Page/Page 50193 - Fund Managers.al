page 50193 "Fund Managers"
{
    // version THL-LOAN-1.0.0

    PageType = List;
    SourceTable = "Fund Managers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Name;Name)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control6;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

