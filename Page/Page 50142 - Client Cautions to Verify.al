page 50142 "Client Cautions to Verify"
{
    CardPageID = "Client Caution Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Client Cautions";
    SourceTableView = WHERE(Status=CONST("Pending Verification"));

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

