codeunit 1210 "Payment Export Mgt"
{
    // version NAVW113.02

    Permissions = TableData "Gen. Journal Line"=rm,
                  TableData "Data Exch."=rimd,
                  TableData "Data Exch. Field"=rimd,
                  TableData "Payment Export Data"=rimd;

    trigger OnRun()
    begin
    end;

    var
        ServerFileExtension: Text[3];
        ServerFileName: Text;
        SilentServerMode: Boolean;
        IncorrectLengthOfValuesErr: Label 'The payment that you are trying to export is different from the specified %1, %2.\\The value in the %3 field does not have the length that is required by the export format. \Expected: %4 \Actual: %5 \Field Value: %6.', Comment='%1=Data Exch.Def Type;%2=Data Exch. Def Code;%3=Field;%4=Expected length;%5=Actual length;%6=Actual Value';
        FormatNotDefinedErr: Label 'You must choose a valid export format for the bank account. Format %1 is not correctly defined.', Comment='%1 = Data Exch. Def. Code';
        DataExchLineDefNotFoundErr: Label 'The %1 export format does not support the Payment Method Code %2.', Comment='%1=Data Exch. Def. Name;%2=Data Exch. Line Def. Code';

    [Scope('Personalization')]
    procedure CreateDataExch(var DataExch: Record "Data Exch.";BankAccountCode: Code[20])
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        BankAccount.Get(BankAccountCode);
        BankAccount.TestField("Payment Export Format");
        BankExportImportSetup.Get(BankAccount."Payment Export Format");
        BankExportImportSetup.TestField("Data Exch. Def. Code");
        with DataExch do begin
          Init;
          "Data Exch. Def Code" := BankExportImportSetup."Data Exch. Def. Code";
          Insert(true);
        end;
    end;

    [Scope('Personalization')]
    procedure CreatePaymentLines(var PaymentExportData: Record "Payment Export Data")
    var
        BankAccount: Record "Bank Account";
        DataExch: Record "Data Exch.";
        PaymentExportDataRecRef: RecordRef;
    begin
        BankAccount.Get(PaymentExportData."Sender Bank Account Code");
        PaymentExportData."Sender Bank Account No." :=
          CopyStr(BankAccount.GetBankAccountNo,1,MaxStrLen(PaymentExportData."Sender Bank Account No."));
        PaymentExportData.Modify;

        DataExch.Get(PaymentExportData."Data Exch Entry No.");
        PaymentExportDataRecRef.GetTable(PaymentExportData);
        ProcessColumnMapping(DataExch,PaymentExportDataRecRef,
          PaymentExportData."Line No.",PaymentExportData."Data Exch. Line Def Code",PaymentExportDataRecRef.Number);
    end;

    [Scope('Personalization')]
    procedure ProcessColumnMapping(DataExch: Record "Data Exch.";RecRef: RecordRef;LineNo: Integer;DataExchLineDefCode: Code[20];TableID: Integer)
    var
        DataExchDef: Record "Data Exch. Def";
        DataExchColumnDef: Record "Data Exch. Column Def";
        DataExchField: Record "Data Exch. Field";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        ValueAsDestType: Variant;
        FieldRef: FieldRef;
        ValueAsString: Text[250];
    begin
        if not DataExchDef.Get(DataExch."Data Exch. Def Code") then
          Error(FormatNotDefinedErr,DataExch."Data Exch. Def Code");

        PrepopulateColumns(DataExchDef,DataExchLineDefCode,DataExch."Entry No.",LineNo);

        DataExchFieldMapping.SetRange("Data Exch. Def Code",DataExchDef.Code);
        DataExchFieldMapping.SetRange("Data Exch. Line Def Code",DataExchLineDefCode);
        DataExchFieldMapping.SetRange("Table ID",TableID);
        DataExchFieldMapping.FindSet;

        repeat
          DataExchColumnDef.Get(DataExchDef.Code,DataExchLineDefCode,DataExchFieldMapping."Column No.");

          if DataExchFieldMapping."Use Default Value" then
            ValueAsString := DataExchFieldMapping."Default Value"
          else begin
            FieldRef := RecRef.Field(DataExchFieldMapping."Field ID");
            CheckOptional(DataExchFieldMapping.Optional,FieldRef);
            CastToDestinationType(ValueAsDestType,FieldRef.Value,DataExchColumnDef,DataExchFieldMapping.Multiplier);
            ValueAsString := FormatToText(ValueAsDestType,DataExchDef,DataExchColumnDef);
          end;

          CheckLength(ValueAsString,RecRef.Field(DataExchFieldMapping."Field ID"),DataExchDef,DataExchColumnDef);

          DataExchField.Get(DataExch."Entry No.",LineNo,DataExchFieldMapping."Column No.");
          DataExchField.Value := ValueAsString;
          DataExchField.Modify;
        until DataExchFieldMapping.Next = 0;
    end;

    local procedure PrepopulateColumns(DataExchDef: Record "Data Exch. Def";DataExchLineDefCode: Code[20];DataExchEntryNo: Integer;DataExchLineNo: Integer)
    var
        DataExchField: Record "Data Exch. Field";
        DataExchLineDef: Record "Data Exch. Line Def";
        DataExchColumnDef: Record "Data Exch. Column Def";
        ColumnIndex: Integer;
    begin
        if DataExchDef."File Type" in
           [DataExchDef."File Type"::"Fixed Text",
            DataExchDef."File Type"::Xml,
            DataExchDef."File Type"::Json]
        then begin
          DataExchColumnDef.SetRange("Data Exch. Def Code",DataExchDef.Code);
          DataExchColumnDef.SetRange("Data Exch. Line Def Code",DataExchLineDefCode);
          if not DataExchColumnDef.FindSet then
            Error(DataExchLineDefNotFoundErr,DataExchDef.Name,DataExchLineDefCode);
          repeat
            DataExchField.InsertRec(
              DataExchEntryNo,DataExchLineNo,DataExchColumnDef."Column No.",
              PadStr(DataExchColumnDef.Constant,DataExchColumnDef.Length),DataExchLineDefCode)
          until DataExchColumnDef.Next = 0;
        end else begin
          if not DataExchLineDef.Get(DataExchDef.Code,DataExchLineDefCode) then
            Error(DataExchLineDefNotFoundErr,DataExchDef.Name,DataExchLineDefCode);
          for ColumnIndex := 1 to DataExchLineDef."Column Count" do
            if DataExchColumnDef.Get(DataExchDef.Code,DataExchLineDef.Code,ColumnIndex) then
              DataExchField.InsertRec(
                DataExchEntryNo,DataExchLineNo,ColumnIndex,DataExchColumnDef.Constant,DataExchLineDefCode)
            else
              DataExchField.InsertRec(DataExchEntryNo,DataExchLineNo,ColumnIndex,'',DataExchLineDefCode);
        end;
    end;

    local procedure CheckOptional(Optional: Boolean;FieldRef: FieldRef)
    var
        Value: Variant;
        StringValue: Text;
    begin
        if Optional then
          exit;

        Value := FieldRef.Value;
        StringValue := Format(Value);

        if ((Value.IsDecimal or Value.IsInteger or Value.IsBigInteger) and (StringValue = '0')) or
           (StringValue = '')
        then
          FieldRef.TestField
    end;

    local procedure CastToDestinationType(var DestinationValue: Variant;SourceValue: Variant;DataExchColumnDef: Record "Data Exch. Column Def";Multiplier: Decimal)
    var
        ValueAsDecimal: Decimal;
        ValueAsDate: Date;
        ValueAsDateTime: DateTime;
    begin
        with DataExchColumnDef do
          case "Data Type" of
            "Data Type"::Decimal:
              begin
                if Format(SourceValue) = '' then
                  ValueAsDecimal := 0
                else
                  Evaluate(ValueAsDecimal,Format(SourceValue));
                DestinationValue := Multiplier * ValueAsDecimal;
              end;
            "Data Type"::Text:
              DestinationValue := Format(SourceValue);
            "Data Type"::Date:
              begin
                Evaluate(ValueAsDate,Format(SourceValue));
                DestinationValue := ValueAsDate;
              end;
            "Data Type"::DateTime:
              begin
                Evaluate(ValueAsDateTime,Format(SourceValue,0,9),9);
                DestinationValue := ValueAsDateTime;
              end;
          end;
    end;

    local procedure FormatToText(ValueToFormat: Variant;DataExchDef: Record "Data Exch. Def";DataExchColumnDef: Record "Data Exch. Column Def"): Text[250]
    begin
        if DataExchColumnDef."Data Format" <> '' then
          exit(Format(ValueToFormat,0,DataExchColumnDef."Data Format"));

        if DataExchDef."File Type" in [DataExchDef."File Type"::Xml,
                                       DataExchDef."File Type"::Json]
        then
          exit(Format(ValueToFormat,0,9));

        if (DataExchDef."File Type" = DataExchDef."File Type"::"Fixed Text") and
           (DataExchColumnDef."Data Type" = DataExchColumnDef."Data Type"::Text)
        then
          exit(Format(ValueToFormat,0,StrSubstNo('<Text,%1>',DataExchColumnDef.Length)));

        exit(Format(ValueToFormat));
    end;

    local procedure CheckLength(Value: Text;FieldRef: FieldRef;DataExchDef: Record "Data Exch. Def";DataExchColumnDef: Record "Data Exch. Column Def")
    var
        DataExchDefCode: Code[20];
    begin
        DataExchDefCode := DataExchColumnDef."Data Exch. Def Code";

        if (DataExchColumnDef.Length > 0) and (StrLen(Value) > DataExchColumnDef.Length) then
          Error(IncorrectLengthOfValuesErr,GetType(DataExchDefCode),DataExchDefCode,
            FieldRef.Caption,DataExchColumnDef.Length,StrLen(Value),Value);

        if (DataExchDef."File Type" = DataExchDef."File Type"::"Fixed Text") and
           (StrLen(Value) <> DataExchColumnDef.Length)
        then
          Error(IncorrectLengthOfValuesErr,GetType(DataExchDefCode),DataExchDefCode,FieldRef.Caption,
            DataExchColumnDef.Length,StrLen(Value),Value);
    end;

    local procedure GetType(DataExchDefCode: Code[20]): Text
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchDef.Get(DataExchDefCode);
        exit(Format(DataExchDef.Type));
    end;

    [Scope('Internal')]
    procedure ExportToFile(EntryNo: Integer)
    var
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
        DataExchField: Record "Data Exch. Field";
    begin
        DataExch.Get(EntryNo);
        DataExchDef.Get(DataExch."Data Exch. Def Code");
        DataExchField.SetRange("Data Exch. No.",DataExch."Entry No.");
        DataExchDef.TestField("Reading/Writing XMLport");
        if not SilentServerMode then
          XMLPORT.Run(DataExchDef."Reading/Writing XMLport",false,false,DataExchField)
        else
          ExportToServerTempFile(DataExchDef."Reading/Writing XMLport",DataExchField);

        DataExchField.DeleteAll;
        DataExch.Delete
    end;

    [Scope('Personalization')]
    procedure EnableExportToServerTempFile(NewMode: Boolean;NewExtension: Text[3])
    begin
        SilentServerMode := NewMode;
        ServerFileExtension := NewExtension;
    end;

    local procedure ExportToServerTempFile(XMLPortID: Integer;var DataExchField: Record "Data Exch. Field")
    var
        FileManagement: Codeunit "File Management";
        ExportFile: File;
        OutStream: OutStream;
    begin
        ServerFileName := FileManagement.ServerTempFileName(ServerFileExtension);

        ExportFile.WriteMode := true;
        ExportFile.TextMode := true;
        ExportFile.Create(ServerFileName);
        ExportFile.CreateOutStream(OutStream);
        XMLPORT.Export(XMLPortID,OutStream,DataExchField);
        ExportFile.Close;
    end;

    [Scope('Personalization')]
    procedure GetServerTempFileName(): Text[1024]
    begin
        exit(ServerFileName);
    end;
}

