table 50097 "Historical Loan Variation"
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
                  ClientAccount.SetRange("Fund No","Fund Code");
                  if ClientAccount.FindSet then begin repeat
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

                  "New Loan No." := "Old Loan No.";
                  "New Interest Rate" := "Current Interest Rate";
                  "New Tenure(Months)" := "Current Outstanding Tenure";
                  "New Loan Start Date" := LoanMgt.GetNextLoanRepaymentDate("Old Loan No.");
                end;
                Validate("Current Outstanding Principal");
            end;
        }
        field(8;"Current Outstanding Principal";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Outstanding Loan" := "Current Outstanding Principal"+"Current Outstanding Interest";
            end;
        }
        field(9;"Current Outstanding Interest";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Outstanding Loan" := "Current Outstanding Principal"+"Current Outstanding Interest";
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
                "New Principal" := "Total Outstanding Loan"+"Top Up Amount";
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
        if "No." = '' then begin
          LoanVar.Reset;
          if LoanVar.FindLast then
          begin
          Evaluate(counters, ConvertStr(LoanVar."No.",'LVR-','0000'))
          end;
          counters:= counters+1;
          reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
          "No.":= 'LVR-' + reccode;
        end;
        "Created By" := UserId;
        Date := Today;
    end;

    var
        LoanVar: Record "Loan Variation";
        counters: Integer;
        reccode: Code[20];
        ClientAccount: Record "Client Account";
        Loans: Record "Loan Application";
        LoanMgt: Codeunit "Loan Management";

    local procedure Validateaccount()
    begin
        if ClientAccount.Get("Account No.") then begin
        "Client No.":=ClientAccount."Client ID";
        /*IF ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Subscription") THEN
          ERROR('There is are a restriction on this account that Restricts Subscription');*/
        Validate("Fund Code",ClientAccount."Fund No");
        "Client Name":=ClientAccount."Client Name";
        "Staff ID" := ClientAccount."Staff ID";
        end else begin
        "Client No.":='';
        "Fund Code":='';
        "Client Name":='';
        "Staff ID" := '';
        end;
        Validate("Client No.");

    end;
}

