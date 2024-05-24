page 50133 "Un Reconciled Subsc Matchings"
{
    CardPageID = "UnReconciled Subscription Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Subscription Matching header";
    SourceTableView = WHERE("Reconciliation Status"=CONST("Not Reconciled"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field(Narration;Narration)
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Fund Code";"Fund Code")
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
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
                field("Total No of Lines";"Total No of Lines")
                {
                }
                field("Total Sum of Inflows";"Total Sum of Inflows")
                {
                }
                field("No of Non Client Lines";"No of Non Client Lines")
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

