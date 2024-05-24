table 50010 State
{
    DrillDownPageID = States;
    LookupPageID = States;

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Name;Text[50])
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
        key(Key1;"Code")
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

