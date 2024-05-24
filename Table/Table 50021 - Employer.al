table 50021 Employer
{
    DrillDownPageID = Employers;
    LookupPageID = Employers;

    fields
    {
        field(10;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(30;"Co. Registration No.";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(40;"Company Name";Text[230])
        {
            DataClassification = ToBeClassified;
        }
        field(60;"Industry Sector";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Private,Public';
            OptionMembers = Private,Public;
        }
        field(70;"Business Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'State,FCT,Federal,NGO,Other';
            OptionMembers = State,FCT,Federal,NGO,Other;
        }
        field(80;Address1;Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(90;Address2;Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(110;State;Code[2])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('STATES'));
        }
        field(120;Phone;Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(130;Email;Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(140;Contact;Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

