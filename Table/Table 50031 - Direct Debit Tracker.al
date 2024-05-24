table 50031 "Direct Debit Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Direct Debit Mandate";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Direct Debit Mandate";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Received,ARM Registrar,Logged on Bank Platform,Approved By Bank,Rejected By Bank,Cancelled,Batch ID Generated,Mandate Cancelled,Update Direct Debit,Sent letter to Bank,Received Response From Bank';
            OptionMembers = Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
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

