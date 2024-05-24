page 50034 "Caution Comments"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "Caution Comments";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Comments;Comments)
                {
                }
                field("User ID";"User ID")
                {
                }
                field("Date Raised";"Date Raised")
                {
                }
            }
        }
    }

    actions
    {
    }
}

