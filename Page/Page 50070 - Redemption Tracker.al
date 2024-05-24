page 50070 "Redemption Tracker"
{
    PageType = List;
    SourceTable = "Redemption Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Redemption;Redemption)
                {
                }
                field(Status;Status)
                {
                }
                field("Date Time";"Date Time")
                {
                }
                field("Changed By";"Changed By")
                {
                }
                field(Comments;Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

