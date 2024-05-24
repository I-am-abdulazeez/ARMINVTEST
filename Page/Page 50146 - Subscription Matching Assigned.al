page 50146 "Subscription Matching Assigned"
{
    CardPageID = "Subs Matching Assigned Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Subscription Matching header";
    SourceTableView = WHERE(Posted=CONST(false));

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
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
                field("Lines Assigned";"Lines Assigned")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FilterGroup(10);
        SetFilter(UserFilter,UserId);
        SetFilter("Lines Assigned",'>%1',0);
        FilterGroup(0);
    end;
}

