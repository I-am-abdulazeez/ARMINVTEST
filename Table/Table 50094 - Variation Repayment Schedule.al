table 50094 "Variation Repayment Schedule"
{
    // version THL-LOAN-1.0.0

    DrillDownPageID = "Loan Repayment Schedule";
    LookupPageID = "Loan Repayment Schedule";

    fields
    {
        field(1;"Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Client No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Repayment Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Loan Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Installment No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Repayment Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Loan Product Type";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(8;Principal;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;Interest;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;Total;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Client Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Due Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Fully Paid";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Closed Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Paid :=true;
                Validate(Paid)
            end;
        }
        field(15;Paid;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Paid then begin
                  "Confirmed By":=UserId;
                   "Closed Date":= Today;
                end;
            end;
        }
        field(16;"Confirmed By";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Repayment Batch";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Principal Repayment";Decimal)
        {
            CalcFormula = Lookup("Loan Repayment Lines"."Principal Applied" WHERE ("Header No"=FIELD("Repayment Batch"),
                                                                                   "Line No."=FIELD("Repayment Line No.")));
            FieldClass = FlowField;
        }
        field(19;"Interest Repayment";Decimal)
        {
            CalcFormula = Lookup("Loan Repayment Lines"."Interest Applied" WHERE ("Header No"=FIELD("Repayment Batch"),
                                                                                  "Line No."=FIELD("Repayment Line No.")));
            FieldClass = FlowField;
        }
        field(20;"Repayment Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Loan No.","Client No.","Repayment Date")
        {
        }
        key(Key2;"Client No.")
        {
        }
        key(Key3;"Loan Product Type")
        {
        }
        key(Key4;"Installment No.","Repayment Code")
        {
        }
    }

    fieldgroups
    {
    }
}

