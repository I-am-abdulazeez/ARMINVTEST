page 50235 "Mass Transfer Request"
{
    CardPageID = "Mass Unit Transfer Card";
    PageType = List;
    SourceTable = "Fund Transfer Header";
    SourceTableView = WHERE("Fund Transfer Status"=CONST(Received));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field(Type;Type)
                {
                }
                field("Transfer Type";"Transfer Type")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Fund Transfer Status";"Fund Transfer Status")
                {
                    Visible = false;
                }
                field("Created By";"Created By")
                {
                }
                field("Creation Date";"Creation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

