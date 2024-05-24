table 50084 "Loan Product Charges"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;Loan;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Description;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Amount Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Flat Amount,Percentage';
            OptionMembers = "Flat Amount",Percentage;
        }
        field(5;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Loan)
        {
        }
    }

    fieldgroups
    {
    }
}

