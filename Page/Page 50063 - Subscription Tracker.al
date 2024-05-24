page 50063 "Subscription Tracker"
{
    Editable = false;
    PageType = List;
    SourceTable = "Subscription Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Subscription;Subscription)
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
            }
        }
    }

    actions
    {
    }
}

