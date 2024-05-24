page 6560 "Document Line Tracking"
{
    // version NAVW113.00

    Caption = 'Document Line Tracking';
    DataCaptionExpression = DocumentCaption;
    PageType = List;
    SourceTable = "Document Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SourceDocLineNo;SourceDocLineNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Line No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the tracked line.';
                }
                field(DocLineType;DocLineType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Type';
                    Editable = false;
                    ToolTip = 'Specifies the type of the tracked document. ';
                }
                field(DocLineNo;DocLineNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the tracked document line.';
                }
                field(DocLineDescription;DocLineDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies a description of the record.';
                }
                field(DocLineQuantity;DocLineQuantity)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity on the tracked document line.';
                }
                field(DocLineUnit;DocLineUnit)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unit of Measure Code';
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure that the item is shown in.';
                }
            }
            repeater(Control5)
            {
                Editable = false;
                ShowCaption = false;
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number that is assigned to the entry.';
                    Visible = false;
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table that stores the tracked document line.';
                    Visible = false;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the table that stores the tracked document line.';
                }
                field("No. of Records";"No. of Records")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = true;
                    ToolTip = 'Specifies how many records contain the tracked document line.';

                    trigger OnDrillDown()
                    begin
                        ShowRecords;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Show)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Show';
                Enabled = ShowEnable;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show related document.';

                trigger OnAction()
                begin
                    ShowRecords;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        TempDocumentEntry := Rec;
        if not TempDocumentEntry.Find(Which) then
          exit(false);
        Rec := TempDocumentEntry;
        exit(true);
    end;

    trigger OnInit()
    begin
        ShowEnable := true;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        CurrentSteps: Integer;
    begin
        TempDocumentEntry := Rec;
        CurrentSteps := TempDocumentEntry.Next(Steps);
        if CurrentSteps <> 0 then
          Rec := TempDocumentEntry;
        exit(CurrentSteps);
    end;

    trigger OnOpenPage()
    begin
        if (SourceDocNo = '') or (SourceDocLineNo = 0) then
          exit;

        FindRecords;
    end;

    var
        CountingRecordsMsg: Label 'Counting records...';
        SalesOrderLinesTxt: Label 'Sales Order Lines';
        ArchivedSalesOrderLinesTxt: Label 'Archived Sales Order Lines';
        PostedSalesShipmentLinesTxt: Label 'Posted Sales Shipment Lines';
        PostedSalesInvoiceLinesTxt: Label 'Posted Sales Invoice Lines';
        PurchaseOrderLinesTxt: Label 'Purchase Order Lines';
        ArchivedPurchaseOrderLinesTxt: Label 'Archived Purchase Order Lines';
        PostedPurchaseReceiptLinesTxt: Label 'Posted Purchase Receipt Lines';
        PostedPurchaseInvoiceLinesTxt: Label 'Posted Purchase Invoice Lines';
        NoSalesOrderMsg: Label 'There is no Sales Order / Archived Sales Order with this Document Number and Document Line No.';
        NoPurchaseOrderMsg: Label 'There is no Purchase Order / Archived Purchase Order with this Document Number and Document Line No.';
        ArchivedTxt: Label 'Archived';
        BlanketSalesOrderLinesTxt: Label 'Blanket Sales Order Lines';
        ArchivedBlanketSalesOrderLinesTxt: Label 'Archived Blanket Sales Order Lines';
        BlanketPurchaseOrderLinesTxt: Label 'Blanket Purchase Order Lines';
        ArchivedBlanketPurchaseOrderLinesTxt: Label 'Archived Blanket Purchase Order Lines';
        SalesReturnOrderLinesTxt: Label 'Sales Return Order Lines';
        ArchivedSalesReturnOrderLinesTxt: Label 'Archived Sales Return Order Lines';
        PostedReturnReceiptLinesTxt: Label 'Posted Return Receipt Lines';
        PostedSalesCreditMemoLinesTxt: Label 'Posted Sales Credit Memo Lines';
        PurchaseReturnOrderLinesTxt: Label 'Purchase Return Order Lines';
        ArchivedPurchaseReturnOrderLinesTxt: Label 'Archived Purchase Return Order Lines';
        PostedReturnShipmentLinesTxt: Label 'Posted Return Shipment Lines';
        PostedPurchaseCreditMemoLinesTxt: Label 'Posted Purchase Credit Memo Lines';
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesLineArchive: Record "Sales Line Archive";
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchLineArchive: Record "Purchase Line Archive";
        TempDocumentEntry: Record "Document Entry" temporary;
        ReturnReceiptLine: Record "Return Receipt Line";
        ReturnShipmentLine: Record "Return Shipment Line";
        BlanketSalesOrderLine: Record "Sales Line";
        BlanketSalesOrderLineArchive: Record "Sales Line Archive";
        BlanketPurchOrderLine: Record "Purchase Line";
        BlanketPurchOrderLineArchive: Record "Purchase Line Archive";
        Window: Dialog;
        SourceDocType: Option SalesOrder,PurchaseOrder,BlanketSalesOrder,BlanketPurchaseOrder,SalesShipment,PurchaseReceipt,SalesInvoice,PurchaseInvoice,SalesReturnOrder,PurchaseReturnOrder,SalesCreditMemo,PurchaseCreditMemo,ReturnReceipt,ReturnShipment;
        SourceDocNo: Code[20];
        SourceDocBlanketOrderNo: Code[20];
        SourceDocOrderNo: Code[20];
        SourceDocLineNo: Integer;
        SourceDocBlanketOrderLineNo: Integer;
        SourceDocOrderLineNo: Integer;
        DocumentCaption: Text[60];
        DocNo: Code[20];
        DocLineNo: Code[20];
        DocType: Text[30];
        DocArchive: Text[30];
        DocLineType: Text[30];
        DocLineDescription: Text[50];
        DocLineUnit: Text[10];
        DocLineQuantity: Decimal;
        DocExists: Boolean;
        [InDataSet]
        ShowEnable: Boolean;

    [Scope('Personalization')]
    procedure SetDoc(NewSourceDocType: Option SalesOrder,PurchaseOrder,BlanketSalesOrder,BlanketPurchaseOrder,SalesShipment,PurchaseReceipt,SalesInvoice,PurchaseInvoice,SalesReturnOrder,PurchaseReturnOrder,SalesCreditMemo,PurchaseCreditMemo,ReturnReceipt,ReturnShipment;NewDocNo: Code[20];NewSourceDocLineNo: Integer;NewDocBlanketOrderNo: Code[20];NewDocBlanketOrderLineNo: Integer;NewDocOrderNo: Code[20];NewDocOrderLineNo: Integer)
    begin
        SourceDocType := NewSourceDocType;
        SourceDocNo := NewDocNo;
        SourceDocLineNo := NewSourceDocLineNo;
        SourceDocBlanketOrderNo := NewDocBlanketOrderNo;
        SourceDocBlanketOrderLineNo := NewDocBlanketOrderLineNo;
        SourceDocOrderNo := NewDocOrderNo;
        SourceDocOrderLineNo := NewDocOrderLineNo;

        Rec := Rec;
    end;

    local procedure FindRecords()
    begin
        with TempDocumentEntry do begin
          Window.Open(CountingRecordsMsg);
          DeleteAll;
          "Entry No." := 0;

          case SourceDocType of
            SourceDocType::SalesOrder:
              FindRecordsForSalesOrder;
            SourceDocType::PurchaseOrder:
              FindRecordsForPurchOrder;
            SourceDocType::BlanketSalesOrder:
              FindRecordsForBlanketSalesOrder;
            SourceDocType::BlanketPurchaseOrder:
              FindRecordsForBlanketPurchOrder;
            SourceDocType::SalesShipment:
              FindRecordsForSalesShipment;
            SourceDocType::PurchaseReceipt:
              FindRecordsForPurchaseReceipt;
            SourceDocType::SalesInvoice:
              FindRecordsForSalesInvoice;
            SourceDocType::PurchaseInvoice:
              FindRecordsForPurchInvoice;
            SourceDocType::SalesReturnOrder:
              FindRecordsForSalesReturnOrder;
            SourceDocType::PurchaseReturnOrder:
              FindRecordsForPurchReturnOrder;
            SourceDocType::SalesCreditMemo:
              FindRecordsForSalesCreditMemo;
            SourceDocType::PurchaseCreditMemo:
              FindRecordsForPurchCreditMemo;
            SourceDocType::ReturnReceipt:
              FindRecordsForReturnReceipt;
            SourceDocType::ReturnShipment:
              FindRecordsForReturnShipment;
          end;

          GetDocumentData;

          if DocNo = '' then
            case SourceDocType of
              SourceDocType::SalesOrder:
                Message(NoSalesOrderMsg);
              SourceDocType::PurchaseOrder:
                Message(NoPurchaseOrderMsg);
            end;

          DocExists := Find('-');
          ShowEnable := DocExists;
          CurrPage.Update(false);
          DocExists := Find('-');
          if DocExists then;
          Window.Close;
        end;
    end;

    local procedure FindRecordsForSalesOrder()
    begin
        FindSalesBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesOrderLines(SourceDocNo,SourceDocLineNo);
        FindSalesOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindSalesShipmentLinesByOrder(SourceDocNo,SourceDocLineNo);
        FindSalesInvoiceLinesByOrder(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForPurchOrder()
    begin
        FindPurchBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchOrderLines(SourceDocNo,SourceDocLineNo);
        FindPurchOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindPurchReceiptLinesByOrder(SourceDocNo,SourceDocLineNo);
        FindPurchInvoiceLinesByOrder(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForBlanketSalesOrder()
    begin
        FindSalesBlanketOrderLines(SourceDocNo,SourceDocLineNo);
        FindSalesBlanketOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindSalesOrderLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindSalesOrderLinesArchiveByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindSalesShipmentLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindSalesInvoiceLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForBlanketPurchOrder()
    begin
        FindPurchBlanketOrderLines(SourceDocNo,SourceDocLineNo);
        FindPurchBlanketOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindPurchOrderLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindPurchOrderLinesArchiveByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindPurchReceiptLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
        FindPurchInvoiceLinesByBlanketOrder(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForSalesShipment()
    begin
        FindSalesBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesShipmentLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesInvoiceLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForPurchaseReceipt()
    begin
        FindPurchBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchReceiptLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchInvoiceLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForSalesInvoice()
    begin
        FindSalesBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesShipmentLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesInvoiceLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForPurchInvoice()
    begin
        FindPurchBlanketOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchBlanketOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchReceiptLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchInvoiceLinesByOrder(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForSalesReturnOrder()
    begin
        FindSalesReturnOrderLines(SourceDocNo,SourceDocLineNo);
        FindSalesReturnOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindReturnReceiptLines(SourceDocNo,SourceDocLineNo);
        FindSalesCreditMemoLines(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForPurchReturnOrder()
    begin
        FindPurchReturnOrderLines(SourceDocNo,SourceDocLineNo);
        FindPurchReturnOrderLinesArchive(SourceDocNo,SourceDocLineNo);
        FindReturnShipmentLines(SourceDocNo,SourceDocLineNo);
        FindPurchCreditMemoLines(SourceDocNo,SourceDocLineNo);
    end;

    local procedure FindRecordsForSalesCreditMemo()
    begin
        FindSalesReturnOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesReturnOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindReturnReceiptLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindSalesCreditMemoLines(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForPurchCreditMemo()
    begin
        FindPurchReturnOrderLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchReturnOrderLinesArchive(SourceDocOrderNo,SourceDocOrderLineNo);
        FindReturnShipmentLines(SourceDocOrderNo,SourceDocOrderLineNo);
        FindPurchCreditMemoLines(SourceDocOrderNo,SourceDocOrderLineNo);
    end;

    local procedure FindRecordsForReturnReceipt()
    begin
        FindSalesReturnOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesReturnOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindReturnReceiptLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindSalesCreditMemoLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
    end;

    local procedure FindRecordsForReturnShipment()
    begin
        FindPurchReturnOrderLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchReturnOrderLinesArchive(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindReturnShipmentLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
        FindPurchCreditMemoLines(SourceDocBlanketOrderNo,SourceDocBlanketOrderLineNo);
    end;

    local procedure InsertIntoDocEntry(DocTableID: Integer;DocType: Option;DocTableName: Text[50];DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
          exit;

        TempDocumentEntry.Init;
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName,1,MaxStrLen(TempDocumentEntry."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry.Insert;
    end;

    local procedure GetDocumentData()
    begin
        DocType := '';
        DocNo := '';
        DocArchive := '';
        DocLineType := '';
        DocLineNo := '';
        DocLineDescription := '';
        DocLineQuantity := 0;
        DocLineUnit := '';

        case SourceDocType of
          SourceDocType::SalesOrder:
            if SalesLine.FindFirst then
              AssignLineFields(
                Format(SalesLine."Document Type"),SalesLine."Document No.",'',Format(SalesLine.Type),
                SalesLine."No.",SalesLine.Description,SalesLine.Quantity,SalesLine."Unit of Measure Code")
            else
              if SalesLineArchive.FindFirst then
                AssignLineFields(
                  Format(SalesLineArchive."Document Type"),SalesLineArchive."Document No.",ArchivedTxt,
                  Format(SalesLineArchive.Type),SalesLineArchive."No.",SalesLineArchive.Description,
                  SalesLineArchive.Quantity,SalesLineArchive."Unit of Measure Code");
          SourceDocType::BlanketSalesOrder:
            if BlanketSalesOrderLine.FindFirst then
              AssignLineFields(
                Format(BlanketSalesOrderLine."Document Type"),BlanketSalesOrderLine."Document No.",'',
                Format(BlanketSalesOrderLine.Type),BlanketSalesOrderLine."No.",BlanketSalesOrderLine.Description,
                BlanketSalesOrderLine.Quantity,BlanketSalesOrderLine."Unit of Measure Code")
            else
              if BlanketSalesOrderLineArchive.FindFirst then
                AssignLineFields(
                  Format(BlanketSalesOrderLineArchive."Document Type"),BlanketSalesOrderLineArchive."Document No.",ArchivedTxt,
                  Format(BlanketSalesOrderLineArchive.Type),BlanketSalesOrderLineArchive."No.",BlanketSalesOrderLineArchive.Description,
                  BlanketSalesOrderLineArchive.Quantity,BlanketSalesOrderLineArchive."Unit of Measure Code");
          SourceDocType::PurchaseOrder:
            if PurchLine.FindFirst then
              AssignLineFields(
                Format(PurchLine."Document Type"),PurchLine."Document No.",'',Format(PurchLine.Type),
                PurchLine."No.",PurchLine.Description,PurchLine.Quantity,PurchLine."Unit of Measure Code")
            else
              if PurchLineArchive.FindFirst then
                AssignLineFields(
                  Format(PurchLineArchive."Document Type"),PurchLineArchive."Document No.",ArchivedTxt,Format(PurchLineArchive.Type),
                  PurchLineArchive."No.",PurchLineArchive.Description,PurchLineArchive.Quantity,PurchLineArchive."Unit of Measure Code");
          SourceDocType::BlanketPurchaseOrder:
            if BlanketPurchOrderLine.FindFirst then
              AssignLineFields(
                Format(BlanketPurchOrderLine."Document Type"),BlanketPurchOrderLine."Document No.",'',
                Format(BlanketPurchOrderLine.Type),BlanketPurchOrderLine."No.",BlanketPurchOrderLine.Description,
                BlanketPurchOrderLine.Quantity,BlanketPurchOrderLine."Unit of Measure Code")
            else
              if BlanketPurchOrderLineArchive.FindFirst then
                AssignLineFields(
                  Format(BlanketPurchOrderLineArchive."Document Type"),BlanketPurchOrderLineArchive."Document No.",ArchivedTxt,
                  Format(BlanketPurchOrderLineArchive.Type),BlanketPurchOrderLineArchive."No.",BlanketPurchOrderLineArchive.Description,
                  BlanketPurchOrderLineArchive.Quantity,BlanketPurchOrderLineArchive."Unit of Measure Code");
          SourceDocType::SalesShipment:
            if SalesShptLine.FindFirst then
              AssignLineFields(
                SalesShptLine.TableCaption,SalesShptLine."Document No.",'',Format(SalesShptLine.Type),
                SalesShptLine."No.",SalesShptLine.Description,SalesShptLine.Quantity,SalesShptLine."Unit of Measure Code");
          SourceDocType::PurchaseReceipt:
            if PurchRcptLine.FindFirst then
              AssignLineFields(
                PurchRcptLine.TableCaption,PurchRcptLine."Document No.",'',Format(PurchRcptLine.Type),
                PurchRcptLine."No.",PurchRcptLine.Description,PurchRcptLine.Quantity,PurchRcptLine."Unit of Measure Code");
          SourceDocType::SalesInvoice:
            if SalesInvLine.FindFirst then
              AssignLineFields(
                SalesInvLine.TableCaption,SalesInvLine."Document No.",'',Format(SalesInvLine.Type),
                SalesInvLine."No.",SalesInvLine.Description,SalesInvLine.Quantity,SalesInvLine."Unit of Measure Code");
          SourceDocType::PurchaseInvoice:
            if PurchInvLine.FindFirst then
              AssignLineFields(
                PurchInvLine.TableCaption,PurchInvLine."Document No.",'',Format(PurchInvLine.Type),
                PurchInvLine."No.",PurchInvLine.Description,PurchInvLine.Quantity,PurchInvLine."Unit of Measure Code");
        end;

        DocumentCaption := DelChr(DocArchive + ' ' + DocType + ' ' + DocNo,'<',' ');
    end;

    local procedure ShowRecords()
    begin
        TempDocumentEntry := Rec;
        if TempDocumentEntry.Find then
          Rec := TempDocumentEntry;

        with TempDocumentEntry do
          case "Table ID" of
            DATABASE::"Sales Line":
              begin
                if "Document Type" = "Document Type"::"Blanket Order" then
                  PAGE.RunModal(PAGE::"Sales Lines",BlanketSalesOrderLine)
                else
                  PAGE.RunModal(PAGE::"Sales Lines",SalesLine);
              end;
            DATABASE::"Sales Shipment Line":
              PAGE.RunModal(0,SalesShptLine);
            DATABASE::"Sales Invoice Line":
              PAGE.RunModal(0,SalesInvLine);
            DATABASE::"Sales Cr.Memo Line":
              PAGE.RunModal(0,SalesCrMemoLine);
            DATABASE::"Sales Line Archive":
              begin
                if "Document Type" = "Document Type"::"Blanket Order" then
                  PAGE.RunModal(PAGE::"Sales Line Archive List",BlanketSalesOrderLineArchive)
                else
                  PAGE.RunModal(PAGE::"Sales Line Archive List",SalesLineArchive);
              end;
            DATABASE::"Return Receipt Line":
              PAGE.RunModal(0,ReturnReceiptLine);
            DATABASE::"Purchase Line":
              begin
                if "Document Type" = "Document Type"::"Blanket Order" then
                  PAGE.RunModal(PAGE::"Purchase Lines",BlanketPurchOrderLine)
                else
                  PAGE.RunModal(PAGE::"Purchase Lines",PurchLine);
              end;
            DATABASE::"Purch. Rcpt. Line":
              PAGE.RunModal(0,PurchRcptLine);
            DATABASE::"Purch. Inv. Line":
              PAGE.RunModal(0,PurchInvLine);
            DATABASE::"Purch. Cr. Memo Line":
              PAGE.RunModal(0,PurchCrMemoLine);
            DATABASE::"Purchase Line Archive":
              begin
                if "Document Type" = "Document Type"::"Blanket Order" then
                  PAGE.RunModal(PAGE::"Purchase Line Archive List",BlanketPurchOrderLineArchive)
                else
                  PAGE.RunModal(PAGE::"Purchase Line Archive List",PurchLineArchive);
              end;
            DATABASE::"Return Shipment Line":
              PAGE.RunModal(0,ReturnShipmentLine);
          end;
    end;

    local procedure AssignLineFields(NewDocType: Text[30];NewDocNo: Code[20];NewDocArchive: Text[30];NewDocLineType: Text[30];NewDocLineItemNo: Code[20];NewDocLineDescription: Text[50];NewDocLineQuantity: Decimal;NewDocLineUnit: Code[10])
    begin
        DocType := NewDocType;
        DocNo := NewDocNo;
        DocArchive := NewDocArchive;
        DocLineType := NewDocLineType;
        DocLineNo := NewDocLineItemNo;
        DocLineDescription := NewDocLineDescription;
        DocLineQuantity := NewDocLineQuantity;
        DocLineUnit := NewDocLineUnit;
    end;

    local procedure FindPurchCreditMemoLines(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if PurchCrMemoLine.ReadPermission then begin
          PurchCrMemoLine.Reset;
          PurchCrMemoLine.SetRange("Order No.",OrderNo);
          PurchCrMemoLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purch. Cr. Memo Line",3,PostedPurchaseCreditMemoLinesTxt,PurchCrMemoLine.Count);
        end;
    end;

    local procedure FindPurchOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if PurchLine.ReadPermission then begin
          PurchLine.Reset;
          PurchLine.SetRange("Document Type",PurchLine."Document Type"::Order);
          PurchLine.SetRange("Document No.",DocNo);
          PurchLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line",1,PurchaseOrderLinesTxt,PurchLine.Count);
        end;
    end;

    local procedure FindPurchOrderLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if PurchLine.ReadPermission then begin
          PurchLine.Reset;
          PurchLine.SetRange("Document Type",PurchLine."Document Type"::Order);
          PurchLine.SetRange("Blanket Order No.",BlanketOrderNo);
          PurchLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line",1,PurchaseOrderLinesTxt,PurchLine.Count);
        end;
    end;

    local procedure FindPurchBlanketOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if BlanketPurchOrderLine.ReadPermission then begin
          BlanketPurchOrderLine.Reset;
          BlanketPurchOrderLine.SetRange("Document Type",BlanketPurchOrderLine."Document Type"::"Blanket Order");
          BlanketPurchOrderLine.SetRange("Document No.",DocNo);
          BlanketPurchOrderLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line",4,BlanketPurchaseOrderLinesTxt,BlanketPurchOrderLine.Count);
        end;
    end;

    local procedure FindPurchReturnOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if PurchLine.ReadPermission then begin
          PurchLine.Reset;
          PurchLine.SetRange("Document Type",PurchLine."Document Type"::"Return Order");
          PurchLine.SetRange("Document No.",DocNo);
          PurchLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line",5,PurchaseReturnOrderLinesTxt,PurchLine.Count);
        end;
    end;

    local procedure FindPurchOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if PurchLineArchive.ReadPermission then begin
          PurchLineArchive.Reset;
          PurchLineArchive.SetRange("Document Type",PurchLineArchive."Document Type"::Order);
          PurchLineArchive.SetRange("Document No.",DocNo);
          PurchLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line Archive",1,ArchivedPurchaseOrderLinesTxt,PurchLineArchive.Count);
        end;
    end;

    local procedure FindPurchBlanketOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if BlanketPurchOrderLineArchive.ReadPermission then begin
          BlanketPurchOrderLineArchive.Reset;
          BlanketPurchOrderLineArchive.SetRange("Document Type",BlanketPurchOrderLineArchive."Document Type"::"Blanket Order");
          BlanketPurchOrderLineArchive.SetRange("Document No.",DocNo);
          BlanketPurchOrderLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line Archive",4,ArchivedBlanketPurchaseOrderLinesTxt,BlanketPurchOrderLineArchive.Count);
        end;
    end;

    local procedure FindPurchReturnOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if PurchLineArchive.ReadPermission then begin
          PurchLineArchive.Reset;
          PurchLineArchive.SetRange("Document Type",PurchLineArchive."Document Type"::"Return Order");
          PurchLineArchive.SetRange("Document No.",DocNo);
          PurchLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line Archive",5,ArchivedPurchaseReturnOrderLinesTxt,PurchLineArchive.Count);
        end;
    end;

    local procedure FindPurchOrderLinesArchiveByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if PurchLineArchive.ReadPermission then begin
          PurchLineArchive.Reset;
          PurchLineArchive.SetRange("Document Type",PurchLineArchive."Document Type"::Order);
          PurchLineArchive.SetRange("Blanket Order No.",BlanketOrderNo);
          PurchLineArchive.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purchase Line Archive",1,ArchivedPurchaseOrderLinesTxt,PurchLineArchive.Count);
        end;
    end;

    local procedure FindPurchReceiptLinesByOrder(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if PurchRcptLine.ReadPermission then begin
          PurchRcptLine.Reset;
          PurchRcptLine.SetCurrentKey("Order No.","Order Line No.");
          PurchRcptLine.SetRange("Order No.",OrderNo);
          PurchRcptLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purch. Rcpt. Line",0,PostedPurchaseReceiptLinesTxt,PurchRcptLine.Count);
        end;
    end;

    local procedure FindPurchReceiptLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if PurchRcptLine.ReadPermission then begin
          PurchRcptLine.Reset;
          PurchRcptLine.SetRange("Blanket Order No.",BlanketOrderNo);
          PurchRcptLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purch. Rcpt. Line",0,PostedPurchaseReceiptLinesTxt,PurchRcptLine.Count);
        end;
    end;

    local procedure FindPurchInvoiceLinesByOrder(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if PurchInvLine.ReadPermission then begin
          PurchInvLine.Reset;
          PurchInvLine.SetRange("Order No.",OrderNo);
          PurchInvLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purch. Inv. Line",0,PostedPurchaseInvoiceLinesTxt,PurchInvLine.Count);
        end;
    end;

    local procedure FindPurchInvoiceLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if PurchInvLine.ReadPermission then begin
          PurchInvLine.Reset;
          PurchInvLine.SetRange("Blanket Order No.",BlanketOrderNo);
          PurchInvLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Purch. Inv. Line",0,PostedPurchaseInvoiceLinesTxt,PurchInvLine.Count);
        end;
    end;

    local procedure FindReturnReceiptLines(ReturnOrderNo: Code[20];ReturnOrderLineNo: Integer)
    begin
        if ReturnReceiptLine.ReadPermission then begin
          ReturnReceiptLine.Reset;
          ReturnReceiptLine.SetRange("Return Order No.",ReturnOrderNo);
          ReturnReceiptLine.SetRange("Return Order Line No.",ReturnOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Return Receipt Line",5,PostedReturnReceiptLinesTxt,ReturnReceiptLine.Count);
        end;
    end;

    local procedure FindReturnShipmentLines(ReturnOrderNo: Code[20];ReturnOrderLineNo: Integer)
    begin
        if ReturnShipmentLine.ReadPermission then begin
          ReturnShipmentLine.Reset;
          ReturnShipmentLine.SetRange("Return Order No.",ReturnOrderNo);
          ReturnShipmentLine.SetRange("Return Order Line No.",ReturnOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Return Shipment Line",5,PostedReturnShipmentLinesTxt,ReturnShipmentLine.Count);
        end;
    end;

    local procedure FindSalesCreditMemoLines(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if SalesCrMemoLine.ReadPermission then begin
          SalesCrMemoLine.Reset;
          SalesCrMemoLine.SetRange("Order No.",OrderNo);
          SalesCrMemoLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Cr.Memo Line",3,PostedSalesCreditMemoLinesTxt,SalesCrMemoLine.Count);
        end;
    end;

    local procedure FindSalesOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if SalesLine.ReadPermission then begin
          SalesLine.Reset;
          SalesLine.SetRange("Document Type",SalesLine."Document Type"::Order);
          SalesLine.SetRange("Document No.",DocNo);
          SalesLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line",1,SalesOrderLinesTxt,SalesLine.Count);
        end;
    end;

    local procedure FindSalesOrderLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if SalesLine.ReadPermission then begin
          SalesLine.Reset;
          SalesLine.SetRange("Document Type",SalesLine."Document Type"::Order);
          SalesLine.SetRange("Blanket Order No.",BlanketOrderNo);
          SalesLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line",1,SalesOrderLinesTxt,SalesLine.Count);
        end;
    end;

    local procedure FindSalesBlanketOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if BlanketSalesOrderLine.ReadPermission then begin
          BlanketSalesOrderLine.Reset;
          BlanketSalesOrderLine.SetRange("Document Type",BlanketSalesOrderLine."Document Type"::"Blanket Order");
          BlanketSalesOrderLine.SetRange("Document No.",DocNo);
          BlanketSalesOrderLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line",4,BlanketSalesOrderLinesTxt,BlanketSalesOrderLine.Count);
        end;
    end;

    local procedure FindSalesReturnOrderLines(DocNo: Code[20];DocLineNo: Integer)
    begin
        if SalesLine.ReadPermission then begin
          SalesLine.Reset;
          SalesLine.SetRange("Document Type",SalesLine."Document Type"::"Return Order");
          SalesLine.SetRange("Document No.",DocNo);
          SalesLine.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line",5,SalesReturnOrderLinesTxt,SalesLine.Count);
        end;
    end;

    local procedure FindSalesOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if SalesLineArchive.ReadPermission then begin
          SalesLineArchive.Reset;
          SalesLineArchive.SetRange("Document Type",SalesLineArchive."Document Type"::Order);
          SalesLineArchive.SetRange("Document No.",DocNo);
          SalesLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line Archive",1,ArchivedSalesOrderLinesTxt,SalesLineArchive.Count);
        end;
    end;

    local procedure FindSalesBlanketOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if BlanketSalesOrderLineArchive.ReadPermission then begin
          BlanketSalesOrderLineArchive.Reset;
          BlanketSalesOrderLineArchive.SetRange("Document Type",BlanketSalesOrderLineArchive."Document Type"::"Blanket Order");
          BlanketSalesOrderLineArchive.SetRange("Document No.",DocNo);
          BlanketSalesOrderLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line Archive",4,ArchivedBlanketSalesOrderLinesTxt,BlanketSalesOrderLineArchive.Count);
        end;
    end;

    local procedure FindSalesReturnOrderLinesArchive(DocNo: Code[20];DocLineNo: Integer)
    begin
        if SalesLineArchive.ReadPermission then begin
          SalesLineArchive.Reset;
          SalesLineArchive.SetRange("Document Type",SalesLineArchive."Document Type"::"Return Order");
          SalesLineArchive.SetRange("Document No.",DocNo);
          SalesLineArchive.SetRange("Line No.",DocLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line Archive",5,ArchivedSalesReturnOrderLinesTxt,SalesLineArchive.Count);
        end;
    end;

    local procedure FindSalesOrderLinesArchiveByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if SalesLineArchive.ReadPermission then begin
          SalesLineArchive.Reset;
          SalesLineArchive.SetRange("Document Type",SalesLineArchive."Document Type"::Order);
          SalesLineArchive.SetRange("Blanket Order No.",BlanketOrderNo);
          SalesLineArchive.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Line Archive",1,ArchivedSalesOrderLinesTxt,SalesLineArchive.Count);
        end;
    end;

    local procedure FindSalesShipmentLinesByOrder(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if SalesShptLine.ReadPermission then begin
          SalesShptLine.Reset;
          SalesShptLine.SetRange("Order No.",OrderNo);
          SalesShptLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Shipment Line",0,PostedSalesShipmentLinesTxt,SalesShptLine.Count);
        end;
    end;

    local procedure FindSalesShipmentLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if SalesShptLine.ReadPermission then begin
          SalesShptLine.Reset;
          SalesShptLine.SetRange("Blanket Order No.",BlanketOrderNo);
          SalesShptLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Shipment Line",0,PostedSalesShipmentLinesTxt,SalesShptLine.Count);
        end;
    end;

    local procedure FindSalesInvoiceLinesByOrder(OrderNo: Code[20];OrderLineNo: Integer)
    begin
        if SalesInvLine.ReadPermission then begin
          SalesInvLine.Reset;
          SalesInvLine.SetRange("Order No.",OrderNo);
          SalesInvLine.SetRange("Order Line No.",OrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Invoice Line",0,PostedSalesInvoiceLinesTxt,SalesInvLine.Count);
        end;
    end;

    local procedure FindSalesInvoiceLinesByBlanketOrder(BlanketOrderNo: Code[20];BlanketOrderLineNo: Integer)
    begin
        if SalesInvLine.ReadPermission then begin
          SalesInvLine.Reset;
          SalesInvLine.SetRange("Blanket Order No.",BlanketOrderNo);
          SalesInvLine.SetRange("Blanket Order Line No.",BlanketOrderLineNo);
          InsertIntoDocEntry(
            DATABASE::"Sales Invoice Line",0,PostedSalesInvoiceLinesTxt,SalesInvLine.Count);
        end;
    end;
}

