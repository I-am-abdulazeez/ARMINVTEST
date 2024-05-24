codeunit 5912 "ServLedgEntries-Post"
{
    // version NAVW113.02

    Permissions = TableData "Service Ledger Entry"=rimd,
                  TableData "Warranty Ledger Entry"=rimd,
                  TableData "Service Register"=rimd;

    trigger OnRun()
    begin
    end;

    var
        ServContract: Record "Service Contract Header";
        ServLedgEntry: Record "Service Ledger Entry";
        WarrantyLedgEntry: Record "Warranty Ledger Entry";
        ServiceRegister: Record "Service Register";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ServOrderMgt: Codeunit ServOrderManagement;
        NextServLedgerEntryNo: Integer;
        NextWarrantyLedgerEntryNo: Integer;
        SrcCode: Code[10];
        Text001: Label '%1 No. %2 for Service %3 %4 cannot be posted. Please define the Service Item No. %5 in Service Contract No. %6.', Comment='Service Ledger Entry No. Line No. for Service Invoice SO000001 cannot be posted. Please define the Service Item No. 7 in Service Contract No. SC0001.';

    [Scope('Personalization')]
    procedure InitServiceRegister(var PassedServEntryNo: Integer;var PassedWarrantyEntryNo: Integer)
    var
        SrcCodeSetup: Record "Source Code Setup";
    begin
        NextServLedgerEntryNo := InitServLedgerEntry;
        NextWarrantyLedgerEntryNo := InitWarrantyLedgerEntry;
        PassedServEntryNo := NextServLedgerEntryNo;
        PassedWarrantyEntryNo := NextWarrantyLedgerEntryNo;

        with ServiceRegister do begin
          Reset;
          LockTable;
          if FindLast then
            "No." += 1
          else
            "No." := 1;
          Init;
          "From Entry No." := NextServLedgerEntryNo;
          "From Warranty Entry No." := NextWarrantyLedgerEntryNo;
          "Creation Date" := Today;
          SrcCodeSetup.Get;
          SrcCode := SrcCodeSetup."Service Management";
          "Source Code" := SrcCode;
          "User ID" := UserId;
        end;
    end;

    [Scope('Personalization')]
    procedure FinishServiceRegister(var PassedServEntryNo: Integer;var PassedWarrantyEntryNo: Integer)
    begin
        PassedServEntryNo := NextServLedgerEntryNo;
        PassedWarrantyEntryNo := NextWarrantyLedgerEntryNo;

        with ServiceRegister do begin
          "To Warranty Entry No." := NextWarrantyLedgerEntryNo - 1;
          "To Entry No." := NextServLedgerEntryNo - 1;

          if "To Warranty Entry No." < "From Warranty Entry No." then begin
            "To Warranty Entry No." := 0;
            "From Warranty Entry No." := 0;
          end;

          if "To Entry No." >= "From Entry No." then
            Insert;
        end;
    end;

    [Scope('Personalization')]
    procedure InsertServLedgerEntry(var NextEntryNo: Integer;var ServHeader: Record "Service Header";var TempServLine: Record "Service Line";var ServItemLine: Record "Service Item Line";Qty: Decimal;DocNo: Code[20]): Integer
    var
        ServItem: Record "Service Item";
        ServLedgEntry2: Record "Service Ledger Entry";
        LineAmount: Decimal;
    begin
        ServLedgEntry.LockTable;
        with TempServLine do begin
          ServLedgEntry.Init;
          ServLedgEntry."Entry No." := NextEntryNo;
          if "Contract No." <> '' then
            if ServOrderMgt.InServiceContract(TempServLine) then begin
              ServLedgEntry."Service Contract No." := "Contract No.";
              ServLedgEntry."Contract Group Code" := ServContract."Contract Group Code";
              if ServContract.Get(ServContract."Contract Type"::Contract,"Contract No.") then
                ServLedgEntry."Serv. Contract Acc. Gr. Code" :=
                  ServContract."Serv. Contract Acc. Gr. Code";
            end else
              Error(
                Text001,
                TableCaption,"Line No.",ServHeader."Document Type",
                ServHeader."No.","Service Item No.","Contract No.");

          ServLedgEntry.CopyFromServHeader(ServHeader);
          ServLedgEntry.CopyFromServLine(TempServLine,DocNo);

          if ServItemLine.Get("Document Type","Document No.","Service Item Line No.") then
            ServLedgEntry.CopyServicedInfo(
              ServItemLine."Service Item No.",ServItemLine."Item No.",ServItemLine."Serial No.",ServItemLine."Variant Code")
          else
            if ServItem.Get("Service Item No.") then
              ServLedgEntry.CopyServicedInfo(
                ServItem."No.",ServItem."Item No.",ServItem."Serial No.",ServItem."Variant Code")
            else
              if ServLedgEntry2.Get("Appl.-to Service Entry") then
                ServLedgEntry.CopyServicedInfo(
                  ServLedgEntry2."Service Item No. (Serviced)",ServLedgEntry2."Item No. (Serviced)",
                  ServLedgEntry2."Serial No. (Serviced)",ServLedgEntry2."Variant Code (Serviced)");

          ServLedgEntry."User ID" := UserId;
          ServLedgEntry."No." := "No.";
          ServLedgEntry.Quantity := Qty;
          ServLedgEntry."Charged Qty." := Qty;
          if "Qty. to Consume" <> 0 then
            ServLedgEntry."Charged Qty." := 0;

          ServLedgEntry."Unit Cost" := GetRefinedUnitCost(TempServLine);
          ServLedgEntry."Cost Amount" := Round(ServLedgEntry."Unit Cost" * Qty,Currency."Amount Rounding Precision");

          ServLedgEntry."Discount %" := "Line Discount %";
          ServLedgEntry."Responsibility Center" := ServHeader."Responsibility Center";
          ServLedgEntry."Variant Code" := "Variant Code";

          LineAmount := ServLedgEntry."Charged Qty." * "Unit Price";
          if ServHeader."Currency Code" = '' then begin
            if "Line Discount Type" = "Line Discount Type"::"Contract Disc." then
              ServLedgEntry."Contract Disc. Amount" :=
                Round("Line Discount Amount",Currency."Amount Rounding Precision");

            if ServHeader."Prices Including VAT" then begin
              ServLedgEntry."Unit Price" :=
                Round("Unit Price" / (1 + "VAT %" / 100),Currency."Unit-Amount Rounding Precision");
              ServLedgEntry."Discount Amount" :=
                UsageServiceLedgerEntryDiscountAmount(
                  "Qty. to Consume" <> 0,"Line Discount Amount","VAT %",Currency."Amount Rounding Precision",true);
              ServLedgEntry."Amount (LCY)" :=
                Round(LineAmount / (1 + "VAT %" / 100),Currency."Amount Rounding Precision") - ServLedgEntry."Discount Amount";
            end else begin
              ServLedgEntry."Unit Price" :=
                Round("Unit Price",Currency."Unit-Amount Rounding Precision");
              ServLedgEntry."Discount Amount" :=
                UsageServiceLedgerEntryDiscountAmount(
                  "Qty. to Consume" <> 0,"Line Discount Amount","VAT %",Currency."Amount Rounding Precision",false);
              ServLedgEntry."Amount (LCY)" :=
                Round(LineAmount,Currency."Amount Rounding Precision") - ServLedgEntry."Discount Amount";
            end;
            ServLedgEntry.Amount := ServLedgEntry."Amount (LCY)";
          end else begin
            if "Line Discount Type" = "Line Discount Type"::"Contract Disc." then
              ServLedgEntry."Contract Disc. Amount" := AmountToLCY(ServHeader,"Line Discount Amount");

            if ServHeader."Prices Including VAT" then begin
              ServLedgEntry."Unit Price" := UnitAmountToLCY(ServHeader,"Unit Price" / (1 + "VAT %" / 100));
              ServLedgEntry."Discount Amount" := AmountToLCY(ServHeader,"Line Discount Amount" / (1 + "VAT %" / 100));
              ServLedgEntry."Amount (LCY)" := AmountToLCY(ServHeader,(LineAmount - "Line Discount Amount") / (1 + "VAT %" / 100));
            end else begin
              ServLedgEntry."Unit Price" := UnitAmountToLCY(ServHeader,"Unit Price");
              ServLedgEntry."Discount Amount" := AmountToLCY(ServHeader,"Line Discount Amount");
              ServLedgEntry."Amount (LCY)" := AmountToLCY(ServHeader,LineAmount - "Line Discount Amount");
            end;
            ServLedgEntry.Amount := AmountToFCY(ServHeader,ServLedgEntry."Amount (LCY)");
          end;
          if "Qty. to Consume" <> 0 then
            ServLedgEntry."Discount Amount" := 0;

          ServLedgEntry.Insert;
          NextEntryNo := NextEntryNo + 1;
          NextServLedgerEntryNo := NextEntryNo;

          exit(ServLedgEntry."Entry No.");
        end;
    end;

    [Scope('Personalization')]
    procedure InsertServLedgerEntrySale(var PassedNextEntryNo: Integer;var ServHeader: Record "Service Header";var ServLine: Record "Service Line";var ServItemLine: Record "Service Item Line";Qty: Decimal;QtyToCharge: Decimal;GenJnlLineDocNo: Code[20];DocLineNo: Integer)
    var
        PServItemLine: Record "Service Item Line";
        ServShptLine: Record "Service Shipment Line";
        ApplyToServLedgEntry: Record "Service Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        ServItem: Record "Service Item";
        TotalAmount: Decimal;
    begin
        if (ServLine."Document No." = '') and
           (ServLine."Contract No." = '')
        then
          exit;

        GetCurrencyRec(ServHeader."Currency Code");

        if ApplyToServLedgEntry.Get(ServLine."Appl.-to Service Entry") then begin
          if ApplyToServLedgEntry.Type = ApplyToServLedgEntry.Type::"Service Contract" then begin
            ServLedgEntry.Reset;
            ServLedgEntry.SetCurrentKey(
              "Service Contract No.","Entry No.","Entry Type",Type,"Moved from Prepaid Acc.");
            ServLedgEntry.SetRange("Service Contract No.",ApplyToServLedgEntry."Service Contract No.");
            ServLedgEntry.SetRange("Entry Type",ApplyToServLedgEntry."Entry Type");
            ServLedgEntry.SetRange(Type,ApplyToServLedgEntry.Type);
            ServLedgEntry.SetRange("Moved from Prepaid Acc.",ApplyToServLedgEntry."Moved from Prepaid Acc.");
            ServLedgEntry.SetRange("Entry No.",ApplyToServLedgEntry."Entry No.");
            ServLedgEntry.ModifyAll(Open,false);
            if ServHeader."Document Type" = ServHeader."Document Type"::Invoice then begin
              ServLedgEntry.ModifyAll("Document Type",ServLedgEntry."Document Type"::Invoice);
              ServLedgEntry.ModifyAll("Document No.",GenJnlLineDocNo);
            end;
            exit;
          end;
          ApplyToServLedgEntry.Open := false;
          ApplyToServLedgEntry.Modify;
        end;

        ServContract.Reset;
        ServLedgEntry.Reset;
        ServLedgEntry.LockTable;

        with ServLedgEntry do begin
          Init;
          NextServLedgerEntryNo := PassedNextEntryNo;
          "Entry No." := NextServLedgerEntryNo;

          if ServLine."Contract No." <> '' then
            if ServContract.Get(ServContract."Contract Type"::Contract,ServLine."Contract No.") then begin
              "Service Contract No." := ServContract."Contract No.";
              "Contract Group Code" := ServContract."Contract Group Code";
              "Serv. Contract Acc. Gr. Code" := ServContract."Serv. Contract Acc. Gr. Code";
            end;

          if not ServItemLine.Get(ServLine."Document Type",ServLine."Document No.",ServLine."Service Item Line No.") then begin
            if (ServLine."Shipment No." <> '') and (ServLine."Shipment Line No." <> 0) then begin
              ServShptLine.Get(ServLine."Shipment No.",ServLine."Shipment Line No.");
              if not
                 PServItemLine.Get(ServItemLine."Document Type"::Order,
                   ServShptLine."Order No.",ServShptLine."Service Item Line No.")
              then
                Clear(PServItemLine);
              CopyServicedInfo(
                PServItemLine."Service Item No.",PServItemLine."Item No.",PServItemLine."Serial No.",PServItemLine."Variant Code");
            end else
              if ServItem.Get(ServLine."Service Item No.") then
                CopyServicedInfo(ServItem."No.",ServItem."Item No.",ServItem."Serial No.",ServItem."Variant Code")
          end else
            CopyServicedInfo(
              ServItemLine."Service Item No.",ServItemLine."Item No.",ServItemLine."Serial No.",ServItemLine."Variant Code");

          case ServHeader."Document Type" of
            ServHeader."Document Type"::"Credit Memo":
              "Document Type" := "Document Type"::"Credit Memo";
            else begin
              if (ServHeader."Document Type" = ServHeader."Document Type"::Order) and
                 (ServLine."Qty. to Consume" <> 0)
              then
                "Document Type" := "Document Type"::Shipment
              else
                "Document Type" := "Document Type"::Invoice;
            end;
          end;

          "Document No." := GenJnlLineDocNo;
          Open := false;
          if ServLine."Document No." <> '' then begin
            if ServHeader."Document Type" = ServHeader."Document Type"::Order then
              "Service Order No." := ServLine."Document No.";
            "Job No." := ServLine."Job No.";
            "Job Task No." := ServLine."Job Task No.";
            "Job Line Type" := ServLine."Job Line Type";
          end;

          // fill-in Service Order No with the value, taken from the shipment specified in Get Shipment Lines
          if ("Service Order No." = '') and
             (ServHeader."Document Type" = ServHeader."Document Type"::Invoice) and
             (ServLine."Shipment No." <> '')
          then
            "Service Order No." := GetOrderNoFromShipment(ServLine."Shipment No.");

          "Moved from Prepaid Acc." := true;
          "Posting Date" := ServHeader."Posting Date";
          if QtyToCharge = 0 then
            "Entry Type" := "Entry Type"::Consume
          else
            "Entry Type" := "Entry Type"::Sale;

          "Bill-to Customer No." := ServHeader."Bill-to Customer No.";
          "Customer No." := ServHeader."Customer No.";
          "Ship-to Code" := ServHeader."Ship-to Code";
          "Service Order Type" := ServHeader."Service Order Type";

          "Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
          "Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := ServLine."Dimension Set ID";
          "Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
          "Serv. Price Adjmt. Gr. Code" := ServLine."Serv. Price Adjmt. Gr. Code";
          "Service Price Group Code" := ServLine."Service Price Group Code";
          "Fault Reason Code" := ServLine."Fault Reason Code";
          "Unit of Measure Code" := ServLine."Unit of Measure Code";
          "Work Type Code" := ServLine."Work Type Code";
          "Service Item No. (Serviced)" := ServLine."Service Item No.";
          Description := ServLine.Description;
          "Responsibility Center" := ServHeader."Responsibility Center";
          "User ID" := UserId;
          "Location Code" := ServLine."Location Code";
          case ServLine.Type of
            ServLine.Type::" ":
              Type := Type::" ";
            ServLine.Type::Item:
              begin
                Type := Type::Item;
                "Bin Code" := ServLine."Bin Code";
              end;
            ServLine.Type::Resource:
              Type := Type::Resource;
            ServLine.Type::Cost:
              Type := Type::"Service Cost";
            ServLine.Type::"G/L Account":
              Type := Type::"G/L Account";
          end;
          "No." := ServLine."No.";
          "Document Line No." := DocLineNo;
          Quantity := Qty;
          "Charged Qty." := QtyToCharge;
          "Discount %" := -ServLine."Line Discount %";
          "Unit Cost" := -GetRefinedUnitCost(ServLine);
          "Cost Amount" := -Round("Unit Cost" * Qty,Currency."Amount Rounding Precision");
          if ServHeader."Currency Code" = '' then begin
            "Unit Price" := -ServLine."Unit Price";
            "Discount Amount" := ServLine."Line Discount Amount";
            "Amount (LCY)" := ServLine.Amount;
            Amount := "Amount (LCY)";
            if ServHeader."Prices Including VAT" then begin
              "Unit Price" :=
                Round("Unit Price" / (1 + ServLine."VAT %" / 100),Currency."Unit-Amount Rounding Precision");
              "Discount Amount" :=
                Round("Discount Amount" / (1 + ServLine."VAT %" / 100),Currency."Amount Rounding Precision");
            end;
          end else begin
            "Unit Price" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  ServHeader."Posting Date",ServHeader."Currency Code",
                  -ServLine."Unit Price",ServHeader."Currency Factor"),Currency."Unit-Amount Rounding Precision");

            if ServHeader."Prices Including VAT" then
              "Unit Price" := Round("Unit Price" / (1 + ServLine."VAT %" / 100),Currency."Unit-Amount Rounding Precision");

            TotalAmount := "Unit Price" * Abs("Charged Qty.");
            if "Discount %" <> 0 then
              "Discount Amount" :=
                -Round(TotalAmount * "Discount %" / 100,Currency."Amount Rounding Precision")
            else
              "Discount Amount" := 0;
            "Amount (LCY)" :=
              Round(TotalAmount - "Discount Amount",Currency."Amount Rounding Precision");
            Amount :=
              Round(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  ServHeader."Posting Date",ServHeader."Currency Code",
                  "Amount (LCY)",ServHeader."Currency Factor"),Currency."Unit-Amount Rounding Precision");
          end;

          if ApplyToServLedgEntry.Get(ServLine."Appl.-to Service Entry") then
            "Contract Disc. Amount" := ApplyToServLedgEntry."Contract Disc. Amount";

          Insert;
          NextServLedgerEntryNo += 1;
          PassedNextEntryNo := NextServLedgerEntryNo;
        end;
    end;

    local procedure InsertServLedgEntryCrMemo(var PassedNextEntryNo: Integer;var ServHeader: Record "Service Header";var ServLine: Record "Service Line";GenJnlLineDocNo: Code[20])
    var
        ServItem: Record "Service Item";
        TotalAmount: Decimal;
    begin
        if ServLine."Qty. to Invoice" = 0 then
          exit;

        GetCurrencyRec(ServHeader."Currency Code");

        ServLedgEntry.Reset;
        ServLedgEntry.LockTable;

        with ServLedgEntry do begin
          Init;
          NextServLedgerEntryNo := PassedNextEntryNo;
          "Entry No." := NextServLedgerEntryNo;

          if ServItem.Get(ServLine."Service Item No.") then begin
            "Service Item No. (Serviced)" := ServItem."No.";
            "Item No. (Serviced)" := ServItem."Item No.";
            "Serial No. (Serviced)" := ServItem."Serial No.";
          end;

          "Document Type" := "Document Type"::"Credit Memo";
          "Document No." := GenJnlLineDocNo;
          "Document Line No." := ServLine."Line No.";
          Open := false;
          "Moved from Prepaid Acc." := true;
          "Posting Date" := ServHeader."Posting Date";
          "Entry Type" := "Entry Type"::Sale;
          "Bill-to Customer No." := ServHeader."Bill-to Customer No.";
          "Customer No." := ServHeader."Customer No.";
          "Ship-to Code" := ServHeader."Ship-to Code";
          "Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
          "Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := ServLine."Dimension Set ID";
          "Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
          "Serv. Price Adjmt. Gr. Code" := ServLine."Serv. Price Adjmt. Gr. Code";
          "Service Price Group Code" := ServLine."Service Price Group Code";
          "Fault Reason Code" := ServLine."Fault Reason Code";
          "Location Code" := ServLine."Location Code";
          Description := ServLine.Description;
          "Responsibility Center" := ServHeader."Responsibility Center";
          "User ID" := UserId;
          case ServLine.Type of
            ServLine.Type::" ":
              Type := Type::" ";
            ServLine.Type::Item:
              Type := Type::Item;
            ServLine.Type::Resource:
              Type := Type::Resource;
            ServLine.Type::Cost:
              Type := Type::"Service Cost";
            ServLine.Type::"G/L Account":
              Type := Type::"G/L Account";
          end;
          if Type = Type::Item then
            "Bin Code" := ServLine."Bin Code";
          "No." := ServLine."No.";
          Quantity := ServLine.Quantity;
          "Charged Qty." := ServLine."Qty. to Invoice";
          "Discount %" := ServLine."Line Discount %";
          "Unit Cost" := GetRefinedUnitCost(ServLine);
          "Cost Amount" := Round("Unit Cost" * ServLine.Quantity,Currency."Amount Rounding Precision");
          "Job Line Type" := "Job Line Type"::" ";
          if ServHeader."Currency Code" = '' then begin
            "Unit Price" := ServLine."Unit Price";
            "Discount Amount" := ServLine."Line Discount Amount";
            "Amount (LCY)" := ServLine.Amount;
            Amount := "Amount (LCY)";
            if ServHeader."Prices Including VAT" then begin
              "Unit Price" :=
                Round("Unit Price" / (1 + ServLine."VAT %" / 100),Currency."Unit-Amount Rounding Precision");
              "Discount Amount" :=
                Round("Discount Amount" / (1 + ServLine."VAT %" / 100),Currency."Amount Rounding Precision");
            end;
          end else begin
            "Unit Price" :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  ServHeader."Posting Date",ServHeader."Currency Code",
                  ServLine."Unit Price",ServHeader."Currency Factor"));

            if ServHeader."Prices Including VAT" then
              "Unit Price" := Round("Unit Price" / (1 + ServLine."VAT %" / 100),Currency."Unit-Amount Rounding Precision");

            TotalAmount := "Unit Price" * Abs("Charged Qty.");
            if "Discount %" <> 0 then
              "Discount Amount" :=
                Abs(Round(TotalAmount * "Discount %" / 100,Currency."Amount Rounding Precision"))
            else
              "Discount Amount" := 0;
            "Amount (LCY)" :=
              Round(TotalAmount - "Discount Amount");
            Amount :=
              Round(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  ServHeader."Posting Date",ServHeader."Currency Code",
                  "Amount (LCY)",ServHeader."Currency Factor"));
          end;

          Insert;
          NextServLedgerEntryNo += 1;
          PassedNextEntryNo := NextServLedgerEntryNo;
        end;
    end;

    local procedure InsertServLedgerEntryCrMUsage(var NextEntryNo: Integer;var ServHeader: Record "Service Header";var ServLine: Record "Service Line";DocNo: Code[20])
    var
        ServItem: Record "Service Item";
        ServItemLine: Record "Service Item Line";
        LineAmount: Decimal;
    begin
        if ServLine."Qty. to Invoice" = 0 then
          exit;
        with ServLine do begin
          ServLedgEntry.Init;
          NextServLedgerEntryNo := NextEntryNo;
          ServLedgEntry."Entry No." := NextServLedgerEntryNo;

          ServLedgEntry.CopyFromServHeader(ServHeader);
          ServLedgEntry.CopyFromServLine(ServLine,DocNo);

          ServLedgEntry."Service Contract No." := "Contract No.";

          if ServItemLine.Get("Document Type","Document No.","Service Item Line No.") then
            ServLedgEntry.CopyServicedInfo(
              ServItemLine."Service Item No.",ServItemLine."Item No.",ServItemLine."Serial No.",ServItemLine."Variant Code")
          else
            if ServItem.Get("Service Item No.") then
              ServLedgEntry.CopyServicedInfo(ServItem."No.",ServItem."Item No.",ServItem."Serial No.",ServItem."Variant Code");

          ServLedgEntry."User ID" := UserId;
          ServLedgEntry."No." := "No.";
          ServLedgEntry.Quantity := -Quantity;
          ServLedgEntry."Charged Qty." := -Quantity;
          if "Qty. to Consume" <> 0 then
            ServLedgEntry."Charged Qty." := 0;

          ServLedgEntry."Unit Cost" := GetRefinedUnitCost(ServLine);
          ServLedgEntry."Cost Amount" := Round(ServLedgEntry."Unit Cost" * Quantity,Currency."Amount Rounding Precision");

          LineAmount := ServLedgEntry."Charged Qty." * "Unit Price";
          if ServHeader."Currency Code" = '' then begin
            if "Line Discount Type" = "Line Discount Type"::"Contract Disc." then
              ServLedgEntry."Contract Disc. Amount" :=
                Round("Line Discount Amount",Currency."Amount Rounding Precision");

            if ServHeader."Prices Including VAT" then begin
              ServLedgEntry."Unit Price" :=
                Round("Unit Price" / (1 + "VAT %" / 100),Currency."Unit-Amount Rounding Precision");
              ServLedgEntry."Discount Amount" :=
                - Round("Line Discount Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision");
              ServLedgEntry."Amount (LCY)" :=
                Round(LineAmount / (1 + "VAT %" / 100),Currency."Amount Rounding Precision") - ServLedgEntry."Discount Amount";
            end else begin
              ServLedgEntry."Unit Price" :=
                Round("Unit Price",Currency."Unit-Amount Rounding Precision");
              ServLedgEntry."Discount Amount" :=
                - Round("Line Discount Amount",Currency."Amount Rounding Precision");
              ServLedgEntry."Amount (LCY)" :=
                Round(LineAmount,Currency."Amount Rounding Precision") - ServLedgEntry."Discount Amount";
            end;
            ServLedgEntry.Amount := ServLedgEntry."Amount (LCY)";
          end else begin
            if "Line Discount Type" = "Line Discount Type"::"Contract Disc." then
              ServLedgEntry."Contract Disc. Amount" := AmountToLCY(ServHeader,"Line Discount Amount");

            if ServHeader."Prices Including VAT" then begin
              ServLedgEntry."Unit Price" := UnitAmountToLCY(ServHeader,"Unit Price" / (1 + "VAT %" / 100));
              ServLedgEntry."Discount Amount" := -AmountToLCY(ServHeader,"Line Discount Amount" / (1 + "VAT %" / 100));
              ServLedgEntry."Amount (LCY)" := AmountToLCY(ServHeader,(LineAmount - "Line Discount Amount") / (1 + "VAT %" / 100));
            end else begin
              ServLedgEntry."Unit Price" := UnitAmountToLCY(ServHeader,"Unit Price");
              ServLedgEntry."Discount Amount" := -AmountToLCY(ServHeader,"Line Discount Amount");
              ServLedgEntry."Amount (LCY)" := AmountToLCY(ServHeader,LineAmount - "Line Discount Amount");
            end;
            ServLedgEntry.Amount := AmountToFCY(ServHeader,ServLedgEntry."Amount (LCY)");
          end;

          if "Qty. to Consume" <> 0 then
            ServLedgEntry."Discount Amount" := 0;

          ServLedgEntry."Cost Amount" := -ServLedgEntry."Cost Amount";
          ServLedgEntry."Unit Cost" := -ServLedgEntry."Unit Cost";
          ServLedgEntry."Unit Price" := -ServLedgEntry."Unit Price";
          ServLedgEntry.Insert;
          NextEntryNo := NextEntryNo + 1;
          NextServLedgerEntryNo := NextEntryNo;
        end;
    end;

    [Scope('Personalization')]
    procedure InsertWarrantyLedgerEntry(var PassedWarrantyEntryNo: Integer;var ServHeader: Record "Service Header";var TempServLine: Record "Service Line";var ServItemLine: Record "Service Item Line";Qty: Decimal;GenJnlLineDocNo: Code[20]): Integer
    begin
        with TempServLine do begin
          if Warranty and (Type in [Type::Item,Type::Resource]) and ("Qty. to Ship" <> 0) then begin
            Clear(WarrantyLedgEntry);
            WarrantyLedgEntry.LockTable;

            WarrantyLedgEntry.Reset;
            WarrantyLedgEntry.Init;
            NextWarrantyLedgerEntryNo := PassedWarrantyEntryNo;
            WarrantyLedgEntry."Entry No." := NextWarrantyLedgerEntryNo;
            WarrantyLedgEntry."Document No." := GenJnlLineDocNo;
            WarrantyLedgEntry."Service Order Line No." := "Line No.";
            WarrantyLedgEntry."Posting Date" := "Posting Date";
            WarrantyLedgEntry."Customer No." := ServHeader."Customer No.";
            WarrantyLedgEntry."Ship-to Code" := "Ship-to Code";
            WarrantyLedgEntry."Bill-to Customer No." := ServHeader."Bill-to Customer No.";

            if not ServItemLine.Get("Document Type","Document No.","Service Item Line No.") then
              Clear(ServItemLine);
            WarrantyLedgEntry."Service Item No. (Serviced)" := ServItemLine."Service Item No.";
            WarrantyLedgEntry."Item No. (Serviced)" := ServItemLine."Item No.";
            WarrantyLedgEntry."Variant Code (Serviced)" := ServItemLine."Variant Code";
            WarrantyLedgEntry."Serial No. (Serviced)" := ServItemLine."Serial No.";
            WarrantyLedgEntry."Service Item Group (Serviced)" := ServItemLine."Service Item Group Code";
            WarrantyLedgEntry."Service Order No." := "Document No.";
            WarrantyLedgEntry."Service Contract No." := "Contract No.";
            WarrantyLedgEntry."Fault Reason Code" := "Fault Reason Code";
            WarrantyLedgEntry."Fault Area Code" := "Fault Area Code";
            WarrantyLedgEntry."Symptom Code" := "Symptom Code";
            WarrantyLedgEntry."Fault Code" := "Fault Code";
            WarrantyLedgEntry."Resolution Code" := "Resolution Code";
            WarrantyLedgEntry.Type := Type;
            WarrantyLedgEntry."No." := "No.";
            WarrantyLedgEntry.Quantity := Abs(Qty);
            WarrantyLedgEntry."Work Type Code" := "Work Type Code";
            WarrantyLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
            WarrantyLedgEntry.Description := Description;
            WarrantyLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            WarrantyLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            WarrantyLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            WarrantyLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            WarrantyLedgEntry."Dimension Set ID" := "Dimension Set ID";
            WarrantyLedgEntry.Open := true;
            WarrantyLedgEntry."Vendor No." := ServItemLine."Vendor No.";
            WarrantyLedgEntry."Vendor Item No." := ServItemLine."Vendor Item No.";
            WarrantyLedgEntry."Variant Code" := "Variant Code";

            if "Line Discount Type" = "Line Discount Type"::"Warranty Disc." then begin
              if ServHeader."Currency Code" = '' then
                WarrantyLedgEntry.Amount := "Line Discount Amount"
              else
                WarrantyLedgEntry.Amount := AmountToLCY(ServHeader,"Line Discount Amount");
              WarrantyLedgEntry.Amount := Abs(WarrantyLedgEntry.Amount);
            end;
            WarrantyLedgEntry.Insert;

            NextWarrantyLedgerEntryNo += 1;
            PassedWarrantyEntryNo := NextWarrantyLedgerEntryNo;

            exit(WarrantyLedgEntry."Entry No.");
          end;
          exit(0);
        end;
    end;

    local procedure InitServLedgerEntry(): Integer
    begin
        // returns NextEntryNo
        with ServLedgEntry do begin
          Reset;
          LockTable;
          if FindLast then
            exit("Entry No." + 1);
          exit(1);
        end;
    end;

    local procedure InitWarrantyLedgerEntry(): Integer
    begin
        with WarrantyLedgEntry do begin
          Reset;
          LockTable;
          if FindLast then
            exit("Entry No." + 1);

          exit(1);
        end;
    end;

    [Scope('Personalization')]
    procedure ReverseCnsmServLedgEntries(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
        ServLedgEntry: Record "Service Ledger Entry";
        TempNewServLedgEntry: Record "Service Ledger Entry" temporary;
    begin
        ServLedgEntry.LockTable;
        ServLedgEntry.Reset;
        ServLine.Get(ServLine."Document Type"::Order,ServShptLine."Order No.",ServShptLine."Order Line No.");
        ServLedgEntry.SetCurrentKey("Entry Type","Document Type","Document No.","Document Line No.");
        ServLedgEntry.SetFilter("Entry Type",'%1|%2',ServLedgEntry."Entry Type"::Consume,ServLedgEntry."Entry Type"::Usage);
        ServLedgEntry.SetRange("Document Type",ServLedgEntry."Document Type"::Shipment);
        ServLedgEntry.SetRange("Document No.",ServShptLine."Document No.");
        ServLedgEntry.SetRange("Document Line No.",ServShptLine."Line No.");
        if ServLedgEntry.Find('-') then begin
          repeat
            TempNewServLedgEntry.Copy(ServLedgEntry);
            InvertServLedgEntry(TempNewServLedgEntry);
            TempNewServLedgEntry."Entry No." := NextServLedgerEntryNo;
            TempNewServLedgEntry.Insert;
            NextServLedgerEntryNo += 1;
          until ServLedgEntry.Next = 0;

          with TempNewServLedgEntry do begin
            Reset;
            if FindSet then
              repeat
                ServLedgEntry.Init;
                ServLedgEntry.Copy(TempNewServLedgEntry);
                ServLedgEntry.Insert;
              until Next = 0;
            DeleteAll;
          end;
        end;
    end;

    [Scope('Personalization')]
    procedure ReverseServLedgEntry(var ServShptLine: Record "Service Shipment Line")
    var
        ServLedgEntry: Record "Service Ledger Entry";
        NewServLedgEntry: Record "Service Ledger Entry";
    begin
        ServLedgEntry.LockTable;
        if ServLedgEntry.Get(ServShptLine."Appl.-to Service Entry") then begin
          NewServLedgEntry := ServLedgEntry;
          NewServLedgEntry."Entry No." := NextServLedgerEntryNo;
          InvertServLedgEntry(NewServLedgEntry);
          NewServLedgEntry.Insert;
          NextServLedgerEntryNo += 1;
        end;
    end;

    local procedure InvertServLedgEntry(var ServLedgEntry: Record "Service Ledger Entry")
    begin
        with ServLedgEntry do begin
          Amount := -Amount;
          "Amount (LCY)" := -"Amount (LCY)";
          "Cost Amount" := -"Cost Amount";
          "Contract Disc. Amount" := -"Contract Disc. Amount";
          "Discount Amount" := -"Discount Amount";
          "Charged Qty." := -"Charged Qty.";
          Quantity := -Quantity;
        end;
    end;

    [Scope('Personalization')]
    procedure ReverseWarrantyEntry(var ServShptLine: Record "Service Shipment Line")
    var
        WarrantyLedgEntry: Record "Warranty Ledger Entry";
        NewWarrantyLedgEntry: Record "Warranty Ledger Entry";
    begin
        WarrantyLedgEntry.LockTable;
        if WarrantyLedgEntry.Get(ServShptLine."Appl.-to Warranty Entry") then begin
          WarrantyLedgEntry.Open := false;
          WarrantyLedgEntry.Modify;
          NewWarrantyLedgEntry := WarrantyLedgEntry;
          NewWarrantyLedgEntry."Entry No." := NextWarrantyLedgerEntryNo;
          InvertWarrantyLedgEntry(NewWarrantyLedgEntry);
          NewWarrantyLedgEntry.Insert;
          NextWarrantyLedgerEntryNo += 1;
        end;
    end;

    local procedure InvertWarrantyLedgEntry(var WarrantyLedgEntry: Record "Warranty Ledger Entry")
    begin
        with WarrantyLedgEntry do begin
          Amount := -Amount;
          Quantity := -Quantity;
        end;
    end;

    [Scope('Personalization')]
    procedure CreateCreditEntry(var PassedNextEntryNo: Integer;var ServHeader: Record "Service Header";var ServLine: Record "Service Line";GenJnlLineDocNo: Code[20])
    var
        ServShptHeader: Record "Service Shipment Header";
        ServItem: Record "Service Item";
        ServContractAccGr: Record "Service Contract Account Group";
        ApplyToServLedgEntry: Record "Service Ledger Entry";
        ServDocReg: Record "Service Document Register";
        ServDocType: Integer;
        ServDocNo: Code[20];
    begin
        if ServLine."Contract No." = '' then begin
          InsertServLedgEntryCrMemo(PassedNextEntryNo,ServHeader,ServLine,GenJnlLineDocNo);
          InsertServLedgerEntryCrMUsage(PassedNextEntryNo,ServHeader,ServLine,GenJnlLineDocNo);
          exit;
        end;

        if ServLine.Type = ServLine.Type::" " then
          exit;

        ServHeader.Get(ServLine."Document Type",ServLine."Document No.");
        if ServHeader."Document Type" <> ServHeader."Document Type"::"Credit Memo" then
          exit;

        GetCurrencyRec(ServHeader."Currency Code");
        Clear(ServLedgEntry);
        with ServLedgEntry do begin
          Init;
          NextServLedgerEntryNo := PassedNextEntryNo;
          "Entry No." := NextServLedgerEntryNo;

          if ServLine."Shipment No." <> '' then begin
            ServShptHeader.Get(ServLine."Shipment No.");
            ServLine.TestField("Contract No.",ServShptHeader."Contract No.");
            if ServHeader."Document Type" = ServHeader."Document Type"::Order then
              "Service Order No." := ServLine."Document No.";
          end;

          if ServLine."Contract No." <> '' then begin
            ServContract.Get(ServContract."Contract Type"::Contract,ServLine."Contract No.");
            "Service Contract No." := ServContract."Contract No.";
            "Contract Group Code" := ServContract."Contract Group Code";
          end else
            if ServShptHeader."Contract No." <> '' then begin
              ServContract.Get(ServContract."Contract Type"::Contract,ServShptHeader."Contract No.");
              "Service Contract No." := ServContract."Contract No.";
              "Contract Group Code" := ServContract."Contract Group Code";
              "Contract Invoice Period" := Format(ServContract."Invoice Period");
            end;

          if ServLine."Service Item No." <> '' then begin
            ServItem.Get(ServLine."Service Item No.");
            CopyServicedInfo(ServItem."No.",ServItem."Item No.",ServItem."Serial No.",ServItem."Variant Code");
          end;

          "Document Type" := "Document Type"::" ";
          "Document No." := GenJnlLineDocNo;
          Open := false;
          "Posting Date" := ServHeader."Posting Date";
          "Moved from Prepaid Acc." := true;
          "Entry Type" := "Entry Type"::Usage;
          "Bill-to Customer No." := ServHeader."Bill-to Customer No.";
          "Customer No." := ServHeader."Customer No.";
          "Ship-to Code" := ServHeader."Ship-to Code";
          "Location Code" := ServLine."Location Code";
          "Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
          "Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
          "Dimension Set ID" := ServLine."Dimension Set ID";
          "User ID" := UserId;
          "Job Line Type" := "Job Line Type"::" ";

          Clear(ServDocReg);
          ServDocReg.ServiceDocument(ServHeader."Document Type",ServHeader."No.",ServDocType,ServDocNo);
          case ServDocType of
            DATABASE::"Service Shipment Header",DATABASE::"Service Header":
              begin
                case ServLine.Type of
                  ServLine.Type::Item:
                    Type := Type::Item;
                  ServLine.Type::Resource:
                    Type := Type::Resource;
                  ServLine.Type::Cost:
                    Type := Type::"Service Cost";
                  ServLine.Type::"G/L Account":
                    Type := Type::"G/L Account";
                end;
                "No." := ServLine."No.";
                "Entry Type" := "Entry Type"::Sale;
                "Document Line No." := ServLine."Line No.";
                "Amount (LCY)" := -ServLine.Amount;
                Quantity := -ServLine.Quantity;
                "Charged Qty." := -ServLine."Qty. to Invoice";
                "Discount Amount" := -ServLine."Line Discount Amount";
                "Unit Cost" := -GetRefinedUnitCost(ServLine);
                "Cost Amount" := -Round("Unit Cost" * ServLine.Quantity);
                "Discount %" := -ServLine."Line Discount %";
                "Unit Price" :=
                  Round(
                    -("Amount (LCY)" + "Discount Amount") / Quantity,Currency."Unit-Amount Rounding Precision");
                "Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
                Open := false;
                Description := ServLine.Description;
                Insert;

                NextServLedgerEntryNo += 1;
                "Entry No." := NextServLedgerEntryNo;
                "Document Type" := "Document Type"::"Credit Memo";
                "Entry Type" := "Entry Type"::Sale;
                "Document Line No." := ServLine."Line No.";
                "Amount (LCY)" := ServLine.Amount;
                if ServHeader."Currency Code" <> '' then
                  Amount := AmountToFCY(ServHeader,"Amount (LCY)")
                else
                  Amount := "Amount (LCY)";
                Quantity := ServLine.Quantity;
                "Charged Qty." := ServLine."Qty. to Invoice";
                "Discount Amount" := ServLine."Line Discount Amount";
                "Unit Cost" := GetRefinedUnitCost(ServLine);
                "Cost Amount" := Round("Unit Cost" * ServLine.Quantity);
                "Discount %" := ServLine."Line Discount %";
                "Unit Price" :=
                  Round(
                    ("Amount (LCY)" + "Discount Amount") / Quantity,Currency."Unit-Amount Rounding Precision");
                Description := ServLine.Description;
                Insert;

                NextServLedgerEntryNo += 1;
              end;
            DATABASE::"Service Contract Header":
              begin
                Type := Type::"Service Contract";
                "No." := ServDocNo;
                ServContract.TestField("Serv. Contract Acc. Gr. Code");
                ServContractAccGr.Get(ServContract."Serv. Contract Acc. Gr. Code");
                if ServContract.Prepaid and (ServContractAccGr."Prepaid Contract Acc." = ServLine."No.") then begin
                  "Moved from Prepaid Acc." := false;
                  Prepaid := true;
                end;
                "Serv. Contract Acc. Gr. Code" := ServContract."Serv. Contract Acc. Gr. Code";
                "Entry No." := NextServLedgerEntryNo;
                "Document Type" := "Document Type"::"Credit Memo";
                "Entry Type" := "Entry Type"::Sale;
                "Unit Price" := ServLine."Unit Price";
                "Amount (LCY)" := ServLine.Amount;
                if ServHeader."Currency Code" <> '' then
                  Amount := AmountToFCY(ServHeader,"Amount (LCY)")
                else
                  Amount := "Amount (LCY)";
                Quantity := ServLine.Quantity;
                "Charged Qty." := ServLine."Qty. to Invoice";
                "Contract Disc. Amount" := -ServLine."Line Discount Amount";
                "Unit Cost" := ServLine."Unit Cost (LCY)";
                "Cost Amount" := Round("Unit Cost" * "Charged Qty.",Currency."Amount Rounding Precision");
                "Discount Amount" := ServLine."Line Discount Amount";
                "Discount %" := ServLine."Line Discount %";
                "Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
                Description := ServLine.Description;
                if ServLine."Appl.-to Service Entry" <> 0 then
                  if ApplyToServLedgEntry.Get(ServLine."Appl.-to Service Entry") then
                    "Posting Date" := ApplyToServLedgEntry."Posting Date";
                "Applies-to Entry No." := ServLine."Appl.-to Service Entry";
                Insert;

                NextServLedgerEntryNo += 1;
              end;
          end;

          PassedNextEntryNo := NextServLedgerEntryNo;
          InsertServLedgerEntryCrMUsage(PassedNextEntryNo,ServHeader,ServLine,GenJnlLineDocNo);
        end;
    end;

    local procedure GetCurrencyRec(CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then
          Currency.InitRoundingPrecision
        else begin
          Currency.Get(CurrencyCode);
          Currency.TestField("Unit-Amount Rounding Precision");
          Currency.TestField("Amount Rounding Precision");
        end;
    end;

    [Scope('Personalization')]
    procedure CalcDivideAmount(Qty: Decimal;var PassedServHeader: Record "Service Header";var PassedTempServLine: Record "Service Line";var PassedVATAmountLine: Record "VAT Amount Line")
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        ServAmtsMgt: Codeunit "Serv-Amounts Mgt.";
    begin
        TempVATAmountLineRemainder.DeleteAll;
        ServAmtsMgt.DivideAmount(2,Qty,PassedServHeader,PassedTempServLine,PassedVATAmountLine,TempVATAmountLineRemainder);
    end;

    local procedure GetOrderNoFromShipment(ShipmentNo: Code[20]): Code[20]
    var
        ServShptHeader: Record "Service Shipment Header";
    begin
        ServShptHeader.Get(ShipmentNo);
        exit(ServShptHeader."Order No.");
    end;

    local procedure AmountToFCY(ServiceHeader: Record "Service Header";AmountLCY: Decimal): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.Get(ServiceHeader."Currency Code");
        Currency.TestField("Amount Rounding Precision");
        exit(
          Round(
            CurrExchRate.ExchangeAmtLCYToFCY(
              ServiceHeader."Posting Date",ServiceHeader."Currency Code",
              AmountLCY,ServiceHeader."Currency Factor"),
            Currency."Amount Rounding Precision"));
    end;

    local procedure AmountToLCY(ServiceHeader: Record "Service Header";FCAmount: Decimal): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.Get(ServiceHeader."Currency Code");
        Currency.TestField("Amount Rounding Precision");
        exit(
          Round(
            CurrExchRate.ExchangeAmtFCYToLCY(
              ServiceHeader."Posting Date",ServiceHeader."Currency Code",
              FCAmount,ServiceHeader."Currency Factor"),
            Currency."Amount Rounding Precision"));
    end;

    local procedure UnitAmountToLCY(var ServiceHeader: Record "Service Header";FCAmount: Decimal): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.Get(ServiceHeader."Currency Code");
        Currency.TestField("Unit-Amount Rounding Precision");
        exit(
          Round(
            CurrExchRate.ExchangeAmtFCYToLCY(
              ServiceHeader."Posting Date",ServiceHeader."Currency Code",
              FCAmount,ServiceHeader."Currency Factor"),
            Currency."Unit-Amount Rounding Precision"));
    end;

    local procedure GetRefinedUnitCost(ServiceLine: Record "Service Line"): Decimal
    var
        Item: Record Item;
    begin
        if ServiceLine.Type = ServiceLine.Type::Item then
          if Item.Get(ServiceLine."No.") then
            if Item."Costing Method" = Item."Costing Method"::Standard then
              exit(Item."Unit Cost");

        exit(ServiceLine."Unit Cost (LCY)");
    end;

    local procedure UsageServiceLedgerEntryDiscountAmount(Consumption: Boolean;LineDiscountAmt: Decimal;VATPct: Decimal;AmountRoundingPrecision: Decimal;InclVAT: Boolean): Decimal
    begin
        if Consumption then
          exit(0);
        if not InclVAT then
          VATPct := 0;
        exit(Round(LineDiscountAmt / (1 + VATPct / 100),AmountRoundingPrecision));
    end;
}

