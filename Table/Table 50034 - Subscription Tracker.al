table 50034 "Subscription Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;Subscription;Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Subscription;
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Received,Confirmation,Posted,Rejected';
            OptionMembers = Received,Confirmation,Posted,Rejected;
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

