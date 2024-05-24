table 50095 "Historical Loans"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Client No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;

            trigger OnValidate()
            begin
                if Client.Get("Client No.") then
                  "Client Name" := Client.Name;

                "Investment Balance" := LoanMgt.GetInvestmentBalance("Client No.");
                if ("Loan Product Type"= '03') then
                  "Investment Balance" := LoanMgt.GetInvestmentBalanceEmployee("Client No.");

                LoanMgtSetup.Get;
                LoanMgtSetup.TestField("Min Investment Bal for Loan");
                if "Investment Balance" < LoanMgtSetup."Min Investment Bal for Loan" then
                  Error(Text001);

                ClientLoan.Reset;
                ClientLoan.SetFilter("Loan No.",'<>%1',"Loan No.");
                ClientLoan.SetRange ("Client No.","Client No.");
                if ClientLoan.FindFirst = false  then exit;
                if ("Loan Product Type"= '01') or ("Loan Product Type"= '02') then
                if (ClientLoan."Loan Product Type"= '01') or (ClientLoan."Loan Product Type" = '02') then begin
                if ("Payment Completed" = false ) or( Status <> Status::Rejected) then
                  Error ('You have an outstanding loan at the moment');
                end;

                if ("Loan Product Type"= '03') then
                if (ClientLoan."Loan Product Type"= '03') then begin
                if ("Payment Completed" = false) or( Status <> Status::Rejected) then
                  Error ('Same loan processed earlier');
                end;
            end;
        }
        field(3;"Client Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Loan Product Type";Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                Loan.Reset;
                Loan.SetRange(Status,Loan.Status::Active);
                if PAGE.RunModal(PAGE::"Loan Product Types",Loan) = ACTION::LookupOK then
                  Validate("Loan Product Type",Loan.Code);
            end;

            trigger OnValidate()
            begin
                if Loan.Get("Loan Product Type") then begin
                  "Loan Product Name" := Loan."Product Type";
                "Repayment Method"   := Loan."Repayment Type";
                "Principal Repayment Method" := Loan."Principal Repayment Method";
                "Interest Rate" := Loan."Interest Rate";
                //"Repayment Start Date" := CALCDATE('CM',CALCDATE(Loan."Grace Period before Repayment","Application Date"));
                if "Application Date" <> 0D then
                "Repayment Start Date" := CalcDate(Loan."Grace Period before Repayment","Application Date")
                else
                "Repayment Start Date" := CalcDate(Loan."Grace Period before Repayment",Today);

                if Loan."Principal Repayment Method" = Loan."Principal Repayment Method"::Annuity then
                  "Principal Repayment Frequency" := "Principal Repayment Frequency"::Monthly
                else if Loan."Principal Repayment Method" = Loan."Principal Repayment Method"::Bullet then
                  "Principal Repayment Frequency" := "Principal Repayment Frequency"::Annually
                else if Loan."Principal Repayment Method" = Loan."Principal Repayment Method"::None then begin
                  "Principal Repayment Frequency" := "Principal Repayment Frequency"::None;
                  "Interest Repayment Frequency" := "Interest Repayment Frequency"::None;
                  "No. of Interest Repayments" := 0;
                  "No. of Principal Repayments" := 0;
                end;

                if Loan."Repayment Type" = Loan."Repayment Type"::"Pre-Retirement" then begin
                  Loan.TestField("Default Loan (% of Inv. Bal)");
                  if Loan."Default Loan (% of Inv. Bal)" <> 0 then
                    "Requested Amount" := Round((Loan."Default Loan (% of Inv. Bal)"/100)*"Investment Balance",0.01);
                end;
                end;
            end;
        }
        field(5;"Loan Product Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Repayment Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Amortized,Reducing Balance,Straight Line,Constants,Pre-Retirement';
            OptionMembers = Amortized,"Reducing Balance","Straight Line",Constants,"Pre-Retirement";
        }
        field(7;"Principal Repayment Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Annuity,Bullet,None';
            OptionMembers = Annuity,Bullet,"None";
        }
        field(8;"Principal Repayment Frequency";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Monthly,Quarterly,Semi-Annually,Annually,None';
            OptionMembers = Monthly,Quarterly,"Semi-Annually",Annually,"None";

            trigger OnValidate()
            begin
                if "Principal Repayment Frequency" = "Principal Repayment Frequency"::None then begin
                  if "Repayment Method" <> "Repayment Method"::"Pre-Retirement" then
                    Error(Text000);
                end;
                Validate("Loan Period (in Months)");
            end;
        }
        field(9;"Interest Repayment Frequency";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Monthly,Quarterly,Semi-Annually,Annually,None';
            OptionMembers = Monthly,Quarterly,"Semi-Annually",Annually,"None";

            trigger OnValidate()
            begin
                if "Interest Repayment Frequency" = "Interest Repayment Frequency"::None then begin
                  if "Repayment Method" <> "Repayment Method"::"Pre-Retirement" then
                    Error(Text000);
                end;
                Validate("Loan Period (in Months)");
            end;
        }
        field(10;"Loan Period (in Months)";Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Loan Period (in Months)" <> 0 then begin
                  //Principal Repayment
                  if "Principal Repayment Frequency" = "Principal Repayment Frequency"::Monthly then
                   "No. of Principal Repayments" := "Loan Period (in Months)"
                  else if "Principal Repayment Frequency" = "Principal Repayment Frequency"::Quarterly then
                  "No. of Principal Repayments" := Round("Loan Period (in Months)"/3,1)
                  else if "Principal Repayment Frequency" = "Principal Repayment Frequency"::"Semi-Annually" then
                  "No. of Principal Repayments" := Round("Loan Period (in Months)"/6,1)
                  else if "Principal Repayment Frequency" = "Principal Repayment Frequency"::Annually then
                  "No. of Principal Repayments" := Round("Loan Period (in Months)"/12,1);
                  //Interest Repayment
                  if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
                   "No. of Interest Repayments" := "Loan Period (in Months)"
                  else if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
                  "No. of Interest Repayments" := Round("Loan Period (in Months)"/3,1)
                  else if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
                  "No. of Interest Repayments" := Round("Loan Period (in Months)"/6,1)
                  else if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
                  "No. of Interest Repayments" := Round("Loan Period (in Months)"/12,1);
                end;
            end;
        }
        field(11;"No. of Principal Repayments";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"No. of Interest Repayments";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Interest Rate";Decimal)
        {
            Caption = 'Interest Rate (%)';
            DataClassification = ToBeClassified;
        }
        field(14;"Freeze Interest Calculation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Application Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Loan Product Type" <> '' then
                  Validate("Loan Product Type");
            end;
        }
        field(16;"Requested Amount";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Investment Balance" := LoanMgt.GetInvestmentBalance("Client No.");
                LoanMgtSetup.Get;
                LoanMgtSetup.TestField("Min Investment Bal for Loan");
                if "Investment Balance" < LoanMgtSetup."Min Investment Bal for Loan" then
                  Error(Text001);
                if Loan.Get("Loan Product Type") then begin
                  Loan.TestField("Investment Bal. Max Percentage");
                  if Loan."Investment Bal. Max Percentage" <> 0 then
                    if "Requested Amount" > Round((Loan."Investment Bal. Max Percentage"/100)*"Investment Balance",0.01) then begin
                      Error(Text002,Loan."Investment Bal. Max Percentage");
                      end;
                end;
                "Approved Amount" := "Requested Amount";
            end;
        }
        field(17;"Investment Balance";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18;Principal;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19;Interest;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Repayment Start Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Rejected,Approved,Partially Repaid,Fully Repaid,Non-Performing,On Holiday';
            OptionMembers = New,"Pending Approval",Rejected,Approved,"Partially Repaid","Fully Repaid","Non-Performing","On Holiday";
        }
        field(22;"Existing Loan Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Approved Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Interest Frozen By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Interest Frozen Date";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(26;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(27;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Created DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Loan Disbursement Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30;"Principal Repayment Month";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(31;Disbursed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32;"Repayment End Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(33;"Payment Completed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34;"No. of Repaid Periods";Integer)
        {
            CalcFormula = Count("Loan Repayment Schedule" WHERE (Settled=CONST(true),
                                                                 "Loan No."=FIELD("Loan No."),
                                                                 "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(35;"Total Interest Repaid";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Interest Settlement" WHERE (Settled=CONST(true),
                                                                                     "Loan No."=FIELD("Loan No."),
                                                                                     "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(36;"Total Principal Repaid";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Principal Settlement" WHERE (Settled=CONST(true),
                                                                                      "Loan No."=FIELD("Loan No."),
                                                                                      "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(37;"Total Amount Repaid";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Total Settlement" WHERE (Settled=CONST(true),
                                                                                  "Loan No."=FIELD("Loan No."),
                                                                                  "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(38;"No. of Outstanding Periods";Integer)
        {
            CalcFormula = Count("Loan Repayment Schedule" WHERE (Settled=CONST(false),
                                                                 "Loan No."=FIELD("Loan No."),
                                                                 "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39;"Outstanding Interest";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Interest Due" WHERE (Settled=CONST(false),
                                                                              "Loan No."=FIELD("Loan No."),
                                                                              "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(40;"Outstanding Principal";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Principal Due" WHERE (Settled=CONST(false),
                                                                               "Loan No."=FIELD("Loan No."),
                                                                               "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(41;"Total Amount Outstanding";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Total Due" WHERE (Settled=CONST(false),
                                                                           "Loan No."=FIELD("Loan No."),
                                                                           "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(42;"Effective Loan Amount";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Total Due" WHERE ("Loan No."=FIELD("Loan No."),
                                                                           "Repayment Date"=FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(43;"Account No";Code[40])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(44;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(46;"Staff ID";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ClientAccount.Reset;
                ClientAccount.SetCurrentKey("Staff ID");
                ClientAccount.SetFilter("Staff ID",'<>%1','');
                if PAGE.RunModal(PAGE::"Client Accounts",ClientAccount) = ACTION::LookupOK then begin
                  Validate("Account No",ClientAccount."Account No");
                  Validate("Staff ID",ClientAccount."Staff ID");
                end;
            end;

            trigger OnValidate()
            begin
                if "Account No" = '' then begin
                  ClientAccount.Reset;
                  ClientAccount.SetCurrentKey("Staff ID");
                  ClientAccount.SetRange("Staff ID","Staff ID");
                  ClientAccount.SetRange("Fund No","Fund Code");
                  if ClientAccount.FindSet then begin repeat
                    Validate("Account No",ClientAccount."Account No");
                  until ClientAccount.Next = 0;
                  end;
                end;
            end;
        }
        field(47;"Bank Code";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;

            trigger OnValidate()
            begin
                if Banks.Get("Bank Code") then
                  "Bank Name" := Banks.Name;
            end;
        }
        field(48;"Bank Branch";Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                Branches.Reset;
                Branches.SetRange("Bank Code","Bank Code");
                if PAGE.RunModal(PAGE::"Bank Branches",Branches) = ACTION::LookupOK then
                  "Bank Branch" := Branches."Bank Code";
            end;
        }
        field(49;"Bank Account Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Bank Account Number";Code[30])
        {
            Caption = 'Bank Account Number';
            DataClassification = ToBeClassified;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(51;"Loan Years";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52;"Annual Installment";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53;"Monthly Installment";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(54;"Bank Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(55;"Loan Source";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Fresh Loan,Variation';
            OptionMembers = "Fresh Loan",Variation;
        }
        field(56;"Source Loan";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(57;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Loan No.")
        {
        }
        key(Key2;"Client No.","Staff ID","Account No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Disbursed = true then
        Error ('You cannot delete this application as it has been disbursed to client');
    end;

    trigger OnInsert()
    begin
        if "Loan No." = '' then begin
          LoanApp.Reset;
          if LoanApp.FindLast then
          begin
          Evaluate(counters, ConvertStr(LoanApp."Loan No.",'LN-','000'))
          end;
          counters:= counters+1;
          reccode:= (PadStr('', 16 - StrLen(Format(counters)), '0') + Format(counters));
          "Loan No.":= 'LN-' + reccode;
        end;

        "Application Date":=Today;
        "Created By":=UserId;
        "Created DateTime":=CurrentDateTime;
    end;

    trigger OnModify()
    begin
        if xRec.Disbursed = true then
        Error ('You cannot modify this application as it has been disbursed to client');
    end;

    var
        LoanMgtSetup: Record "Loan Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Client: Record Client;
        Loan: Record "Loan Product";
        Text000: Label 'Repayment Frequency cannot be None because this is not a Pre-Retirement Advance!';
        LoanMgt: Codeunit "Loan Management";
        Text001: Label 'This Client''s Investment Balance cannot access a loan facility';
        Text002: Label 'The requested amount cannot be more than %1 percent of the Investment Balance.';
        ClientLoan: Record "Loan Application";
        ClientAccount: Record "Client Account";
        LoanApp: Record "Loan Application";
        counters: Integer;
        reccode: Code[20];
        Banks: Record Bank;
        Branches: Record "Bank Branches";

    local procedure Validateaccount()
    begin
        if ClientAccount.Get("Account No") then begin
        "Client No.":=ClientAccount."Client ID";
        /*IF ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Subscription") THEN
          ERROR('There is are a restriction on this account that Restricts Subscription');*/
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        "Client Name":=ClientAccount."Client Name";
        "Staff ID" := ClientAccount."Staff ID";
        end else begin
        "Client No.":='';
        "Fund Code":='';
        "Fund Sub Account":='';
        "Client Name":='';
        "Staff ID" := '';
        end;
        Validate("Client No.");

    end;
}

