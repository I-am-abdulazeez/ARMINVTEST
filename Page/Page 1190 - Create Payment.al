page 1190 "Create Payment"
{
    // version NAVW113.02

    Caption = 'Create Payment';
    PageType = StandardDialog;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(Control6)
            {
                ShowCaption = false;
                field("Batch Name";JournalBatchName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Batch Name';
                    ShowMandatory = true;
                    TableRelation = "Gen. Journal Batch".Name WHERE ("Template Type"=CONST(Payments),
                                                                     Recurring=CONST(false));
                    ToolTip = 'Specifies the name of the journal batch.';

                    trigger OnValidate()
                    begin
                        SetJournalTemplate;
                        SetNextNo;
                    end;
                }
                field("Posting Date";PostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Starting Document No.";NextDocNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Starting Document No.';
                    ShowMandatory = true;
                    ToolTip = 'Specifies a document number for the journal line.';

                    trigger OnValidate()
                    var
                        TextManagement: Codeunit TextManagement;
                    begin
                        if NextDocNo <> '' then
                          TextManagement.EvaluateIncStr(NextDocNo,StartingDocumentNoErr);
                    end;
                }
                field("Bank Account";BalAccountNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account';
                    TableRelation = "Bank Account";
                    ToolTip = 'Specifies the bank account to which a balancing entry for the journal line will be posted.';
                }
                field("Payment Type";BankPaymentType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payment Type';
                    OptionCaption = ' ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT';
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetJournalTemplate;
        SetNextNo;
        PostingDate := WorkDate;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
          if JournalBatchName = '' then
            Error(BatchNumberNotFilledErr);
          if Format(PostingDate) = '' then
            Error(PostingDateNotFilledErr);
          if NextDocNo = '' then
            Error(SpecifyStartingDocNumErr);
        end;
    end;

    var
        PostingDate: Date;
        BalAccountNo: Code[20];
        NextDocNo: Code[20];
        JournalBatchName: Code[10];
        JournalTemplateName: Code[10];
        BankPaymentType: Option " ","Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";
        StartingDocumentNoErr: Label 'Starting Document No.';
        BatchNumberNotFilledErr: Label 'You must fill the Batch Name field.';
        PostingDateNotFilledErr: Label 'You must fill the Posting Date field.';
        SpecifyStartingDocNumErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment='%1 document type, %2 Document No.';

    [Scope('Personalization')]
    procedure GetPostingDate(): Date
    begin
        exit(PostingDate);
    end;

    [Scope('Personalization')]
    procedure GetBankAccount(): Text
    begin
        exit(Format(BalAccountNo));
    end;

    [Scope('Personalization')]
    procedure GetBankPaymentType(): Integer
    begin
        exit(BankPaymentType);
    end;

    [Scope('Personalization')]
    procedure GetBatchNumber(): Code[10]
    begin
        exit(JournalBatchName);
    end;

    [Scope('Personalization')]
    procedure MakeGenJnlLines(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalTemplate: Record "Gen. Journal Template";
        Vendor: Record Vendor;
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        PaymentAmt: Decimal;
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        LastLineNo: Integer;
        SummarizePerVend: Boolean;
    begin
        TempPaymentBuffer.Reset;
        TempPaymentBuffer.DeleteAll;

        if VendorLedgerEntry.Find('-') then
          repeat
            VendorLedgerEntry.CalcFields("Remaining Amount");
            if (VendorLedgerEntry."Applies-to ID" = '') and (VendorLedgerEntry."Remaining Amount" < 0) then begin
              TempPaymentBuffer."Vendor No." := VendorLedgerEntry."Vendor No.";
              TempPaymentBuffer."Currency Code" := VendorLedgerEntry."Currency Code";

              if VendorLedgerEntry."Payment Method Code" = '' then begin
                if Vendor.Get(VendorLedgerEntry."Vendor No.") then
                  TempPaymentBuffer."Payment Method Code" := Vendor."Payment Method Code";
              end else
                TempPaymentBuffer."Payment Method Code" := VendorLedgerEntry."Payment Method Code";
              TempPaymentBuffer."Creditor No." := VendorLedgerEntry."Creditor No.";
              TempPaymentBuffer."Payment Reference" := VendorLedgerEntry."Payment Reference";
              TempPaymentBuffer."Exported to Payment File" := VendorLedgerEntry."Exported to Payment File";
              TempPaymentBuffer."Applies-to Ext. Doc. No." := VendorLedgerEntry."External Document No.";
              OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer,VendorLedgerEntry);
              TempPaymentBuffer."Dimension Entry No." := 0;
              TempPaymentBuffer."Global Dimension 1 Code" := '';
              TempPaymentBuffer."Global Dimension 2 Code" := '';
              TempPaymentBuffer."Dimension Set ID" := 0;
              TempPaymentBuffer."Vendor Ledg. Entry No." := VendorLedgerEntry."Entry No.";
              TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendorLedgerEntry."Document Type";

              if CheckCalcPmtDiscGenJnlVend(VendorLedgerEntry."Remaining Amount",VendorLedgerEntry,0,false) then
                PaymentAmt := -(VendorLedgerEntry."Remaining Amount" - VendorLedgerEntry."Remaining Pmt. Disc. Possible")
              else
                PaymentAmt := -VendorLedgerEntry."Remaining Amount";

              TempPaymentBuffer.Reset;
              TempPaymentBuffer.SetRange("Vendor No.",VendorLedgerEntry."Vendor No.");
              if TempPaymentBuffer.Find('-') then begin
                TempPaymentBuffer.Amount := TempPaymentBuffer.Amount + PaymentAmt;
                SummarizePerVend := true;
                TempPaymentBuffer.Modify;
              end else begin
                TempPaymentBuffer."Document No." := NextDocNo;
                NextDocNo := IncStr(NextDocNo);
                TempPaymentBuffer.Amount := PaymentAmt;
                TempPaymentBuffer.Insert;
              end;
              VendorLedgerEntry."Applies-to ID" := TempPaymentBuffer."Document No.";

              VendorLedgerEntry."Amount to Apply" := VendorLedgerEntry."Remaining Amount";
              CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit",VendorLedgerEntry);
            end;
          until VendorLedgerEntry.Next = 0;

        GenJnlLine.LockTable;
        GenJournalTemplate.Get(JournalTemplateName);
        GenJournalBatch.Get(JournalTemplateName,JournalBatchName);
        GenJnlLine.SetRange("Journal Template Name",JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name",JournalBatchName);
        if GenJnlLine.FindLast then begin
          LastLineNo := GenJnlLine."Line No.";
          GenJnlLine.Init;
        end;

        TempPaymentBuffer.Reset;
        TempPaymentBuffer.SetCurrentKey("Document No.");
        TempPaymentBuffer.SetFilter(
          "Vendor Ledg. Entry Doc. Type",'<>%1&<>%2',TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);
        if TempPaymentBuffer.Find('-') then
          repeat
            with GenJnlLine do begin
              Init;
              Validate("Journal Template Name",JournalTemplateName);
              Validate("Journal Batch Name",JournalBatchName);
              LastLineNo := LastLineNo + 10000;
              "Line No." := LastLineNo;
              "Document Type" := "Document Type"::Payment;
              "Posting No. Series" := GenJournalBatch."Posting No. Series";
              "Document No." := TempPaymentBuffer."Document No.";
              "Account Type" := "Account Type"::Vendor;

              SetHideValidation(true);
              Validate("Posting Date",PostingDate);
              Validate("Account No.",TempPaymentBuffer."Vendor No.");

              Vendor.Get(TempPaymentBuffer."Vendor No.");
              Description := Vendor.Name;

              "Bal. Account Type" := BalAccType::"Bank Account";
              Validate("Bal. Account No.",BalAccountNo);
              Validate("Currency Code",TempPaymentBuffer."Currency Code");

              "Message to Recipient" := GetMessageToRecipient(SummarizePerVend,TempPaymentBuffer);
              "Bank Payment Type" := BankPaymentType;
              "Applies-to ID" := "Document No.";

              "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
              "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
              "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
              "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";

              "Source Code" := GenJournalTemplate."Source Code";
              "Reason Code" := GenJournalBatch."Reason Code";
              Validate(Amount,TempPaymentBuffer.Amount);
              "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
              "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
              Validate("Payment Method Code",TempPaymentBuffer."Payment Method Code");

              "Creditor No." := TempPaymentBuffer."Creditor No.";
              "Payment Reference" := TempPaymentBuffer."Payment Reference";
              "Exported to Payment File" := TempPaymentBuffer."Exported to Payment File";
              "Applies-to Ext. Doc. No." := TempPaymentBuffer."Applies-to Ext. Doc. No.";
              OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine,TempPaymentBuffer);
              UpdateDimensions(GenJnlLine,TempPaymentBuffer);
              Insert;
            end;
          until TempPaymentBuffer.Next = 0;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line";TempPaymentBuffer: Record "Payment Buffer" temporary)
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit DimensionManagement;
        NewDimensionID: Integer;
        DimSetIDArr: array [10] of Integer;
    begin
        with GenJnlLine do begin
          NewDimensionID := "Dimension Set ID";

          DimBuf.Reset;
          DimBuf.DeleteAll;
          DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.",DimBuf);
          if DimBuf.FindSet then
            repeat
              DimVal.Get(DimBuf."Dimension Code",DimBuf."Dimension Value Code");
              TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
              TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
              TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
              TempDimSetEntry.Insert;
            until DimBuf.Next = 0;
          NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
          "Dimension Set ID" := NewDimensionID;

          CreateDim(
            DimMgt.TypeToTableID1("Account Type"),"Account No.",
            DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
            DATABASE::Campaign,"Campaign No.");
          if NewDimensionID <> "Dimension Set ID" then begin
            DimSetIDArr[1] := "Dimension Set ID";
            DimSetIDArr[2] := NewDimensionID;
            "Dimension Set ID" :=
              DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          end;

          DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary;VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line";TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
    end;

    local procedure SetJournalTemplate()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        GenJournalTemplate.Reset;
        GenJournalTemplate.SetRange(Type,GenJournalTemplate.Type::Payments);
        GenJournalTemplate.SetRange(Recurring,false);
        if GenJournalTemplate.FindFirst then
          JournalTemplateName := GenJournalTemplate.Name;
    end;

    local procedure SetNextNo()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if JournalBatchName <> '' then begin
          GenJournalBatch.Get(JournalTemplateName,JournalBatchName);
          if GenJournalBatch."No. Series" = '' then
            NextDocNo := ''
          else begin
            NextDocNo := NoSeriesMgt.GetNextNo(GenJournalBatch."No. Series",PostingDate,false);
            Clear(NoSeriesMgt);
          end;
        end;
    end;

    [Scope('Personalization')]
    procedure CheckCalcPmtDiscGenJnlVend(RemainingAmt: Decimal;OldVendLedgEntry2: Record "Vendor Ledger Entry";ApplnRoundingPrecision: Decimal;CheckAmount: Boolean): Boolean
    var
        NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        PaymentToleranceManagement: Codeunit "Payment Tolerance Management";
        DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
    begin
        NewCVLedgEntryBuf."Document Type" := DocumentType::Payment;
        NewCVLedgEntryBuf."Posting Date" := PostingDate;
        NewCVLedgEntryBuf."Remaining Amount" := RemainingAmt;
        OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
        exit(
          PaymentToleranceManagement.CheckCalcPmtDisc(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,false,CheckAmount));
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean;TempPaymentBuffer: Record "Payment Buffer" temporary): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompanyInformation: Record "Company Information";
    begin
        if SummarizePerVend then begin
          CompanyInformation.Get;
          exit(CompanyInformation.Name);
        end;

        VendorLedgerEntry.Get(TempPaymentBuffer."Vendor Ledg. Entry No.");
        if VendorLedgerEntry."Message to Recipient" <> '' then
          exit(VendorLedgerEntry."Message to Recipient");

        exit(
          StrSubstNo(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;
}

