codeunit 94 "Blnkt Purch Ord. to Ord. (Y/N)"
{
    // version NAVW113.02

    TableNo = "Purchase Header";

    trigger OnRun()
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        TestField("Document Type","Document Type"::"Blanket Order");
        if not ConfirmManagement.ConfirmProcess(Text000,true) then
          exit;

        BlanketPurchOrderToOrder.Run(Rec);
        BlanketPurchOrderToOrder.GetPurchOrderHeader(PurchOrderHeader);

        Message(Text001,PurchOrderHeader."No.","No.");
    end;

    var
        Text000: Label 'Do you want to create an order from the blanket order?';
        Text001: Label 'Order %1 has been created from blanket order %2.';
        PurchOrderHeader: Record "Purchase Header";
        BlanketPurchOrderToOrder: Codeunit "Blanket Purch. Order to Order";
}

