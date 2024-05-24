table 31 "Item Picture Buffer"
{
    // version NAVW113.03

    Caption = 'Item Picture Buffer';

    fields
    {
        field(1;"File Name";Text[250])
        {
            Caption = 'File Name';
        }
        field(2;Picture;Media)
        {
            Caption = 'Picture';
        }
        field(3;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(4;"Item Description";Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE ("No."=FIELD("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(5;"Import Status";Option)
        {
            Caption = 'Import Status';
            Editable = false;
            OptionCaption = 'Skip,Pending,Completed';
            OptionMembers = Skip,Pending,Completed;
        }
        field(6;"Picture Already Exists";Boolean)
        {
            Caption = 'Picture Already Exists';
        }
        field(7;"File Size (KB)";BigInteger)
        {
            Caption = 'File Size (KB)';
        }
        field(8;"File Extension";Text[30])
        {
            Caption = 'File Extension';
        }
        field(9;"Modified Date";Date)
        {
            Caption = 'Modified Date';
        }
        field(10;"Modified Time";Time)
        {
            Caption = 'Modified Time';
        }
    }

    keys
    {
        key(Key1;"File Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;"File Name","Item No.","Item Description",Picture)
        {
        }
    }

    var
        SelectZIPFileMsg: Label 'Select ZIP File';

    procedure LoadZIPFile(var ItemPictureBuffer: Record "Item Picture Buffer";ZipFileName: Text;var TotalCount: Integer;var ImportCount: Integer;var ExistingCount: Integer)
    var
        Item: Record Item;
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileMgt: Codeunit "File Management";
        Window: Dialog;
        InStream: InStream;
        ServerFileName: Text;
        ServerDestinationFolder: Text;
        FileSize: BigInteger;
    begin
        if ZipFileName <> '' then
          ServerFileName := ZipFileName
        else begin
          if not UploadIntoStream(SelectZIPFileMsg,'','Zip Files|*.zip',ZipFileName,InStream) then
            Error('');
          ServerFileName := FileMgt.InstreamExportToServerFile(InStream,'zip');
        end;

        ServerDestinationFolder := FileMgt.ServerCreateTempSubDirectory;
        FileMgt.ExtractZipFile(ServerFileName,ServerDestinationFolder);
        FileMgt.GetServerDirectoryFilesListInclSubDirs(TempNameValueBuffer,ServerDestinationFolder);
        FileMgt.DeleteServerFile(ServerFileName);

        Window.Open('#1##############################');

        ImportCount := 0;
        ExistingCount := 0;
        TotalCount := 0;
        ItemPictureBuffer.DeleteAll;
        TempNameValueBuffer.Reset;
        if TempNameValueBuffer.FindSet then
          repeat
            ItemPictureBuffer.Init;
            ItemPictureBuffer."File Name" :=
              CopyStr(FileMgt.GetFileNameWithoutExtension(TempNameValueBuffer.Name),1,MaxStrLen("File Name"));
            ItemPictureBuffer."File Extension" :=
              CopyStr(FileMgt.GetExtension(TempNameValueBuffer.Name),1,MaxStrLen("File Extension"));
            if not IsNullGuid(Picture.ImportFile(TempNameValueBuffer.Name,"File Name")) then begin
              Window.Update(1,ItemPictureBuffer."File Name");
              FileMgt.GetServerFileProperties(
                TempNameValueBuffer.Name,ItemPictureBuffer."Modified Date",ItemPictureBuffer."Modified Time",FileSize);
              ItemPictureBuffer."File Size (KB)" := Round(FileSize / 1000,1);
              TotalCount += 1;
              if StrLen(ItemPictureBuffer."File Name") <= MaxStrLen(Item."No.") then
                if Item.Get("File Name") then begin
                  ItemPictureBuffer."Item No." := Item."No.";
                  if Item.Picture.Count > 0 then begin
                    ItemPictureBuffer."Picture Already Exists" := true;
                    ExistingCount += 1;
                  end else begin
                    ItemPictureBuffer."Import Status" := ItemPictureBuffer."Import Status"::Pending;
                    ImportCount += 1;
                  end;
                end;
              ItemPictureBuffer.Insert;
            end;
          until TempNameValueBuffer.Next = 0;

        Window.Close;
    end;

    procedure ImportPictures(var ItemPictureBuffer: Record "Item Picture Buffer";var Imported: Integer)
    var
        Item: Record Item;
        Window: Dialog;
        ImageID: Guid;
    begin
        Imported := 0;
        Window.Open('#1############################################');

        with ItemPictureBuffer do
          if FindSet(true,false) then
            repeat
              if "Import Status" = "Import Status"::Pending then
                if ("Item No." <> '') and not "Picture Already Exists" then begin
                  Window.Update(1,"Item No.");
                  Item.Get("Item No.");
                  ImageID := Picture.MediaId;
                  Item.Picture.Insert(ImageID);
                  Item.Modify;
                  "Import Status" := "Import Status"::Completed;
                  Modify;
                  Imported += 1;
                end;
            until Next = 0;

        Window.Close;
    end;
}

