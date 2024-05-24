page 50107 "EOQ Tracker"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "EOQ Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EOQ;EOQ)
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

