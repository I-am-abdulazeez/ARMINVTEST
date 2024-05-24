page 50186 "Fund Groups"
{
    PageType = List;
    SourceTable = "Fund Groups";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("code";code)
                {
                }
                field(Description;Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

