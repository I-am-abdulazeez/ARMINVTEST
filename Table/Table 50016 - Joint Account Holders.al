table 50016 "Joint Account Holders"
{

    fields
    {
        field(10;"Line no";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;
        }
        field(25;"Fund No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;
        }
        field(30;"Last Name";Text[130])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientSetupFunctions.ValidateSurname("Last Name");
                Validate(Title);
            end;
        }
        field(40;"First Name";Text[130])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientSetupFunctions.ValidateFirstname("First Name");
            end;
        }
        field(50;"Middle Names";Text[120])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientSetupFunctions.Validateothername("Middle Names")
            end;
        }
        field(60;Title;Text[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Salutation;
        }
        field(70;"Date of Birth";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Date of Birth">Today then
                  Error('Date of birth cannot be greater than today');
            end;
        }
        field(80;Gender;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Please_Select,Male,Female';
            OptionMembers = Please_Select,Male,Female;
        }
        field(90;"State of Origin";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(100;"Local Gov. Code";Code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(110;Address1;Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(120;Address2;Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(130;State;Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(140;Phone;Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientSetupFunctions.ValidatePhoneNo(Phone);
            end;
        }
        field(150;Email;Text[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientSetupFunctions.ValidateEmail(Email);
            end;
        }
        field(200;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(210;"Main Holder";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(220;Signatory;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(230;"Required Signatory";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(231;Source;Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Client ID","Line no")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if not ClientSetupFunctions.CheckifJointaccount("Client ID") then
          Error(TEXT001);
    end;

    var
        ClientSetupFunctions: Codeunit "Client Administration";
        TEXT001: Label 'Account Type must be Joint Account';
}

