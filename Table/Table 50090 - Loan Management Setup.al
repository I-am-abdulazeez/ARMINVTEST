table 50090 "Loan Management Setup"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"Primary Key";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Min Investment Bal for Loan";Decimal)
        {
            Caption = 'Min. Investment Balance for Loan';
            DataClassification = ToBeClassified;
        }
        field(3;"Non-Performing Loan Months";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Last Loan App No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Last Loan Top-up No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Last Change of Tenure No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Last Loan Termination No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Last Loan Conversion No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Last Batch Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

