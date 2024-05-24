codeunit 5505 "Graph Mgt - Sales Quote"
{
    // version NAVW113.03


    trigger OnRun()
    begin
    end;

    [Scope('Personalization')]
    procedure ProcessComplexTypes(var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer";BillToAddressJSON: Text)
    begin
        ParseBillToCustomerAddressFromJSON(BillToAddressJSON,SalesQuoteEntityBuffer);
    end;

    [Scope('Personalization')]
    procedure ParseBillToCustomerAddressFromJSON(BillToAddressJSON: Text;var SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer")
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
        RecRef: RecordRef;
    begin
        if BillToAddressJSON <> '' then
          with SalesQuoteEntityBuffer do begin
            RecRef.GetTable(SalesQuoteEntityBuffer);
            GraphMgtComplexTypes.ApplyPostalAddressFromJSON(BillToAddressJSON,RecRef,
              FieldNo("Sell-to Address"),FieldNo("Sell-to Address 2"),FieldNo("Sell-to City"),FieldNo("Sell-to County"),
              FieldNo("Sell-to Country/Region Code"),FieldNo("Sell-to Post Code"));
            RecRef.SetTable(SalesQuoteEntityBuffer);
          end;
    end;

    [Scope('Personalization')]
    procedure BillToCustomerAddressToJSON(SalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer") JSON: Text
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
    begin
        with SalesQuoteEntityBuffer do
          GraphMgtComplexTypes.GetPostalAddressJSON("Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to County","Sell-to Country/Region Code","Sell-to Post Code",JSON);
    end;

    [Scope('Personalization')]
    procedure UpdateIntegrationRecordIds(OnlyRecordsWithoutID: Boolean)
    var
        DummySalesQuoteEntityBuffer: Record "Sales Quote Entity Buffer";
        DummyCustomer: Record Customer;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        SalesQuoteEntityBufferRecordRef: RecordRef;
        CustomerRecordRef: RecordRef;
    begin
        CustomerRecordRef.Open(DATABASE::Customer);
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          CustomerRecordRef,DummyCustomer.FieldNo(Id),true);

        SalesQuoteEntityBufferRecordRef.Open(DATABASE::"Sales Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          SalesQuoteEntityBufferRecordRef,DummySalesQuoteEntityBuffer.FieldNo(Id),OnlyRecordsWithoutID);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5465, 'ApiSetup', '', false, false)]
    local procedure HandleApiSetup()
    var
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
    begin
        UpdateIntegrationRecordIds(false);
        GraphMgtSalesQuoteBuffer.UpdateBufferTableRecords;
    end;
}

