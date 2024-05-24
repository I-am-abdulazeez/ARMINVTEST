table 50009 "KYC Tier Requirements"
{
    DrillDownPageID = 52132212;
    LookupPageID = 52132212;

    fields
    {
        field(1;"KYC Tier";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "KYC Tier";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Requirement;Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Document Types";
        }
        field(4;Provided;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(200;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(201;"Last Modified DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"KYC Tier","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;
}

