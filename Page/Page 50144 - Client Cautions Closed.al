page 50144 "Client Cautions Closed"
{
    CardPageID = "Client Caution Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Client Cautions";
    SourceTableView = WHERE(Status=CONST(Closed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Caution No";"Caution No")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Caution Type";"Caution Type")
                {
                }
                field(Description;Description)
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Cause Code";"Cause Code")
                {
                }
                field("Cause Description";"Cause Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

