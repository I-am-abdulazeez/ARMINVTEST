page 50023 "Client Cautions Requests"
{
    CardPageID = "Client Caution Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Client Cautions";
    SourceTableView = WHERE(Status=FILTER(Logged));

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
        area(processing)
        {
            action("Upload Caution")
            {
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UploadCaution: XMLport "Import Caution";
                begin
                    Clear(UploadCaution);
                    UploadCaution.Run;
                end;
            }
        }
    }
}

