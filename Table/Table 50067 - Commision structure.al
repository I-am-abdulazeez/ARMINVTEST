table 50067 "Commision structure"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Calculation Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Percentage,Flat Amount';
            OptionMembers = Percentage,"Flat Amount";
        }
        field(4;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Fee %";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(6;"ARM Fees %";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;"IC Fees %";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(8;"Max Comm %";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(9;"Max Due to AE %";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(10;"Amount Per New Client";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(11;"Amount Per DDM";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(12;"Agent Fee %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"ARM Fee %";Decimal)
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
}

