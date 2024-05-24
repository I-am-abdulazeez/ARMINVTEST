codeunit 1354 "Generate Activity Telemetry"
{
    // version NAVW113.03


    trigger OnRun()
    begin
        OnActivityTelemetry;
    end;

    var
        AlCompanyActivityCategoryTxt: Label 'AL Company Activity', Comment='Locked';
        GLEntryTelemetryMsg: Label 'G/L Entries: %1', Comment='Locked';
        OpenDocsTelemetryMsg: Label 'Open documents (sales+purchase): %1', Comment='Locked';
        PostedDocsTelemetryMsg: Label 'Posted documents (sales+purchase): %1', Comment='Locked';

    [EventSubscriber(ObjectType::Codeunit, 1354, 'OnActivityTelemetry', '', true, true)]
    local procedure SendTelemetryOnActivityTelemetry()
    var
        GLEntry: Record "G/L Entry";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        TableInformation: Record "Table Information";
        GLEntriesCount: Integer;
        SalesHeaderCount: Integer;
        PurchaseHeaderCount: Integer;
        SalesInvoiceHeaderCount: Integer;
        PurchInvHeaderCount: Integer;
        GLEntriesMsg: Text;
        OpenInvoicesMsg: Text;
        PostedInvoicesMsg: Text;
    begin
        TableInformation.SetRange("Company Name",CompanyName);

        GLEntriesCount := GetNoOfRecords(TableInformation,GLEntry.TableName);
        SalesHeaderCount := GetNoOfRecords(TableInformation,SalesHeader.TableName);
        PurchaseHeaderCount := GetNoOfRecords(TableInformation,PurchaseHeader.TableName);
        SalesInvoiceHeaderCount := GetNoOfRecords(TableInformation,SalesInvoiceHeader.TableName);
        PurchInvHeaderCount := GetNoOfRecords(TableInformation,PurchInvHeader.TableName);

        GLEntriesMsg := StrSubstNo(GLEntryTelemetryMsg,GLEntriesCount);
        SendTraceTag('000018W',AlCompanyActivityCategoryTxt,VERBOSITY::Normal,GLEntriesMsg,DATACLASSIFICATION::SystemMetadata);

        OpenInvoicesMsg := StrSubstNo(OpenDocsTelemetryMsg,SalesHeaderCount + PurchaseHeaderCount);
        SendTraceTag('000018X',AlCompanyActivityCategoryTxt,VERBOSITY::Normal,OpenInvoicesMsg,DATACLASSIFICATION::SystemMetadata);

        PostedInvoicesMsg := StrSubstNo(PostedDocsTelemetryMsg,SalesInvoiceHeaderCount + PurchInvHeaderCount);
        SendTraceTag('000018Y',AlCompanyActivityCategoryTxt,VERBOSITY::Normal,PostedInvoicesMsg,DATACLASSIFICATION::SystemMetadata);
    end;

    local procedure GetNoOfRecords(TableInformation: Record "Table Information";TableName: Text[30]): Integer
    begin
        TableInformation.SetRange("Table Name",TableName);
        if TableInformation.FindFirst then
          exit(TableInformation."No. of Records");
        exit(-1);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnActivityTelemetry()
    begin
    end;
}

