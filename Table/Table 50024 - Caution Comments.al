table 50024 "Caution Comments"
{

    fields
    {
        field(1;"Caution No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Cautions"."Caution No";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"Date Raised";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Caution No","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID":=UserId;
        "Date Raised":=CurrentDateTime;
    end;

    trigger OnModify()
    begin
        if "User ID"<>UserId then
          Error('Only the user that add the comment can modify it');
    end;
}

