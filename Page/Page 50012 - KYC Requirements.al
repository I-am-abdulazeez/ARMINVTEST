page 50012 "KYC Requirements"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "KYC Tier Requirements";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Requirement;Requirement)
                {
                }
                field(Provided;Provided)
                {
                }
            }
        }
    }

    actions
    {
    }
}

