page 50149 "Notification Templates"
{
    PageType = List;
    SourceTable = "Notification Template";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field("Notification Body";"Notification Body")
                {
                }
                field("Notification Method";"Notification Method")
                {
                }
                field(Description;Description)
                {
                }
                field(Type;Type)
                {
                }
                field(Default;Default)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ExportContent)
            {
                Caption = 'Export Template Content';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportNotification(true);
                end;
            }
            action(ImportContent)
            {
                Caption = 'Import Template Content';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImportNotification;
                end;
            }
            action(DeleteContent)
            {
                Caption = 'Delete Template Content';
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteNotification;
                end;
            }
        }
    }
}

