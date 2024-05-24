codeunit 5475 "Graph Mgt - Sales Invoice"
{
    // version NAVW113.03

    Permissions = TableData "Sales Invoice Header"=rimd;

    trigger OnRun()
    begin
    end;

    [Scope('Personalization')]
    procedure ProcessComplexTypes(var SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate";BillToAddressJSON: Text)
    begin
        ParseBillToCustomerAddressFromJSON(BillToAddressJSON,SalesInvoiceEntityAggregate);
    end;

    [Scope('Personalization')]
    procedure ParseBillToCustomerAddressFromJSON(BillToAddressJSON: Text;var SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate")
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
        RecRef: RecordRef;
    begin
        if BillToAddressJSON <> '' then
          with SalesInvoiceEntityAggregate do begin
            RecRef.GetTable(SalesInvoiceEntityAggregate);
            GraphMgtComplexTypes.ApplyPostalAddressFromJSON(BillToAddressJSON,RecRef,
              FieldNo("Sell-to Address"),FieldNo("Sell-to Address 2"),FieldNo("Sell-to City"),FieldNo("Sell-to County"),
              FieldNo("Sell-to Country/Region Code"),FieldNo("Sell-to Post Code"));
            RecRef.SetTable(SalesInvoiceEntityAggregate);
          end;
    end;

    [Scope('Personalization')]
    procedure BillToCustomerAddressToJSON(SalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate") JSON: Text
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
    begin
        with SalesInvoiceEntityAggregate do
          GraphMgtComplexTypes.GetPostalAddressJSON("Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to County","Sell-to Country/Region Code","Sell-to Post Code",JSON);
    end;

    [Scope('Personalization')]
    procedure UpdateIntegrationRecordIds(OnlyRecordsWithoutID: Boolean)
    var
        DummySalesInvoiceEntityAggregate: Record "Sales Invoice Entity Aggregate";
        DummyCustomer: Record Customer;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        SalesInvoiceHeaderRecordRef: RecordRef;
        SalesHeaderRecordRef: RecordRef;
        CustomerRecordRef: RecordRef;
    begin
        CustomerRecordRef.Open(DATABASE::Customer);
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          CustomerRecordRef,DummyCustomer.FieldNo(Id),true);

        SalesHeaderRecordRef.Open(DATABASE::"Sales Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          SalesHeaderRecordRef,DummySalesInvoiceEntityAggregate.FieldNo(Id),OnlyRecordsWithoutID);

        SalesInvoiceHeaderRecordRef.Open(DATABASE::"Sales Invoice Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          SalesInvoiceHeaderRecordRef,DummySalesInvoiceEntityAggregate.FieldNo(Id),OnlyRecordsWithoutID);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5465, 'ApiSetup', '', false, false)]
    procedure HandleApiSetup()
    var
        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
    begin
        UpdateIntegrationRecordIds(false);
        SalesInvoiceAggregator.UpdateAggregateTableRecords;
    end;
}

