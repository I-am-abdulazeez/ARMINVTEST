codeunit 11 "Gen. Jnl.-Check Line"
{
    // version NAVW113.03

    Permissions = TableData "General Posting Setup"=rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        Text000: Label 'can only be a closing date for G/L entries';
        Text001: Label 'is not within your range of allowed posting dates';
        Text002: Label '%1 or %2 must be G/L Account or Bank Account.';
        Text003: Label 'must have the same sign as %1';
        Text004: Label 'You must not specify %1 when %2 is %3.';
        Text005: Label '%1 + %2 must be %3.';
        Text006: Label '%1 + %2 must be -%3.';
        Text007: Label 'must be positive';
        Text008: Label 'must be negative';
        Text009: Label 'must have a different sign than %1';
        Text010: Label '%1 %2 and %3 %4 is not allowed.';
        Text011: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text012: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        CostAccSetup: Record "Cost Accounting Setup";
        DimMgt: Codeunit DimensionManagement;
        CostAccMgt: Codeunit "Cost Account Mgt";
        GenJnlTemplateFound: Boolean;
        OverrideDimErr: Boolean;
        SalesDocAlreadyExistsErr: Label 'Sales %1 %2 already exists.', Comment='%1 = Document Type; %2 = Document No.';
        PurchDocAlreadyExistsErr: Label 'Purchase %1 %2 already exists.', Comment='%1 = Document Type; %2 = Document No.';
        IsBatchMode: Boolean;
        EmployeeBalancingDocTypeErr: Label 'must be empty or set to Payment when Balancing Account Type field is set to Employee';
        EmployeeAccountDocTypeErr: Label 'must be empty or set to Payment when Account Type field is set to Employee';

    [Scope('Personalization')]
    procedure RunCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        ICGLAcount: Record "IC G/L Account";
    begin
        OnBeforeRunCheck(GenJnlLine);

        GLSetup.Get;
        with GenJnlLine do begin
          if EmptyLine then
            exit;

          if not GenJnlTemplateFound then begin
            if GenJnlTemplate.Get("Journal Template Name") then;
            GenJnlTemplateFound := true;
          end;

          CheckDates(GenJnlLine);
          ValidateSalesPersonPurchaserCode(GenJnlLine);

          TestField("Document No.");

          if ("Account Type" in
              ["Account Type"::Customer,
               "Account Type"::Vendor,
               "Account Type"::"Fixed Asset",
               "Account Type"::"IC Partner"]) and
             ("Bal. Account Type" in
              ["Bal. Account Type"::Customer,
               "Bal. Account Type"::Vendor,
               "Bal. Account Type"::"Fixed Asset",
               "Bal. Account Type"::"IC Partner"])
          then
            Error(
              Text002,
              FieldCaption("Account Type"),FieldCaption("Bal. Account Type"));

          if "Bal. Account No." = '' then
            TestField("Account No.");

          if NeedCheckZeroAmount and not (IsRecurring and IsBatchMode) then
            TestField(Amount);

          if ((Amount < 0) xor ("Amount (LCY)" < 0)) and (Amount <> 0) and ("Amount (LCY)" <> 0) then
            FieldError("Amount (LCY)",StrSubstNo(Text003,FieldCaption(Amount)));

          if ("Account Type" = "Account Type"::"G/L Account") and
             ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
          then
            TestField("Applies-to Doc. No.",'');

          if ("Recurring Method" in
              ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) and
             ("Currency Code" <> '')
          then
            Error(
              Text004,
              FieldCaption("Currency Code"),FieldCaption("Recurring Method"),"Recurring Method");

          if "Account No." <> '' then
            CheckAccountNo(GenJnlLine);

          if "Bal. Account No." <> '' then
            CheckBalAccountNo(GenJnlLine);

          if "IC Partner G/L Acc. No." <> '' then
            if ICGLAcount.Get("IC Partner G/L Acc. No.") then
              ICGLAcount.TestField(Blocked,false);

          if (("Account Type" = "Account Type"::"G/L Account") and
              ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or
             (("Document Type" <> "Document Type"::Invoice) and
              (not
               (("Document Type" = "Document Type"::"Credit Memo") and
                CalcPmtDiscOnCrMemos("Payment Terms Code"))))
          then begin
            TestField("Pmt. Discount Date",0D);
            TestField("Payment Discount %",0);
          end;

          if (("Account Type" = "Account Type"::"G/L Account") and
              ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or
             ("Applies-to Doc. No." <> '')
          then
            TestField("Applies-to ID",'');

          if ("Account Type" <> "Account Type"::"Bank Account") and
             ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
          then
            TestField("Bank Payment Type","Bank Payment Type"::" ");

          if ("Account Type" = "Account Type"::"Fixed Asset") or
             ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
          then
            CODEUNIT.Run(CODEUNIT::"FA Jnl.-Check Line",GenJnlLine);

          if ("Account Type" <> "Account Type"::"Fixed Asset") and
             ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
          then begin
            TestField("Depreciation Book Code",'');
            TestField("FA Posting Type",0);
          end;

          if not OverrideDimErr then
            CheckDimensions(GenJnlLine);
        end;

        if CostAccSetup.Get then
          CostAccMgt.CheckValidCCAndCOInGLEntry(GenJnlLine."Dimension Set ID");

        OnAfterCheckGenJnlLine(GenJnlLine);
    end;

    local procedure CalcPmtDiscOnCrMemos(PaymentTermsCode: Code[10]): Boolean
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PaymentTermsCode <> '' then begin
          PaymentTerms.Get(PaymentTermsCode);
          exit(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
        end;
    end;

    [Scope('Personalization')]
    procedure DateNotAllowed(PostingDate: Date) DateIsNotAllowed: Boolean
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        DateIsNotAllowed := not UserSetupManagement.IsPostingDateValid(PostingDate);
        OnAfterDateNoAllowed(PostingDate,DateIsNotAllowed);
        exit(DateIsNotAllowed);
    end;

    local procedure ErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    var
        RaiseError: Boolean;
    begin
        RaiseError := GenJnlLine.Amount > 0;
        OnBeforeErrorIfPositiveAmt(GenJnlLine,RaiseError);
        if RaiseError then
          GenJnlLine.FieldError(Amount,Text008);
    end;

    local procedure ErrorIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    var
        RaiseError: Boolean;
    begin
        RaiseError := GenJnlLine.Amount < 0;
        OnBeforeErrorIfNegativeAmt(GenJnlLine,RaiseError);
        if RaiseError then
          GenJnlLine.FieldError(Amount,Text007);
    end;

    [Scope('Personalization')]
    procedure SetOverDimErr()
    begin
        OverrideDimErr := true;
    end;

    local procedure CheckDates(GenJnlLine: Record "Gen. Journal Line")
    var
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
        DateCheckDone: Boolean;
    begin
        with GenJnlLine do begin
          TestField("Posting Date");
          if "Posting Date" <> NormalDate("Posting Date") then begin
            if ("Account Type" <> "Account Type"::"G/L Account") or
               ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
            then
              FieldError("Posting Date",Text000);
            AccountingPeriodMgt.CheckPostingDateInFiscalYear("Posting Date");
          end;

          OnBeforeDateNotAllowed(GenJnlLine,DateCheckDone);
          if not DateCheckDone then
            if DateNotAllowed("Posting Date") then
              FieldError("Posting Date",Text001);

          if "Document Date" <> 0D then
            if ("Document Date" <> NormalDate("Document Date")) and
               (("Account Type" <> "Account Type"::"G/L Account") or
                ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
            then
              FieldError("Document Date",Text000);
        end;
    end;

    local procedure CheckAccountNo(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
        CheckDone: Boolean;
    begin
        OnBeforeCheckAccountNo(GenJnlLine,CheckDone);
        if CheckDone then
          exit;

        with GenJnlLine do
          case "Account Type" of
            "Account Type"::"G/L Account":
              begin
                if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                   ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                then
                  TestField("Gen. Posting Type");
                if ("Gen. Posting Type" <> "Gen. Posting Type"::" ") and
                   ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                then begin
                  if "VAT Amount" + "VAT Base Amount" <> Amount then
                    Error(
                      Text005,FieldCaption("VAT Amount"),FieldCaption("VAT Base Amount"),
                      FieldCaption(Amount));
                  if "Currency Code" <> '' then
                    if "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" then
                      Error(
                        Text005,FieldCaption("VAT Amount (LCY)"),
                        FieldCaption("VAT Base Amount (LCY)"),FieldCaption("Amount (LCY)"));
                end;
              end;
            "Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee:
              begin
                TestField("Gen. Posting Type",0);
                TestField("Gen. Bus. Posting Group",'');
                TestField("Gen. Prod. Posting Group",'');
                TestField("VAT Bus. Posting Group",'');
                TestField("VAT Prod. Posting Group",'');

                if (("Account Type" = "Account Type"::Customer) and
                    ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase)) or
                   (("Account Type" = "Account Type"::Vendor) and
                    ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Sale))
                then
                  Error(
                    Text010,
                    FieldCaption("Account Type"),"Account Type",
                    FieldCaption("Bal. Gen. Posting Type"),"Bal. Gen. Posting Type");

                CheckDocType(GenJnlLine);

                if not "System-Created Entry" and
                   (((Amount < 0) xor ("Sales/Purch. (LCY)" < 0)) and (Amount <> 0) and ("Sales/Purch. (LCY)" <> 0))
                then
                  FieldError("Sales/Purch. (LCY)",StrSubstNo(Text003,FieldCaption(Amount)));
                TestField("Job No.",'');

                CheckICPartner("Account Type","Account No.","Document Type");
              end;
            "Account Type"::"Bank Account":
              begin
                TestField("Gen. Posting Type",0);
                TestField("Gen. Bus. Posting Group",'');
                TestField("Gen. Prod. Posting Group",'');
                TestField("VAT Bus. Posting Group",'');
                TestField("VAT Prod. Posting Group",'');
                TestField("Job No.",'');
                if (Amount < 0) and ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") then
                  TestField("Check Printed",true);
                if ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") or
                   ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
                then begin
                  TestField("Exported to Payment File",true);
                  TestField("Check Transmitted",true);
                end;
              end;
            "Account Type"::"IC Partner":
              begin
                ICPartner.Get("Account No.");
                ICPartner.CheckICPartner;
                if "Journal Template Name" <> '' then
                  if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                    FieldError("Account Type");
              end;
          end;
    end;

    local procedure CheckBalAccountNo(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
        CheckDone: Boolean;
    begin
        OnBeforeCheckBalAccountNo(GenJnlLine,CheckDone);
        if CheckDone then
          exit;

        with GenJnlLine do
          case "Bal. Account Type" of
            "Bal. Account Type"::"G/L Account":
              begin
                if ("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or
                   ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')
                then
                  TestField("Bal. Gen. Posting Type");
                if ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") and
                   ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
                then begin
                  if "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount then
                    Error(
                      Text006,FieldCaption("Bal. VAT Amount"),FieldCaption("Bal. VAT Base Amount"),
                      FieldCaption(Amount));
                  if "Currency Code" <> '' then
                    if "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" then
                      Error(
                        Text006,FieldCaption("Bal. VAT Amount (LCY)"),
                        FieldCaption("Bal. VAT Base Amount (LCY)"),FieldCaption("Amount (LCY)"));
                end;
              end;
            "Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::Employee:
              begin
                TestField("Bal. Gen. Posting Type",0);
                TestField("Bal. Gen. Bus. Posting Group",'');
                TestField("Bal. Gen. Prod. Posting Group",'');
                TestField("Bal. VAT Bus. Posting Group",'');
                TestField("Bal. VAT Prod. Posting Group",'');

                if (("Bal. Account Type" = "Bal. Account Type"::Customer) and
                    ("Gen. Posting Type" = "Gen. Posting Type"::Purchase)) or
                   (("Bal. Account Type" = "Bal. Account Type"::Vendor) and
                    ("Gen. Posting Type" = "Gen. Posting Type"::Sale))
                then
                  Error(
                    Text010,
                    FieldCaption("Bal. Account Type"),"Bal. Account Type",
                    FieldCaption("Gen. Posting Type"),"Gen. Posting Type");

                CheckBalDocType(GenJnlLine);

                if ((Amount > 0) xor ("Sales/Purch. (LCY)" < 0)) and (Amount <> 0) and ("Sales/Purch. (LCY)" <> 0) then
                  FieldError("Sales/Purch. (LCY)",StrSubstNo(Text009,FieldCaption(Amount)));
                TestField("Job No.",'');

                CheckICPartner("Bal. Account Type","Bal. Account No.","Document Type");
              end;
            "Bal. Account Type"::"Bank Account":
              begin
                TestField("Bal. Gen. Posting Type",0);
                TestField("Bal. Gen. Bus. Posting Group",'');
                TestField("Bal. Gen. Prod. Posting Group",'');
                TestField("Bal. VAT Bus. Posting Group",'');
                TestField("Bal. VAT Prod. Posting Group",'');
                if (Amount > 0) and ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") then
                  TestField("Check Printed",true);
                if ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") or
                   ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
                then begin
                  TestField("Exported to Payment File",true);
                  TestField("Check Transmitted",true);
                end;
              end;
            "Bal. Account Type"::"IC Partner":
              begin
                ICPartner.Get("Bal. Account No.");
                ICPartner.CheckICPartner;
                if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                  FieldError("Bal. Account Type");
              end;
          end;
    end;

    [Scope('Personalization')]
    procedure CheckSalesDocNoIsNotUsed(DocType: Option;DocNo: Code[20])
    var
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckSalesDocNoIsNotUsed(DocType,DocNo,IsHandled);
        if IsHandled then
          exit;

        OldCustLedgEntry.SetRange("Document No.",DocNo);
        OldCustLedgEntry.SetRange("Document Type",DocType);
        if OldCustLedgEntry.FindFirst then
          Error(SalesDocAlreadyExistsErr,OldCustLedgEntry."Document Type",DocNo);
    end;

    [Scope('Personalization')]
    procedure CheckPurchDocNoIsNotUsed(DocType: Option;DocNo: Code[20])
    var
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckPurchDocNoIsNotUsed(DocType,DocNo,IsHandled);
        if IsHandled then
          exit;

        OldVendLedgEntry.SetRange("Document No.",DocNo);
        OldVendLedgEntry.SetRange("Document Type",DocType);
        if OldVendLedgEntry.FindFirst then
          Error(PurchDocAlreadyExistsErr,OldVendLedgEntry."Document Type",DocNo);
    end;

    local procedure CheckDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckDocType(GenJnlLine,IsHandled);
        if IsHandled then
          exit;

        with GenJnlLine do
          if "Document Type" <> 0 then begin
            if ("Account Type" = "Account Type"::Employee) and not
               ("Document Type" in ["Document Type"::Payment,"Document Type"::" "])
            then
              FieldError("Document Type",EmployeeAccountDocTypeErr);

            IsPayment := "Document Type" in ["Document Type"::Payment,"Document Type"::"Credit Memo"];
            if IsPayment xor (("Account Type" = "Account Type"::Customer) xor IsVendorPaymentToCrMemo(GenJnlLine)) then
              ErrorIfNegativeAmt(GenJnlLine)
            else
              ErrorIfPositiveAmt(GenJnlLine);
          end;
    end;

    local procedure CheckBalDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckBalDocType(GenJnlLine,IsHandled);
        if IsHandled then
          exit;

        with GenJnlLine do
          if "Document Type" <> 0 then begin
            if ("Bal. Account Type" = "Bal. Account Type"::Employee) and not
               ("Document Type" in ["Document Type"::Payment,"Document Type"::" "])
            then
              FieldError("Document Type",EmployeeBalancingDocTypeErr);

            IsPayment := "Document Type" in ["Document Type"::Payment,"Document Type"::"Credit Memo"];
            if IsPayment = ("Bal. Account Type" = "Bal. Account Type"::Customer) then
              ErrorIfNegativeAmt(GenJnlLine)
            else
              ErrorIfPositiveAmt(GenJnlLine);
          end;
    end;

    local procedure CheckICPartner(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;AccountNo: Code[20];DocumentType: Option)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ICPartner: Record "IC Partner";
        Employee: Record Employee;
        CheckDone: Boolean;
    begin
        OnBeforeCheckICPartner(AccountType,AccountNo,DocumentType,CheckDone);
        if CheckDone then
          exit;

        case AccountType of
          AccountType::Customer:
            if Customer.Get(AccountNo) then begin
              Customer.CheckBlockedCustOnJnls(Customer,DocumentType,true);
              if (Customer."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                 ICPartner.Get(Customer."IC Partner Code")
              then
                ICPartner.CheckICPartnerIndirect(Format(AccountType),AccountNo);
            end;
          AccountType::Vendor:
            if Vendor.Get(AccountNo) then begin
              Vendor.CheckBlockedVendOnJnls(Vendor,DocumentType,true);
              if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                 ICPartner.Get(Vendor."IC Partner Code")
              then
                ICPartner.CheckICPartnerIndirect(Format(AccountType),AccountNo);
            end;
          AccountType::Employee:
            if Employee.Get(AccountNo) then
              Employee.CheckBlockedEmployeeOnJnls(true)
        end;
    end;

    local procedure CheckDimensions(GenJnlLine: Record "Gen. Journal Line")
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        CheckDone: Boolean;
    begin
        OnBeforeCheckDimensions(GenJnlLine,CheckDone);
        if CheckDone then
          exit;

        with GenJnlLine do begin
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            ThrowGenJnlLineError(GenJnlLine,Text011,DimMgt.GetDimCombErr);

          TableID[1] := DimMgt.TypeToTableID1("Account Type");
          No[1] := "Account No.";
          TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type");
          No[2] := "Bal. Account No.";
          TableID[3] := DATABASE::Job;
          No[3] := "Job No.";
          TableID[4] := DATABASE::"Salesperson/Purchaser";
          No[4] := "Salespers./Purch. Code";
          TableID[5] := DATABASE::Campaign;
          No[5] := "Campaign No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            ThrowGenJnlLineError(GenJnlLine,Text012,DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure IsVendorPaymentToCrMemo(GenJournalLine: Record "Gen. Journal Line"): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        with GenJournalLine do begin
          if ("Account Type" = "Account Type"::Vendor) and
             ("Document Type" = "Document Type"::Payment) and
             ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") and
             ("Applies-to Doc. No." <> '')
          then begin
            GenJournalTemplate.Get("Journal Template Name");
            exit(GenJournalTemplate.Type = GenJournalTemplate.Type::Payments);
          end;
          exit(false);
        end;
    end;

    local procedure ThrowGenJnlLineError(GenJournalLine: Record "Gen. Journal Line";ErrorTemplate: Text;ErrorText: Text)
    begin
        with GenJournalLine do
          if "Line No." <> 0 then
            Error(
              ErrorTemplate,
              TableCaption,"Journal Template Name","Journal Batch Name","Line No.",
              ErrorText);
        Error(ErrorText);
    end;

    [Scope('Personalization')]
    procedure SetBatchMode(NewBatchMode: Boolean)
    begin
        IsBatchMode := NewBatchMode;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDateNoAllowed(PostingDate: Date;var DateIsNotAllowed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDateNotAllowed(GenJnlLine: Record "Gen. Journal Line";var DateCheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckAccountNo(var GenJnlLine: Record "Gen. Journal Line";var CheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckBalAccountNo(var GenJnlLine: Record "Gen. Journal Line";var CheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDimensions(var GenJnlLine: Record "Gen. Journal Line";var CheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDocType(GenJournalLine: Record "Gen. Journal Line";var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckBalDocType(GenJournalLine: Record "Gen. Journal Line";var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckICPartner(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20];DocumentType: Option;var CheckDone: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckSalesDocNoIsNotUsed(DocType: Option;DocNo: Code[20];var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckPurchDocNoIsNotUsed(DocType: Option;DocNo: Code[20];var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeErrorIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line";var RaiseError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line";var RaiseError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunCheck(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}
