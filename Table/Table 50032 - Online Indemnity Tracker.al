table 50032 "Online Indemnity Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Online Indemnity";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Online Indemnity Mandate";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Verification Successful,Verification Rejected,Cancelled';
            OptionMembers = Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
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

