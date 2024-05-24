table 50088 "Loan Repayment Schedule"
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
        field(8;"Principal Due";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Interest Due";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Total Due";Decimal)
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
        field(14;"Settlement Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Settled :=true;
                Validate (Settled)
            end;
        }
        field(15;Settled;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Settled then begin
                  "Confirmed By":=UserId;
                   "Settlement Date":= Today;
                end;
            end;
        }
        field(16;"Confirmed By";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Settlement No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Principal Repayment";Decimal)
        {
            CalcFormula = Lookup("Loan Repayment Lines"."Principal Applied" WHERE ("Header No"=FIELD("Settlement No."),
                                                                                   "Line No."=FIELD("Repayment Line No.")));
            FieldClass = FlowField;
        }
        field(19;"Interest Repayment";Decimal)
        {
            CalcFormula = Lookup("Loan Repayment Lines"."Interest Applied" WHERE ("Header No"=FIELD("Settlement No."),
                                                                                  "Line No."=FIELD("Repayment Line No.")));
            FieldClass = FlowField;
        }
        field(20;"Repayment Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Settlement Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Variation,Write-Off';
            OptionMembers = " ",Payment,Variation,"Write-Off";
        }
        field(22;"Principal Settlement";Decimal)
        {
        }
        field(23;"Interest Settlement";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Settlement" := "Principal Settlement"+"Interest Settlement";
            end;
        }
        field(24;"Total Settlement";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Settlement" := "Principal Settlement"+"Interest Settlement";
            end;
        }
        field(25;"Date Filter";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26;"Entry Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Scheduled,Off-Schedule';
            OptionMembers = Scheduled,"Off-Schedule";
        }
        field(27;"Sent For Valuation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Loan No.","Client No.","Repayment Date","Entry Type")
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
        key(Key5;"Entry Type")
        {
        }
    }

    fieldgroups
    {
    }
}

