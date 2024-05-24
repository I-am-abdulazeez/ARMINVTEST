page 348 "Import Item Pictures"
{
    // version NAVW113.03

    Caption = 'Import Item Pictures';
    Editable = false;
    PageType = List;
    SourceTable = "Item Picture Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control6)
            {
                ShowCaption = false;
                field(ZipFileName;ZipFileName)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'Select a ZIP File';
                    Editable = false;
                    ToolTip = 'Specifies a ZIP file with pictures for upload.';
                    Width = 60;

                    trigger OnAssistEdit()
                    begin
                        if ZipFileName <> '' then begin
                          DeleteAll;
                          ZipFileName := '';
                        end;
                        LoadZIPFile(Rec,ZipFileName,TotalCount,ImportCount,ExistingCount);
                        FindFirst;
                    end;
                }
                field(TotalCount;TotalCount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Total Pictures';
                    Editable = false;
                }
                field(ImportCount;ImportCount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pictures to Import';
                    Editable = false;
                }
                field(ExistingCount;ExistingCount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Existing Pictures';
                }
            }
            repeater(Group)
            {
                Caption = 'Pictures';
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Picture Already Exists";"Picture Already Exists")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("File Name";"File Name")
                {
                    ApplicationArea = Basic,Suite;
                    Width = 20;
                }
                field("File Extension";"File Extension")
                {
                    ApplicationArea = Basic,Suite;
                    Width = 10;
                }
                field("File Size (KB)";"File Size (KB)")
                {
                    ApplicationArea = Basic,Suite;
                    Width = 10;
                }
                field("Modified Date";"Modified Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Modified Time";"Modified Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Import Status";"Import Status")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(ImportPictures)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Import Pictures';
                    Image = ImportExport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Import pictures into item cards. If the item picture already exists, a new picture will not be imported.';

                    trigger OnAction()
                    var
                        Imported: Integer;
                    begin
                        ImportPictures(Rec,Imported);
                        Message(ImportCompletedMsg,ZipFileName,Imported,ImportCount);
                        ImportCount -= Imported;
                        SetRange("Import Status","Import Status"::Completed);
                    end;
                }
                action(ShowItemCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Item Card';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=FIELD("Item No.");
                    ToolTip = 'Open the item card that contains the picture.';
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        SetRange("Import Status","Import Status"::Pending);
        if not IsEmpty then
          if not Confirm(ImportIncompleteQst,false) then begin
            SetRange("Import Status");
            exit(false);
          end;

        exit(true);
    end;

    var
        ZipFileName: Text;
        TotalCount: Integer;
        ImportCount: Integer;
        ImportCompletedMsg: Label 'Import from folder %1 completed. %2 pictures out of %3 imported.', Comment='%1 = folder name, %2 = import count, %3 total count';
        ExistingCount: Integer;
        ImportIncompleteQst: Label 'You still have pending pictures in the import worksheet. If you leave the page, you must upload the ZIP file again to import remaining pictures.\\Do you want to continue??';
}

