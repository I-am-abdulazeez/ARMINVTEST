table 50071 "Commission Header"
{

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Start Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"End Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Start Date");
                if "End Date"< "Start Date" then
                  Error('End Date cannot be less than Start Date');
            end;
        }
        field(4;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
             FundAdministrationSetup.Get;
             FundAdministrationSetup.TestField(FundAdministrationSetup."Commission No");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Commission No",xRec."No. Series",0D,No,"No. Series");
          end;


        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundAdministrationSetup: Record "Fund Administration Setup";
}

