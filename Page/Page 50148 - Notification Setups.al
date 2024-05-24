page 50148 "Notification Setups"
{
    PageType = List;
    SourceTable = "Notification Setups";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Send to";"Send to")
                {
                }
                field(CC;CC)
                {
                }
                field(BCC;BCC)
                {
                }
            }
        }
    }

    actions
    {
    }
}

