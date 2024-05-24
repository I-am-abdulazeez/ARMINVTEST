table 5098 "Saved Segment Criteria"
{
    // version NAVW113.00

    Caption = 'Saved Segment Criteria';
    LookupPageID = "Saved Segment Criteria List";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(4;"User ID";Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(5;"No. of Actions";Integer)
        {
            CalcFormula = Count("Saved Segment Criteria Line" WHERE ("Segment Criteria Code"=FIELD(Code),
                                                                     Type=CONST(Action)));
            Caption = 'No. of Actions';
            Editable = false;
            FieldClass = FlowField;
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

    trigger OnDelete()
    var
        SavedSegCriteriaLine: Record "Saved Segment Criteria Line";
    begin
        SavedSegCriteriaLine.SetRange("Segment Criteria Code",Code);
        SavedSegCriteriaLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;
}
