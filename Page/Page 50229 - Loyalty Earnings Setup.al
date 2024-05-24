page 50229 "Loyalty Earnings Setup"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Loyalty Earnings Setup";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Initial Date";"Initial Date")
                {
                    Caption = 'Start Date';
                }
                field("Final Date";"Final Date")
                {
                    Caption = 'End Date';
                }
                field(NoOfDays;NoOfDays)
                {
                    Caption = 'No of Days';
                }
                field("Bonus Rate";"Bonus Rate")
                {
                }
                field("Minimum Subscription";"Minimum Subscription")
                {
                }
            }
        }
    }

    actions
    {
    }
}

