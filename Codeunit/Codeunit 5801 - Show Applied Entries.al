codeunit 5801 "Show Applied Entries"
{
    // version NAVW110.0

    Permissions = TableData "Item Ledger Entry"=rim,
                  TableData "Item Application Entry"=r;
    TableNo = "Item Ledger Entry";

    trigger OnRun()
    begin
        TempItemEntry.DeleteAll;
        FindAppliedEntry(Rec);
        PAGE.RunModal(PAGE::"Applied Item Entries",TempItemEntry);
    end;

    var
        TempItemEntry: Record "Item Ledger Entry" temporary;

    local procedure FindAppliedEntry(ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemLedgEntry do
          if Positive then begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentKey("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Inbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetFilter("Outbound Item Entry No.",'<>%1',0);
            ItemApplnEntry.SetRange("Cost Application",true);
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity);
              until ItemApplnEntry.Next = 0;
          end else begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
            ItemApplnEntry.SetRange("Outbound Item Entry No.","Entry No.");
            ItemApplnEntry.SetRange("Item Ledger Entry No.","Entry No.");
            ItemApplnEntry.SetRange("Cost Application",true);
            if ItemApplnEntry.Find('-') then
              repeat
                InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity);
              until ItemApplnEntry.Next = 0;
          end;
    end;

    local procedure InsertTempEntry(EntryNo: Integer;AppliedQty: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Get(EntryNo);
        if AppliedQty * ItemLedgEntry.Quantity < 0 then
          exit;

        if not TempItemEntry.Get(EntryNo) then begin
          TempItemEntry.Init;
          TempItemEntry := ItemLedgEntry;
          TempItemEntry.Quantity := AppliedQty;
          TempItemEntry.Insert;
        end else begin
          TempItemEntry.Quantity := TempItemEntry.Quantity + AppliedQty;
          TempItemEntry.Modify;
        end;
    end;
}

