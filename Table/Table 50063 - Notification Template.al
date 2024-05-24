table 50063 "Notification Template"
{
    // version NAVW19.00

    Caption = 'Notification Template';

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;"Notification Body";BLOB)
        {
            Caption = 'Notification Body';
        }
        field(3;"Notification Header";BLOB)
        {
            Caption = 'Notification Header';
        }
        field(4;"Notification Footer";BLOB)
        {
            Caption = 'Notification Footer';
        }
        field(5;"Notification Method";Option)
        {
            Caption = 'Notification Method';
            OptionCaption = 'E-mail,Note';
            OptionMembers = "E-mail",Note;

            trigger OnValidate()
            begin
                if ("Notification Method" <> xRec."Notification Method") and IsUsed then
                  Error(StrSubstNo(ModifyUsedTemplateErr,FieldCaption("Notification Method")));

                CalcFields("Notification Body");
                if "Notification Body".HasValue then
                  Message(StrSubstNo(WrongBodyMsg,FieldCaption("Notification Method")))
            end;
        }
        field(6;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(7;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'New Record,Update,Overdue';
            OptionMembers = "New Record",Update,Overdue;

            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                  Default := false;
                  if IsUsed then
                    Error(StrSubstNo(ModifyUsedTemplateErr,FieldCaption(Type)));
                end;

                CalcFields("Notification Body");
                if "Notification Body".HasValue then
                  Message(StrSubstNo(WrongBodyMsg,FieldCaption(Type)));
            end;
        }
        field(8;Default;Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            begin
                if (not Default) and NoDefaultExists(true) then
                  Error('');
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        NotificationSetup: Record "Notification Setup";
    begin
        if Default then
          Error(DefaultErr);
        /*
        NotificationSetup.SETRANGE("Notification Template Code",Code);
        IF NotificationSetup.FINDFIRST THEN BEGIN
          IF NOT CONFIRM(DeleteTemplateQst) THEN
            EXIT;
          NotificationSetup.MODIFYALL("Notification Template Code",'');
        END;
        */

    end;

    trigger OnInsert()
    begin
        Default := NoDefaultExists(false);
    end;

    var
        ReplaceBodyQst: Label 'Do you want to replace the existing notification template message body?';
        DeleteBodyQst: Label 'Do you want to delete the notification template message body?';
        DeleteTemplateQst: Label 'The notification template that you are about to delete is used in the notification setup by one or more users. \\Do you want to continue?';
        DefaultErr: Label 'You cannot delete the default template.';
        ImportTxt: Label 'Select a file to import';
        FileFilterTxt: Label 'HTML Files(*.htm;*.html)|*.htm;*.html|XML Files(*.xml)|*.xml|Text Files(*.txt)|*.txt', Comment='Do not translate the file extensions (e.g. .xml, .txt, .csv, etc)';
        FileFilterExtensionTxt: Label 'txt,xml,htm,html', Locked=true;
        IteratorStartTxt: Label '%IteratorStart%', Locked=true;
        IteratorEndTxt: Label '%IteratorEnd%', Locked=true;
        TypeHelper: Codeunit "Type Helper";
        ModifyUsedTemplateErr: Label 'You cannot modify %1 when Notification Template is used.', Comment='%1 = Table Field';
        WrongBodyMsg: Label 'If you change %1, the message body may be shown incorrectly. \\Check the new message body before you use the notification template.', Comment='%1 = Message Body ';
        MissingIteratorIdentifierErr: Label 'You must either specify both start and end iteration identifiers or neither.', Locked=true;
        NewRecordNotificationHeaderTxt: Label '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"></head><body><p><span style="font-size: 11.0pt; font-family: Calibri; font-weight: bold">%SoftwareName% %Title%</span></p>', Locked=true;
        NewRecordNotificationBodyTxt: Label '<p><span style="font-size: 11.0pt; font-family: Calibri">%DocumentType% %DocumentNo%</span><span style="font-size: 11.0pt; font-family: Calibri"> %Action%</span></p><p><span style="font-size: 11.0pt; font-family: Calibri"><a href="%RTCUrl%">%RTCHyperlink%</a> (<a href="%WebUrl%">%WebHyperlink%</a>) %CustomUrl%</span></font></p>', Locked=true;
        NewRecordNotificationFooterTxt: Label '<span style="font-size: 11.0pt; font-family: Calibri"><a href="%RTCChangeSettingsHyperLink%">Change Notification Settings</a> <a href="%WebChangeSettingsHyperLink%">(Web client)</a></span></body></html>', Locked=true;
        ApprovalNotificationHeaderTxt: Label '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><span style="font-size: 12.0pt; font-family: Calibri; font-weight: bold">%Title%</span></head><body>', Locked=true;
        ApprovalNotificationBodyPart1Txt: Label '<p><span style="font-size: 11.0pt; font-family: Calibri">%DocumentType% %DocumentNo%</span><span style="font-size: 11.0pt; font-family: Calibri"> %Action%</span></p><p><span style="font-size: 11.0pt; font-family: Calibri"><a href="%RTCUrl%">%RTCHyperlink%</a> (<a href="%WebUrl%">%WebHyperlink%</a>) %CustomUrl%</span></p><table border="1" width="54%" id="table2" cellspacing="0" cellpadding="0" style="font-size: 11.0pt; font-family: Calibri"><tr><td width="139" colspan="2" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%DocumentType% %DocumentNo% %Details%</b></td></tr><tr><td width="139" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%AmountCaption%</b></td><td width="494" valign="top" style="width:370.3pt;padding:0in 5.4pt 0in 5.4pt"><p class="TableText">%CurrencyCode% %Amount%</font></td></tr>', Locked=true;
        ApprovalNotificationBodyPart2Txt: Label '<tr><td width="139" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%AmountLCYCaption%</font></b></td><td width="494" valign="top" style="width:370.3pt;padding:0in 5.4pt 0in 5.4pt"><p class="TableText">%AmountLCY%</font></td></tr><tr><td width="139" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%CustomerVendorCaption%</b></td><td width="494" valign="top" style="width:370.3pt;padding:0in 5.4pt 0in 5.4pt"><p class="TableText">%CustomerVendorNo% %CustomerVendorName%</font></td></tr><tr><td width="139" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%DueDateCaption%</font></b></td><td width="494" valign="top" style="width:370.3pt;padding:0in 5.4pt 0in 5.4pt"><p class="TableText">%DueDate%</font></td></tr>', Locked=true;
        ApprovalNotificationBodyPart3Txt: Label '<tr><td width="139" valign="top" style="width:1.45in;padding:0in 5.4pt 0in 5.4pt"><p class="TableTextBold"><b>%CreditLimitCaption%</font></b></td><td width="494" valign="top" style="width:370.3pt;padding:0in 5.4pt 0in 5.4pt"><p class="TableText">%CreditLimit%</font></td></tr></table>%ApprovalComments%', Locked=true;
        ApprovalNotificationFooterTxt: Label '<span style="font-size: 11.0pt; font-family: Calibri"><a href="%RTCChangeSettingsHyperLink%">Change Notification Settings</a> <a href="%WebChangeSettingsHyperLink%">(Web client)</a></span></body></html>', Locked=true;
        OverdueNotificationHeaderTxt: Label '<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"></head><body><p><span style="font-family: Calibri; font-size: 11.0pt; font-weight: bold">%Title%</span></p>', Locked=true;
        OverdueNotificationBodyTxt: Label '<p><span style="font-size: 11.0pt; font-family: Calibri">%DocumentType% %DocumentNo%</span><span style="font-size: 11.0pt; font-family: Calibri"> %Action%</span></p><p><span style="font-family: Calibri; font-size: 11.0pt"><a href="%RTCUrl%">%RTCHyperlink%</a> (<a href="%WebUrl%">%WebHyperlink%</a>) %CustomUrl%</span></p>', Locked=true;
        OverdueNotificationFooterTxt: Label '<span style="font-size: 11.0pt; font-family: Calibri"><a href="%RTCChangeSettingsHyperLink%">Change Notification Settings</a> <a href="%WebChangeSettingsHyperLink%">(Web client)</a></span></body></html>', Locked=true;
        Environment: DotNet Environment;
        ApprNotifTempDescTxt: Label 'Generic notification for approvals';
        NewRecNotifTempDescTxt: Label 'Basic notification for a new record';
        OverdueNotifTempDescTxt: Label 'Generic notification for overdue approval requests';

    procedure CreateNewDefault(NotificationType: Option "New Record",Approval,Overdue)
    begin
        Init;
        Code := Format(NotificationType);
        "Notification Method" := "Notification Method"::"E-mail";
        Type := NotificationType;
        Default := true;
        case NotificationType of
          Type::"New Record":
            begin
              Description := NewRecNotifTempDescTxt;
              WriteNotificationHeader(NewRecordNotificationHeaderTxt);
              WriteNotificationBody(NewRecordNotificationBodyTxt);
              WriteNotificationFooter(NewRecordNotificationFooterTxt);
            end;
          Type::Update:
            begin
              Description := ApprNotifTempDescTxt;
              WriteNotificationHeader(ApprovalNotificationHeaderTxt);
              WriteNotificationBody(ApprovalNotificationBodyPart1Txt +
                ApprovalNotificationBodyPart2Txt + ApprovalNotificationBodyPart3Txt);
              WriteNotificationFooter(ApprovalNotificationFooterTxt);
            end;
          Type::Overdue:
            begin
              Description := OverdueNotifTempDescTxt;
              WriteNotificationHeader(OverdueNotificationHeaderTxt);
              WriteNotificationBody(OverdueNotificationBodyTxt);
              WriteNotificationFooter(OverdueNotificationFooterTxt);
            end;
        end;

        if not Insert then;
    end;

    procedure ExportNotification(UseDialog: Boolean): Text
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        OutStream: OutStream;
        FileName: Text;
        NotificationBody: Text;
        NotificationHeader: Text;
        NotificationFooter: Text;
    begin
        NotificationBody := GetNotificationBody;
        NotificationHeader := GetNotificationHeader;
        NotificationFooter := GetNotificationFooter;

        FileName := TableCaption + ' ' + Code;
        case "Notification Method" of
          "Notification Method"::"E-mail":
            FileName += '.htm';
          "Notification Method"::Note:
            FileName += '.txt';
          else
            FileName += '.txt';
        end;
        TempBlob.Blob.CreateOutStream(OutStream);
        OutStream.WriteText(NotificationHeader);
        if (NotificationHeader <> '') and (NotificationFooter <> '') then
          NotificationBody := IteratorStartTxt + NotificationBody + IteratorEndTxt;
        OutStream.WriteText(NotificationBody);
        OutStream.WriteText(NotificationFooter);

        exit(FileMgt.BLOBExport(TempBlob,FileName,UseDialog));
    end;

    procedure ImportNotification()
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        FileFilter: Text;
    begin
        CalcFields("Notification Body");
        if "Notification Body".HasValue then
          if not Confirm(ReplaceBodyQst,false) then
            exit;

        case "Notification Method" of
          "Notification Method"::"E-mail":
            FileFilter := FileFilterTxt;
          "Notification Method"::Note:
            FileFilter := FileMgt.GetToFilterText('','*.txt');
          else
            FileFilter := FileFilterTxt;
        end;

        if FileMgt.BLOBImportWithFilter(TempBlob,ImportTxt,'',FileFilter,FileFilterExtensionTxt) = '' then
          exit;

        ImportNotificationText(TempBlob.ReadAsText(Environment.NewLine,TEXTENCODING::MSDos));
    end;

    procedure ImportNotificationText(NotificationContent: Text)
    var
        NotificationHeader: Text;
        NotificationFooter: Text;
        NotificationBody: Text;
    begin
        Clear("Notification Header");
        Clear("Notification Footer");
        Clear("Notification Body");

        SplitNotificationIntoParts(NotificationContent,NotificationHeader,NotificationFooter,NotificationBody);
        WriteNotificationHeader(NotificationHeader);
        WriteNotificationFooter(NotificationFooter);
        WriteNotificationBody(NotificationBody);
        Modify;
    end;

    procedure DeleteNotification()
    begin
        CalcFields("Notification Body");
        if "Notification Body".HasValue then
          if not Confirm(DeleteBodyQst,false) then
            exit;

        Clear("Notification Header");
        Clear("Notification Footer");
        Clear("Notification Body");
        Modify;
    end;

    procedure GetNotificationBody(): Text
    begin
        exit(ReadBLOB(FieldNo("Notification Body")));
    end;

    procedure GetNotificationHeader(): Text
    begin
        exit(ReadBLOB(FieldNo("Notification Header")));
    end;

    procedure GetNotificationFooter(): Text
    begin
        exit(ReadBLOB(FieldNo("Notification Footer")));
    end;

    local procedure ReadBLOB(FieldNo: Integer): Text
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecordRef.GetTable(Rec);
        FieldRef := RecordRef.Field(FieldNo);
        exit(TypeHelper.ReadTextBlob(FieldRef,Environment.NewLine));
    end;

    local procedure SplitNotificationIntoParts(NotificationContent: Text;var NotificationHeader: Text;var NotificationFooter: Text;var NotificationBody: Text)
    var
        IteratorStartPos: Integer;
        IteratorEndPos: Integer;
    begin
        IteratorStartPos := StrPos(NotificationContent,IteratorStartTxt);
        IteratorEndPos := StrPos(NotificationContent,IteratorEndTxt);
        if (IteratorStartPos <> 0) and (IteratorEndPos <> 0) then begin
          NotificationHeader := CopyStr(NotificationContent,1,IteratorStartPos - 1);
          NotificationBody :=
            CopyStr(
              NotificationContent,IteratorStartPos + StrLen(IteratorStartTxt),
              IteratorEndPos - (IteratorStartPos + StrLen(IteratorStartTxt)));
          NotificationFooter := CopyStr(NotificationContent,IteratorEndPos + StrLen(IteratorEndTxt));
        end else
          if (IteratorStartPos = 0) and (IteratorEndPos = 0) then
            NotificationBody := NotificationContent
          else
            Error(MissingIteratorIdentifierErr);
    end;

    local procedure WriteNotificationBody(Content: Text)
    var
        OutStream: OutStream;
    begin
        "Notification Body".CreateOutStream(OutStream);
        OutStream.WriteText(Content);
    end;

    local procedure WriteNotificationHeader(Content: Text)
    var
        OutStream: OutStream;
    begin
        "Notification Header".CreateOutStream(OutStream);
        OutStream.WriteText(Content);
    end;

    local procedure WriteNotificationFooter(Content: Text)
    var
        OutStream: OutStream;
    begin
        "Notification Footer".CreateOutStream(OutStream);
        OutStream.WriteText(Content);
    end;

    local procedure NoDefaultExists(ClearDefaults: Boolean): Boolean
    var
        NotificationTemplate: Record "Notification Template";
    begin
        NotificationTemplate.SetFilter(Code,'<>%1',Code);
        NotificationTemplate.SetRange(Type,Type);
        NotificationTemplate.SetRange(Default,true);
        if ClearDefaults then
          NotificationTemplate.ModifyAll(Default,false);
        exit(NotificationTemplate.IsEmpty);
    end;

    local procedure IsUsed(): Boolean
    var
        NotificationSetup: Record "Notification Setup";
    begin
        /*NotificationSetup.SETRANGE("Notification Template Code",Code);
        EXIT(NotificationSetup.FINDFIRST);*/

    end;
}

