codeunit 5495 "Graph Mgt - Sales Order"
{
    // version NAVW113.03

    Permissions = TableData "Sales Invoice Header"=rimd;

    trigger OnRun()
    begin
    end;

    [Scope('Personalization')]
    procedure ProcessComplexTypes(var SalesOrderEntityBuffer: Record "Sales Order Entity Buffer";BillToAddressJSON: Text)
    begin
        ParseBillToCustomerAddressFromJSON(BillToAddressJSON,SalesOrderEntityBuffer);
    end;

    [Scope('Personalization')]
    procedure ParseBillToCustomerAddressFromJSON(BillToAddressJSON: Text;var SalesOrderEntityBuffer: Record "Sales Order Entity Buffer")
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
        RecRef: RecordRef;
    begin
        if BillToAddressJSON <> '' then
          with SalesOrderEntityBuffer do begin
            RecRef.GetTable(SalesOrderEntityBuffer);
            GraphMgtComplexTypes.ApplyPostalAddressFromJSON(BillToAddressJSON,RecRef,
              FieldNo("Sell-to Address"),FieldNo("Sell-to Address 2"),FieldNo("Sell-to City"),FieldNo("Sell-to County"),
              FieldNo("Sell-to Country/Region Code"),FieldNo("Sell-to Post Code"));
            RecRef.SetTable(SalesOrderEntityBuffer);
          end;
    end;

    [Scope('Personalization')]
    procedure BillToCustomerAddressToJSON(SalesOrderEntityBuffer: Record "Sales Order Entity Buffer") JSON: Text
    var
        GraphMgtComplexTypes: Codeunit "Graph Mgt - Complex Types";
    begin
        with SalesOrderEntityBuffer do
          GraphMgtComplexTypes.GetPostalAddressJSON("Sell-to Address","Sell-to Address 2",
            "Sell-to City","Sell-to County","Sell-to Country/Region Code","Sell-to Post Code",JSON);
    end;

    [Scope('Personalization')]
    procedure UpdateIntegrationRecordIds(OnlyRecordsWithoutID: Boolean)
    var
        DummySalesOrderEntityBuffer: Record "Sales Order Entity Buffer";
        DummyCustomer: Record Customer;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        SalesHeaderRecordRef: RecordRef;
        CustomerRecordRef: RecordRef;
    begin
        CustomerRecordRef.Open(DATABASE::Customer);
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          CustomerRecordRef,DummyCustomer.FieldNo(Id),true);

        SalesHeaderRecordRef.Open(DATABASE::"Sales Header");
        GraphMgtGeneralTools.UpdateIntegrationRecords(
          SalesHeaderRecordRef,DummySalesOrderEntityBuffer.FieldNo(Id),OnlyRecordsWithoutID);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5465, 'ApiSetup', '', false, false)]
    procedure HandleApiSetup()
    var
        GraphMgtSalesOrderBuffer: Codeunit "Graph Mgt - Sales Order Buffer";
    begin
        UpdateIntegrationRecordIds(false);
        GraphMgtSalesOrderBuffer.UpdateBufferTableRecords;
    end;
}

