page 50109 "Daily Distrib Income Posted"
{
    CardPageID = "Daily Income Distrib Card PSTD";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Daily Distributable Income";
    SourceTableView = WHERE("Quarter Closed"=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field(Date;Date)
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Daily Distributable Income";"Daily Distributable Income")
                {
                }
                field("Total Fund Units";"Total Fund Units")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                }
            }
        }
    }

    actions
    {
    }
}

