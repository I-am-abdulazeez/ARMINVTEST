codeunit 5527 "Graph Mgt - Purchase Invoice"
{
    // version NAVW113.03

    Permissions = TableData "Purch. Inv. Header"=rimd;

    trigger OnRun()
    begin
    end;

    [Scope('Personalization')]
    procedure ProcessComplexTypes(var PurchInvEntityAggregate: Record "Purch. Inv. Entity Aggregate";PayToAddressJSON: Text)
    begin
        ParsePayToVendorAddressFromJSON(PayToAddressJSON,PurchInvEntityAggregate);
    end;

    [Scope('Personalization')]
    procedure ParsePayToVendorAddressFromJSON(PayToAddressJSON: Text;var PurchInvEntityAggregate: Record "Purch. Inv. Entity Aggregate")
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
        RecRef: RecordRef;
    begin
        if PayToAddressJSON <> '' then
          with PurchInvEntityAggregate do begin
            RecRef.GetTable(PurchInvEntityAggregate);
            GraphMgtComplexTypes.ApplyPostalAddressFromJSON(PayToAddressJSON,RecRef,
              FieldNo("Buy-from Address"),FieldNo("Buy-from Address 2"),FieldNo("Buy-from City"),FieldNo("Buy-from County"),
              FieldNo("Buy-from Country/Region Code"),FieldNo("Buy-from Post Code"));
            RecRef.SetTable(PurchInvEntityAggregate);
          end;
    end;

    [Scope('Personalization')]
    procedure PayToVendorAddressToJSON(PurchInvEntityAggregate: Record "Purch. Inv. Entity Aggregate") JSON: Text
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
    begin
        with PurchInvEntityAggregate do
          GraphMgtComplexTypes.GetPostalAddressJSON("Buy-from Address","Buy-from Address 2",
            "Buy-from City","Buy-from County","Buy-from Country/Region Code","Buy-from Post Code",JSON);
    end;

    [Scope('Personalization')]
    procedure UpdateIntegrationRecordIds(OnlyRecordsWithoutID: Boolean)
    var
        DummyPurchInvEntityAggregate: Record "Purch. Inv. Entity Aggregate";
        DummyVendor: Record Vendor;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        PurchaseInvoiceHeaderRecordRef: RecordRef;
        PurchaseHeaderRecordRef: RecordRef;
        VendorRecordRef: RecordRef;
    begin
        VendorRecordRef.Open(DATABASE::Vendor);
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          VendorRecordRef,DummyVendor.FieldNo(Id),true);

        PurchaseHeaderRecordRef.Open(DATABASE::"Purchase Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          PurchaseHeaderRecordRef,DummyPurchInvEntityAggregate.FieldNo(Id),OnlyRecordsWithoutID);

        PurchaseInvoiceHeaderRecordRef.Open(DATABASE::"Purch. Inv. Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          PurchaseInvoiceHeaderRecordRef,DummyPurchInvEntityAggregate.FieldNo(Id),OnlyRecordsWithoutID);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5465, 'ApiSetup', '', false, false)]
    procedure HandleApiSetup()
    var
        PurchInvAggregator: Codeunit "Purch. Inv. Aggregator";
    begin
        UpdateIntegrationRecordIds(false);
        PurchInvAggregator.UpdateAggregateTableRecords;
    end;
}

