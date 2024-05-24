table 915 "ATO Sales Buffer"
{
    // version NAVW113.00

    Caption = 'ATO Sales Buffer';
    ReplicateData = false;

    fields
    {
        field(1;Type;Option)
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;
            OptionCaption = ',Sale,Total Sale,Assembly,Total Assembly';
            OptionMembers = ,Sale,"Total Sale",Assembly,"Total Assembly";
        }
        field(2;"Order No.";Code[20])
        {
            Caption = 'Order No.';
            DataClassification = SystemMetadata;
        }
        field(3;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
        }
        field(4;"Parent Item No.";Code[20])
        {
            Caption = 'Parent Item No.';
            DataClassification = SystemMetadata;
        }
        field(5;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(6;"Sales Cost";Decimal)
        {
            Caption = 'Sales Cost';
            DataClassification = SystemMetadata;
        }
        field(7;"Sales Amount";Decimal)
        {
            Caption = 'Sales Amount';
            DataClassification = SystemMetadata;
        }
        field(8;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DataClassification = SystemMetadata;
        }
        field(9;"Parent Description";Text[50])
        {
            Caption = 'Parent Description';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1;Type,"Order No.","Item No.","Parent Item No.")
        {
        }
        key(Key2;"Item No.",Type,"Parent Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    [Scope('Personalization')]
    procedure UpdateBufferWithComp(CompATOSalesBuffer: Record "ATO Sales Buffer";ProfitPct: Decimal;IsTotal: Boolean)
    begin
        Init;
        if IsTotal then
          Type := Type::"Total Assembly"
        else
          Type := Type::Assembly;
        "Order No." := '';
        "Item No." := CompATOSalesBuffer."Item No.";
        if not IsTotal then
          "Parent Item No." := CompATOSalesBuffer."Parent Item No."
        else
          "Parent Item No." := '';
        if Find then begin
          Quantity += CompATOSalesBuffer.Quantity;
          "Sales Cost" += CompATOSalesBuffer."Sales Cost";
          "Sales Amount" += CalcSalesAmt(CompATOSalesBuffer."Sales Cost",ProfitPct);
          "Profit %" := CalcSalesProfitPct("Sales Cost","Sales Amount");
          Modify;
          exit;
        end;

        Quantity := CompATOSalesBuffer.Quantity;
        "Sales Cost" := CompATOSalesBuffer."Sales Cost";
        "Sales Amount" := CalcSalesAmt(CompATOSalesBuffer."Sales Cost",ProfitPct);
        "Profit %" := ProfitPct;
        Insert;
    end;

    [Scope('Personalization')]
    procedure UpdateBufferWithItemLedgEntry(ItemLedgEntry: Record "Item Ledger Entry";IsTotal: Boolean)
    begin
        ItemLedgEntry.CalcFields("Cost Amount (Expected)","Cost Amount (Actual)","Sales Amount (Actual)","Sales Amount (Expected)");

        Init;
        "Item No." := ItemLedgEntry."Item No.";
        "Order No." := '';
        "Parent Item No." := '';
        case ItemLedgEntry."Entry Type" of
          ItemLedgEntry."Entry Type"::Sale:
            if IsTotal then
              Type := Type::"Total Sale"
            else begin
              Type := Type::Sale;
              "Order No." := FindATO(ItemLedgEntry);
            end;
          ItemLedgEntry."Entry Type"::"Assembly Consumption":
            begin
              if IsTotal then
                Type := Type::"Total Assembly"
              else
                Type := Type::Assembly;
              "Parent Item No." := ItemLedgEntry."Source No.";
            end;
        end;
        if Find then begin
          Quantity += -ItemLedgEntry.Quantity;
          "Sales Cost" += -(ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)");
          "Sales Amount" += ItemLedgEntry."Sales Amount (Actual)" + ItemLedgEntry."Sales Amount (Expected)";
          "Profit %" := CalcSalesProfitPct("Sales Cost","Sales Amount");
          Modify;
          exit;
        end;

        Quantity := -ItemLedgEntry.Quantity;
        "Sales Cost" := -(ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)");
        "Sales Amount" := ItemLedgEntry."Sales Amount (Actual)" + ItemLedgEntry."Sales Amount (Expected)";
        "Profit %" := CalcSalesProfitPct("Sales Cost","Sales Amount");
        Insert;
    end;

    local procedure FindATO(ItemLedgEntry: Record "Item Ledger Entry"): Code[20]
    var
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        ItemApplnEntry: Record "Item Application Entry";
    begin
        if not ItemLedgEntry."Assemble to Order" then
          exit('');

        if ItemLedgEntry."Document Type" <> ItemLedgEntry."Document Type"::"Sales Shipment" then
          exit('');

        PostedATOLink.SetCurrentKey("Document Type","Document No.","Document Line No.");
        PostedATOLink.SetRange("Document Type",PostedATOLink."Document Type"::"Sales Shipment");
        PostedATOLink.SetRange("Document No.",ItemLedgEntry."Document No.");
        PostedATOLink.SetRange("Document Line No.",ItemLedgEntry."Document Line No.");
        if PostedATOLink.FindFirst then
          exit(PostedATOLink."Assembly Order No.");

        if ItemLedgEntry.Correction then
          if ItemApplnEntry.AppliedFromEntryExists(ItemLedgEntry."Entry No.") then begin
            ItemLedgEntry.Get(ItemApplnEntry."Outbound Item Entry No.");
            exit(FindATO(ItemLedgEntry));
          end;
    end;

    local procedure CalcSalesAmt(SalesCost: Decimal;ProfitPct: Decimal): Decimal
    begin
        if ProfitPct = 100 then
          exit(0);
        exit(Round(100 * SalesCost / (100 - ProfitPct)))
    end;

    local procedure CalcSalesProfitPct(CostAmt: Decimal;SalesAmt: Decimal): Decimal
    begin
        if SalesAmt = 0 then
          exit(0);
        exit(Round(100 * (SalesAmt - CostAmt) / SalesAmt));
    end;
}

