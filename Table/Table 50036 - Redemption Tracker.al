table 50036 "Redemption Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;Redemption;Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Redemption;
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Rejected,Verified,Posted,Customer Experience Verification';
            OptionMembers = Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";
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

