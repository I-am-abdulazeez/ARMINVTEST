table 50040 "Fund Transfer Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Fund Transfer No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Transfer";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Rejected,Verified,Posted';
            OptionMembers = Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
        }
        field(14;"Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Changed By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(16;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
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

