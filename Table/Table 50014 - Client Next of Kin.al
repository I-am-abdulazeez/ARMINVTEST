table 50014 "Client Next of Kin"
{

    fields
    {
        field(1;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Client;
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"NOK Relationship";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Relationships.Code;
        }
        field(4;"NOK Name";Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"NOK Address";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"NOK Address 2";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"NOK Telephone No";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"NOK Email";Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidateEmail("NOK Email");
            end;
        }
        field(9;"NOK Last Name";Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidateSurname("NOK Last Name");
                Validate("NOK Title");
            end;
        }
        field(10;"NOK First Name";Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidateFirstname("NOK First Name");
                Validate("NOK Title");
            end;
        }
        field(11;"NOK Middle Name";Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.Validateothername("NOK Middle Name");
                Validate("NOK Title");
            end;
        }
        field(12;"NOK Title";Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Salutation;

            trigger OnValidate()
            begin
                "NOK Name":="NOK Title"+' '+"NOK First Name"+' '+"NOK Middle Name"+' '+"NOK Last Name";
            end;
        }
        field(13;"NOK Gender";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Please_Select,Male,Female';
            OptionMembers = Please_Select,Male,Female;
        }
        field(14;"NOK State of Origin";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(16;"NOK Town";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(17;"NOK Country";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(18;"NOK E-mail";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidateEmail("NOK E-mail");
            end;
        }
        field(19;"NOK Home Phone";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidatePhoneNo("NOK Home Phone");
            end;
        }
        field(20;"NOK Mobile Phone";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidatePhoneNo("NOK Mobile Phone");;
            end;
        }
        field(21;"NOK Office Phone";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidatePhoneNo("NOK Office Phone");
            end;
        }
        field(22;Source;Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Client ID","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ClientAdministration: Codeunit "Client Administration";
}

