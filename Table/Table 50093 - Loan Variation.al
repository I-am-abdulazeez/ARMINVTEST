table 50093 "Loan Variation"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Staff ID";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ClientAccount.Reset;
                ClientAccount.SetCurrentKey("Staff ID");
                ClientAccount.SetFilter("Staff ID",'<>%1','');
                if PAGE.RunModal(PAGE::"Client Accounts",ClientAccount) = ACTION::LookupOK then begin
                  Validate("Account No.",ClientAccount."Account No");
                  Validate("Staff ID",ClientAccount."Staff ID");
                end;
            end;

            trigger OnValidate()
            begin
                if "Account No." = '' then begin
                  ClientAccount.Reset;
                  ClientAccount.SetCurrentKey("Staff ID");
                  ClientAccount.SetRange("Staff ID","Staff ID");
                  //ClientAccount.SETRANGE("Fund No","Fund Code");
                  if ClientAccount.FindSet then begin repeat
                    ClientAccount.CalcFields("No of Units");
                    if ClientAccount."No of Units" <> 0 then
                    Validate("Account No.",ClientAccount."Account No");
                  until ClientAccount.Next = 0;
                  end;
                end;
            end;
        }
        field(5;"Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount;
            end;
        }
        field(6;"Client Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Old Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Loan Application" WHERE ("Client No."=FIELD("Client No."),
                                                      Disbursed=CONST(true),
                                                      Status=FILTER(<>"Fully Repaid"));

            trigger OnValidate()
            begin
                if Loans.Get("Old Loan No.") then begin
                  Loans.CalcFields("Outstanding Principal","Outstanding Interest","No. of Outstanding Periods");
                  "Current Outstanding Principal" := Loans."Outstanding Principal";
                  "Current Outstanding Interest" := Loans."Outstanding Interest";
                  "Current Outstanding Tenure" := Loans."No. of Outstanding Periods";
                  "Current Loan Type" := Loans."Principal Repayment Method";
                  "Current Interest Rate" := Loans."Interest Rate";
                  "Total Outstanding Loan" := LoanMgt.GetLoanValuationWithRefDate("Old Loan No.",Today);

                  "New Loan No." := "Old Loan No.";
                  "New Interest Rate" := "Current Interest Rate";
                  "New Tenure(Months)" := "Current Outstanding Tenure";
                  "New Loan Start Date" := CalcDate('1M',Today);//LoanMgt.GetNextLoanRepaymentDate("Old Loan No.");
                  CurrentLoanValuation := LoanMgt.GetLoanValuationWithRefDate("Old Loan No.",Today); //LoanMgt.GetLoanValuation("Old Loan No."); //Maxwell: Loan Valuation
                  if ("Type of Variation" = "Type of Variation"::"Change of Tenure") or ("Type of Variation" = "Type of Variation"::"Loan Conversion") then
                    //VALIDATE("New Principal","Current Outstanding Principal"+"Current Outstanding Interest");
                    Validate("New Principal",CurrentLoanValuation);
                end;
                Validate("Current Outstanding Principal");

                ValidateAmount;
            end;
        }
        field(8;"Current Outstanding Principal";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Maxwell: To get the Current loan Valuation begin
                //CurrentLoanValuation := LoanMgt.GetLoanValuation("Old Loan No.");
                //"Total Outstanding Loan" := CurrentLoanValuation; //"Current Outstanding Principal"+"Current Outstanding Interest";
            end;
        }
        field(9;"Current Outstanding Interest";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Maxwell: To get the Current loan Valuation begin
                //CurrentLoanValuation := LoanMgt.GetLoanValuation("Old Loan No.");
                //"Total Outstanding Loan" := CurrentLoanValuation; //"Current Outstanding Principal"+"Current Outstanding Interest";
            end;
        }
        field(10;"Current Outstanding Tenure";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Current Loan Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Annuitized,Bullet,Zero Interest';
            OptionMembers = Annuitized,Bullet,"Zero Interest";
        }
        field(12;"Type of Variation";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Top Up,Terminate,Change of Tenure,,,,,,Loan Conversion';
            OptionMembers = " ","Top Up",Terminate,"Change of Tenure",,,,,,"Loan Conversion";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending,Approved,Rejected,Effected';
            OptionMembers = New,Pending,Approved,Rejected,Effected;
        }
        field(14;"New Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15;"New Principal";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("New Tenure(Months)");
                TestField("New Interest Rate");
                TestField("New Loan Start Date");
                if ("New Principal" <> 0) and ("New Interest Rate" <> 0) then
                "New Interest" := LoanMgt.CalculateLoanInterest("New Principal","New Interest Rate","New Tenure(Months)","New Loan Start Date","New Loan Type");
            end;
        }
        field(16;"New Interest";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"New Tenure(Months)";Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("New Principal");
            end;
        }
        field(18;"New Loan Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Annuitized,Bullet,Zero Interest';
            OptionMembers = Annuitized,Bullet,"Zero Interest";

            trigger OnValidate()
            begin
                Validate("New Principal");
            end;
        }
        field(19;"New Loan Start Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("New Principal");
            end;
        }
        field(20;"Approved By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Approved DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Rejected By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Rejected DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Treated By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Treated DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(26;"Top Up Amount";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Maxwell: To get the Current loan Valuation begin
                CurrentLoanValuation := LoanMgt.GetLoanValuationWithRefDate("Old Loan No.", Today);
                "New Principal" := CurrentLoanValuation + "Top Up Amount";
                //END: Comment out the line below.

                Validate("New Principal");
            end;
        }
        field(27;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Client No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Total Outstanding Loan";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30;"Current Interest Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31;"New Interest Rate";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("New Principal");
            end;
        }
        field(32;"No. of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(33;"Price Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(34;"Agent Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35;"Current Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No.")));
            FieldClass = FlowField;
        }
        field(36;"Unit Balance After Loan";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(37;"Balance After Loan";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(66;"Sent For Valuation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*IF "No." = '' THEN BEGIN
          MESSAGE('You are about to do a Loan Variation, kindly pick the desired option.');
          Selection := STRMENU(CreatingText,1);
          LoanMgtSetup.GET;
          IF Selection = 1 THEN BEGIN//Top-Up
              IF LoanMgtSetup."Last Loan Top-up No." <> '' THEN
              BEGIN
              EVALUATE(counters, CONVERTSTR(LoanMgtSetup."Last Loan Top-up No.",'TOP-','0000'))
              END;
              counters:= counters+1;
              reccode:= (PADSTR('', 15 - STRLEN(FORMAT(counters)), '0') + FORMAT(counters));
              "No.":= 'TOP-' + reccode;
              LoanMgtSetup.MODIFYALL("Last Loan Top-up No.",'TOP-' + reccode);
             "Type of Variation" := "Type of Variation"::"Top Up";
          END ELSE
          IF Selection = 2 THEN BEGIN//Termination
              IF LoanMgtSetup."Last Loan Termination No." <> '' THEN
              BEGIN
              EVALUATE(counters, CONVERTSTR(LoanMgtSetup."Last Loan Termination No.",'TMN-','0000'))
              END;
              counters:= counters+1;
              reccode:= (PADSTR('', 15 - STRLEN(FORMAT(counters)), '0') + FORMAT(counters));
              "No.":= 'TMN-' + reccode;
              LoanMgtSetup.MODIFYALL("Last Loan Termination No.",'TMN-' + reccode);
             "Type of Variation" := "Type of Variation"::Terminate;
          END ELSE
          IF Selection = 3 THEN BEGIN//Change of Tenure
              IF LoanMgtSetup."Last Change of Tenure No." <> '' THEN
              BEGIN
              EVALUATE(counters, CONVERTSTR(LoanMgtSetup."Last Change of Tenure No.",'TNR-','0000'))
              END;
              counters:= counters+1;
              reccode:= (PADSTR('', 15 - STRLEN(FORMAT(counters)), '0') + FORMAT(counters));
              "No.":= 'TNR-' + reccode;
              LoanMgtSetup.MODIFYALL("Last Change of Tenure No.",'TNR-' + reccode);
             "Type of Variation" := "Type of Variation"::"Change of Tenure";
          END ELSE
          IF Selection = 4 THEN BEGIN//Conversion to Other Loan Type
              IF LoanMgtSetup."Last Loan Conversion No." <> '' THEN
              BEGIN
              EVALUATE(counters, CONVERTSTR(LoanMgtSetup."Last Loan Conversion No.",'CNV-','0000'))
              END;
              counters:= counters+1;
              reccode:= (PADSTR('', 15 - STRLEN(FORMAT(counters)), '0') + FORMAT(counters));
              "No.":= 'CNV-' + reccode;
              LoanMgtSetup.MODIFYALL("Last Loan Conversion No.",'CNV-' + reccode);
             "Type of Variation" := "Type of Variation"::"Loan Conversion";
          END;
        END;
        
        "Created By" := USERID;
        Date := TODAY;
        */

    end;

    var
        LoanVar: Record "Loan Variation";
        counters: Integer;
        reccode: Code[20];
        ClientAccount: Record "Client Account";
        Loans: Record "Loan Application";
        LoanMgt: Codeunit "Loan Management";
        CreatingText: Label 'Top-up,Termination,Change of Tenure,Conversion to Other Loan Type';
        Selection: Integer;
        LoanMgtSetup: Record "Loan Management Setup";
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
        Client: Record Client;
        InterestPerDay: Decimal;
        LoanValuation: Decimal;
        DueDuration: Integer;
        DueDurationAmount: Decimal;
        DateFilter: Date;
        LoanDueDate: Date;
        InterestDue: Decimal;
        Schedule: Record "Loan Repayment Schedule";
        LoanProduct: Record "Loan Product";
        ClientLoanProduct: Option Annuitized,Bullet,"Zero Interest";
        counter: Integer;
        reccount: Integer;
        FirstUnsettledAmount: Decimal;
        NoofRepayment: Integer;
        CurrentLoanValuation: Decimal;

    local procedure Validateaccount()
    begin
        if ClientAccount.Get("Account No.") then begin
          "Client No.":=ClientAccount."Client ID";
          /*IF ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Subscription") THEN
            ERROR('There is are a restriction on this account that Restricts Subscription');*/
          Validate("Fund Code",ClientAccount."Fund No");
          "Client Name":=ClientAccount."Client Name";
          "Staff ID" := ClientAccount."Staff ID";
          if Client.Get("Client No.") then
          "Agent Code":=Client."Account Executive Code";
        end else begin
          "Client No.":='';
          "Fund Code":='';
          "Client Name":='';
          "Staff ID" := '';
        end;
        Validate("Client No.");

    end;

    procedure ValidateAmount()
    var
        NAVBal: Decimal;
    begin
        CalcFields("Current Unit Balance");

        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code",Date,TransactType::Redemption);

        if "Total Outstanding Loan"<>0 then
        "No. of Units":=FundAdministration.GetFundNounits("Fund Code",Date,"Total Outstanding Loan",TransactType::Redemption);

        "Unit Balance After Loan" := "Current Unit Balance" - "No. of Units";

        "Balance After Loan" := "Unit Balance After Loan"*"Price Per Unit";
    end;
}

