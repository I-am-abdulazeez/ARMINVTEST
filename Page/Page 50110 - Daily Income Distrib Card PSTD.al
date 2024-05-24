page 50110 "Daily Income Distrib Card PSTD"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Daily Distributable Income";
    SourceTableView = WHERE("Quarter Closed"=CONST(true));

    layout
    {
        area(content)
        {
            group(General)
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
                field("Sub Units";"Sub Units")
                {
                }
                field("Redemption Units";"Redemption Units")
                {
                }
                field("EOD Nav";"EOD Nav")
                {
                }
                field("Total Fund Units";"Total Fund Units")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                }
                field("Total Line Units";"Total Line Units")
                {
                }
                field("Total Line Amount";"Total Line Amount")
                {
                }
            }
            part(Control12;"Daily Inc distrib Lines Posted")
            {
                Editable = false;
                SubPageLink = No=FIELD(No);
            }
        }
    }

    actions
    {
    }
}

