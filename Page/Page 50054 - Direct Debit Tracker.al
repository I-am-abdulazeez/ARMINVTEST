page 50054 "Direct Debit Tracker"
{
    Editable = false;
    PageType = List;
    SourceTable = "Direct Debit Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Direct Debit Mandate";"Direct Debit Mandate")
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

