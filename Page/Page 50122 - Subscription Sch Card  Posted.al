page 50122 "Subscription Sch Card  Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Subscription Schedules Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Schedule No";"Schedule No")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field(Narration;Narration)
                {
                }
                field("Main Account";"Main Account")
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Total Amount";"Total Amount")
                {
                }
                field("Line Total";"Line Total")
                {
                }
                field(Posted;Posted)
                {
                }
                field("Date Posted";"Date Posted")
                {
                }
                field("Time Posted";"Time Posted")
                {
                }
                field("Posted By";"Posted By")
                {
                }
            }
            part(Control11;"Subscription Schedule Lines")
            {
                Editable = false;
                SubPageLink = "Schedule Header"=FIELD("Schedule No");
            }
        }
    }

    actions
    {
    }
}

