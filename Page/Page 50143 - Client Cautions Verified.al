page 50143 "Client Cautions Verified"
{
    CardPageID = "Client Caution Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Client Cautions";
    SourceTableView = WHERE(Status=CONST(Verified),
                            "Request for closure"=CONST(false));

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
                field("Account No";"Account No")
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

