table 50018 "Account Managers Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;
        }
        field(3;"Account Manager";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Date Assigned";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Assigned By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6;Active;Boolean)
        {
            CalcFormula = Exist(Client WHERE ("Membership ID"=FIELD("Client ID"),
                                              "Account Executive Code"=FIELD("Account Manager")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

