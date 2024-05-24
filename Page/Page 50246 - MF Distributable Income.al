page 50246 "MF Distributable Income"
{
    // version MFD-1.0

    CardPageID = "MF Income Distrib Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Distributable Income";
    SourceTableView = WHERE(Closed=CONST(false));

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

