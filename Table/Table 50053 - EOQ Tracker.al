table 50053 "EOQ Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;EOQ;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "EOQ Header";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Generated,Internal Control,Verified,Sent to Treasury,Fully Processed';
            OptionMembers = Generated,"Internal Control",Verified,"Sent to Treasury","Fully Processed";
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

