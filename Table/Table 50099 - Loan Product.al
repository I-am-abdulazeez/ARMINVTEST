table 50099 "Loan Product"
{
    // version THL-LOAN-1.0.0

    DrillDownPageID = "Loan Product Types";
    LookupPageID = "Loan Product Types";

    fields
    {
        field(1;"Code";Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                InitializeLoanParameters;
            end;
        }
        field(2;"Product Type";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Fund Name" <> '' then
                  "Product Description" := UpperCase("Fund Name"+' '+"Product Type")
                else
                  "Product Description" := UpperCase("Product Type");
            end;
        }
        field(3;"Applicable Investment Balance";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Total Investment Balance,Employee Investment Balance,Employer Investment Balance';
            OptionMembers = "Total Investment Balance","Employee Investment Balance","Employer Investment Balance";
        }
        field(4;"Investment Bal. Max Percentage";Decimal)
        {
            Caption = 'Maximum Percentage';
            DataClassification = ToBeClassified;
        }
        field(5;"Repayment Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Amortized,Reducing Balance,Straight Line,Constants,Pre-Retirement';
            OptionMembers = Amortized,"Reducing Balance","Straight Line",Constants,"Pre-Retirement";

            trigger OnValidate()
            begin
                if "Repayment Type" = "Repayment Type"::"Pre-Retirement" then
                 "Principal Repayment Method" := "Principal Repayment Method"::None;
            end;
        }
        field(6;"Principal Repayment Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Annuity,Bullet,None';
            OptionMembers = Annuity,Bullet,"None";
        }
        field(7;"Default Loan Amount Option";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Percentage of Investment Balance";
        }
        field(8;"Default Loan (% of Inv. Bal)";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Installment Period";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"No. of Installments";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Interest Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Grace Period before Repayment";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Inactive,Active';
            OptionMembers = Inactive,Active;

            trigger OnValidate()
            begin
                if Status <> xRec.Status then begin
                  if xRec.Status = xRec.Status::Active then begin
                    "Activated By" := UserId;
                    "Activated DateTime" := CurrentDateTime;
                  end;
                  if xRec.Status = xRec.Status::Inactive then begin
                    "Deactivated By" := UserId;
                    "Deactivated DateTime" := CurrentDateTime;
                  end;
                end;
            end;
        }
        field(14;"Loan Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Annuitized,Bullet,Zero Interest';
            OptionMembers = Annuitized,Bullet,"Zero Interest";

            trigger OnValidate()
            begin
                InitializeLoanParameters;
            end;
        }
        field(15;"Activated By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Activated DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Deactivated By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Deactivated DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(19;Fund;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;

            trigger OnValidate()
            begin
                if Funds.Get(Fund) then begin
                  "Fund Name" := Funds.Name;
                  "Product Description" := UpperCase("Fund Name"+' '+"Product Type");
                end;
            end;
        }
        field(20;"Fund Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Product Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Funds: Record Fund;

    local procedure InitializeLoanParameters()
    begin
        if "Loan Type" = "Loan Type"::Annuitized then begin
          "Product Type" := 'Amortized Loan with Fixed Rate';
          "Applicable Investment Balance" := "Applicable Investment Balance"::"Total Investment Balance";
          "Investment Bal. Max Percentage" := 50;
          "Repayment Type" := "Repayment Type"::Amortized;
          "Principal Repayment Method" := "Principal Repayment Method"::Annuity;
          "Default Loan Amount Option" := "Default Loan Amount Option"::" ";
          "Default Loan (% of Inv. Bal)" := 0;
          Evaluate("Installment Period",'1M');
          "No. of Installments" := 24;
          Evaluate("Grace Period before Repayment",'1M');
          "Interest Rate" := 12;
        end else if "Loan Type" = "Loan Type"::Bullet then begin
          "Product Type" := 'Amortized Loan with periodic principal repayment';
          "Applicable Investment Balance" := "Applicable Investment Balance"::"Total Investment Balance";
          "Investment Bal. Max Percentage" := 50;
          "Repayment Type" := "Repayment Type"::Amortized;
          "Principal Repayment Method" := "Principal Repayment Method"::Bullet;
          "Default Loan Amount Option" := "Default Loan Amount Option"::" ";
          "Default Loan (% of Inv. Bal)" := 0;
          Evaluate("Installment Period",'1M');
          "No. of Installments" := 24;
          Evaluate("Grace Period before Repayment",'1M');
           "Interest Rate" := 12;
        end else begin
          "Product Type" := 'Pre-Retirement Advance';
          "Applicable Investment Balance" := "Applicable Investment Balance"::"Employee Investment Balance";
          "Investment Bal. Max Percentage" := 30;
          "Repayment Type" := "Repayment Type"::"Pre-Retirement";
          "Principal Repayment Method" := "Principal Repayment Method"::None;
          "Default Loan Amount Option" := "Default Loan Amount Option"::"Percentage of Investment Balance";
          "Default Loan (% of Inv. Bal)" := 30;
          Evaluate("Installment Period",'0D');
          "No. of Installments" := 0;
          Evaluate("Grace Period before Repayment",'1M');
           "Interest Rate" := 0;
        end;
    end;
}

