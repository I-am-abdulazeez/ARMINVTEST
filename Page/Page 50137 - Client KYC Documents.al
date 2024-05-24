page 50137 "Client KYC Documents"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "KYC Links";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Client ID";"Client ID")
                {
                }
                field("KYC Type";"KYC Type")
                {
                }
                field(Link;Link)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Attachment")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SharepointIntegration.ViewDocument(Link);
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Link:=SharepointIntegration.SaveFileonsharepoint("Client ID","KYC Type","Client ID");
                    Modify;
                end;
            }
        }
    }

    var
        SharepointIntegration: Codeunit "Sharepoint Integration";
}

