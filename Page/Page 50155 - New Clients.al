page 50155 "New Clients"
{
    PageType = List;
    SourceTable = "Initial & DDM";
    SourceTableView = WHERE(Type=CONST("New Client"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agent Code";"Agent Code")
                {
                }
                field("Agent Name";"Agent Name")
                {
                }
                field(Date;Date)
                {
                }
                field("Account No";"Account No")
                {
                }
                field("Account Name";"Account Name")
                {
                }
                field("Transaction Ref";"Transaction Ref")
                {
                }
            }
        }
    }

    actions
    {
    }
}

