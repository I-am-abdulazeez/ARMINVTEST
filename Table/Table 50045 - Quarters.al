table 50045 Quarters
{

    fields
    {
        field(1;"Code";Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2;Description;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Start Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Closed,false);
            end;
        }
        field(4;"End Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Closed,false);
            end;
        }
        field(5;Closed;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Date Closed";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Closed By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
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

