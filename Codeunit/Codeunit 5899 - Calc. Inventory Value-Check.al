codeunit 5899 "Calc. Inventory Value-Check"
{
    // version NAVW111.00

    Permissions = TableData "Avg. Cost Adjmt. Entry Point"=r;

    trigger OnRun()
    begin
    end;

    var
        Text004: Label 'Checking items #1##########';
        InvtSetup: Record "Inventory Setup";
        TempErrorBuf: Record "Error Buffer" temporary;
        PostingDate: Date;
        CalculatePer: Option "Item Ledger Entry",Item;
        ByLocation: Boolean;
        ByVariant: Boolean;
        Text007: Label 'You have to run the Adjust Cost - Item Entries batch job, before you can revalue item %1.';
        Text009: Label 'You must not revalue items with Costing Method %1, if Calculate Per is Item Ledger Entry.';
        Text011: Label 'You must not enter a %1 if you revalue items with Costing Method %2 and if Average Cost Calc. Type is %3 in Inventory Setup.';
        Text012: Label 'The By Location field must not be filled in if you revalue items with Costing Method %1 and if Average Cost Calc. Type is %2 in Inventory Setup.';
        Text014: Label 'The By Variant field must not be filled in if you revalue items with Costing Method %1 and if Average Cost Calc. Type is %2 in Inventory Setup.';
        Text015: Label 'You must fill in a Location filter and a Variant filter or select the By Location field and the By Variant field, if you revalue items with Costing Method %1, and if Average Cost Calc. Type is %2 in Inventory Setup.';
        ShowDialog: Boolean;
        Text018: Label 'The Item %1 cannot be revalued because there is at least one open outbound item ledger entry.';
        TestMode: Boolean;
        ErrorCounter: Integer;
        Text020: Label 'Open Outbound Entry %1 found.';

    [Scope('Personalization')]
    procedure SetProperties(NewPostingDate: Date;NewCalculatePer: Option;NewByLocation: Boolean;NewByVariant: Boolean;NewShowDialog: Boolean;NewTestMode: Boolean)
    begin
        TempErrorBuf.DeleteAll;
        ClearAll;

        PostingDate := NewPostingDate;
        CalculatePer := NewCalculatePer;
        ByLocation := NewByLocation;
        ByVariant := NewByVariant;
        ShowDialog := NewShowDialog;
        TestMode := NewTestMode;

        InvtSetup.Get;
    end;

    [Scope('Personalization')]
    procedure RunCheck(var Item: Record Item;var NewErrorBuf: Record "Error Buffer")
    var
        Item2: Record Item;
        Window: Dialog;
    begin
        with Item2 do begin
          Copy(Item);

          CheckCalculatePer(Item2);

          if FindSet then begin
            if ShowDialog then
              Window.Open(Text004,"No.");
            repeat
              if ShowDialog then
                Window.Update(1,"No.");

              if FindOpenOutboundEntry(Item2) then
                if not TestMode then
                  Error(Text018,"No.");
              if not Adjusted(Item2) then
                AddError(
                  StrSubstNo(Text007,"No."),DATABASE::Item,"No.",0);
            until Next = 0;
            if ShowDialog then
              Window.Close;
          end;
        end;

        TempErrorBuf.Reset;
        if TempErrorBuf.FindSet then
          repeat
            NewErrorBuf := TempErrorBuf;
            NewErrorBuf.Insert;
          until TempErrorBuf.Next = 0;
    end;

    local procedure Adjusted(Item: Record Item): Boolean
    var
        AvgCostAdjmt: Record "Avg. Cost Adjmt. Entry Point";
    begin
        if Item."Costing Method" = Item."Costing Method"::Average then begin
          AvgCostAdjmt.SetCurrentKey("Item No.","Cost Is Adjusted");
          AvgCostAdjmt.SetFilter("Item No.",Item."No.");
          AvgCostAdjmt.SetRange("Cost Is Adjusted",false);
          AvgCostAdjmt.SetRange("Valuation Date",0D,PostingDate);
          exit(AvgCostAdjmt.IsEmpty);
        end;
        exit(true);
    end;

    local procedure CheckCalculatePer(var Item: Record Item)
    var
        Item2: Record Item;
    begin
        with Item2 do begin
          CopyFilters(Item);

          FilterGroup(2);
          SetRange("Costing Method","Costing Method"::Average);
          FilterGroup(0);

          if FindFirst then
            case CalculatePer of
              CalculatePer::"Item Ledger Entry":
                AddError(
                  StrSubstNo(Text009,"Costing Method"),DATABASE::Item,"No.",0);
              CalculatePer::Item:
                begin
                  if InvtSetup."Average Cost Calc. Type" = InvtSetup."Average Cost Calc. Type"::Item then begin
                    if GetFilter("Location Filter") <> '' then
                      AddError(
                        StrSubstNo(
                          Text011,
                          FieldCaption("Location Filter"),"Costing Method",InvtSetup."Average Cost Calc. Type"),DATABASE::Item,"No.",0);
                    if GetFilter("Variant Filter") <> '' then
                      AddError(
                        StrSubstNo(
                          Text011,
                          FieldCaption("Variant Filter"),"Costing Method",InvtSetup."Average Cost Calc. Type"),DATABASE::Item,"No.",0);
                    if ByLocation then
                      AddError(
                        StrSubstNo(
                          Text012,
                          "Costing Method",InvtSetup."Average Cost Calc. Type"),DATABASE::Item,"No.",0);
                    if ByVariant then
                      AddError(
                        StrSubstNo(
                          Text014,
                          "Costing Method",InvtSetup."Average Cost Calc. Type"),DATABASE::Item,"No.",0);
                  end else
                    if ((GetFilter("Location Filter") = '') and (not ByLocation)) or
                       ((GetFilter("Variant Filter") = '') and (not ByVariant))
                    then
                      AddError(
                        StrSubstNo(
                          Text015,
                          "Costing Method",InvtSetup."Average Cost Calc. Type"),DATABASE::Item,"No.",0);
                end;
            end;
        end;
    end;

    local procedure FindOpenOutboundEntry(var Item: Record Item): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentKey("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
        ItemLedgEntry.SetRange("Item No.",Item."No.");
        ItemLedgEntry.SetRange(Open,true);
        ItemLedgEntry.SetRange(Positive,false);
        ItemLedgEntry.SetRange("Posting Date",0D,PostingDate);

        Item.CopyFilter("Variant Filter",ItemLedgEntry."Variant Code");
        Item.CopyFilter("Location Filter",ItemLedgEntry."Location Code");

        if ItemLedgEntry.FindSet then begin
          repeat
            AddError(
              StrSubstNo(Text020,ItemLedgEntry."Entry No."),
              DATABASE::"Item Ledger Entry",ItemLedgEntry."Item No.",ItemLedgEntry."Entry No.");
          until ItemLedgEntry.Next = 0;
          exit(true);
        end;

        exit(false);
    end;

    local procedure AddError(Text: Text;SourceTable: Integer;SourceNo: Code[20];SourceRefNo: Integer)
    begin
        if TestMode then begin
          ErrorCounter := ErrorCounter + 1;
          TempErrorBuf.Init;
          TempErrorBuf."Error No." := ErrorCounter;
          TempErrorBuf."Error Text" := CopyStr(Text,1,MaxStrLen(TempErrorBuf."Error Text"));
          TempErrorBuf."Source Table" := SourceTable;
          TempErrorBuf."Source No." := SourceNo;
          TempErrorBuf."Source Ref. No." := SourceRefNo;
          TempErrorBuf.Insert;
        end else
          Error(Text);
    end;
}
