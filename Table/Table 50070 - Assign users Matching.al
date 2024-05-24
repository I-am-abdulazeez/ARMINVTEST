table 50070 "Assign users Matching"
{

    fields
    {
        field(1;"Matching Header";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Assigned to User";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("Assigned to User");
            end;
        }
        field(4;"Reassign to User";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("Reassign to User");
                if "Assigned to User"="Reassign to User" then
                  Error('You cannot reassign to the same person');
            end;

            trigger OnValidate()
            begin
                TestField(Assigned);
                TestField("Assigned to User");
                if "Assigned to User"="Reassign to User" then
                  Error('You cannot reassign to the same person');
            end;
        }
        field(5;Assigned;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Lines Assigned";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Assigned User"=FIELD("Assigned to User"),
                                                                     "Header No"=FIELD("Matching Header")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"No Of lines to Assign";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8;Reassigned;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Matching Header","Assigned to User")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Assigned);
    end;

    var
        UserMgt: Codeunit "User Management";
}

