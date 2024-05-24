page 50080 "Unit Transfer Tracker"
{
    PageType = List;
    SourceTable = "Fund Transfer Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund Transfer No";"Fund Transfer No")
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

