table 50055 "Non Client Members"
{
    DrillDownPageID = "Client List";
    LookupPageID = "Client List";

    fields
    {
        field(1;"Member ID";Code[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                IF "Membership ID" <> xRec."Membership ID" THEN BEGIN
                  ClientManagementSetup.GET;
                  NoSeriesMgt.TestManual(ClientManagementSetup."Client Nos");
                  "No. Series" := '';
                END;
            end;
        }
        field(2;Name;Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3;"First Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                  VALIDATE(Title);
            end;
        }
        field(4;"Last Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                  VALIDATE(Title);
            end;
        }
        field(5;"Middle Names";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                   VALIDATE(Title);
            end;
        }
        field(6;Address;Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(7;City;Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                TESTFIELD(Country);
                SetAddress
            end;
        }
        field(8;Contact;Text[50])
        {
            Caption = 'Contact';
            DataClassification = ToBeClassified;
        }
        field(9;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(10;Title;Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Salutation;

            trigger OnValidate()
            begin
                 Name:=Title+' '+"First Name"+' '+"Other Name/Middle Name"+' '+Surname;
            end;
        }
        field(11;"Block/House No";Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                SetAddress
            end;
        }
        field(12;"Premises/Estate";Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                SetAddress
            end;
        }
        field(13;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                SetAddress
            end;
        }
        field(14;"Account Manager";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager";

            trigger OnValidate()
            begin
                AccountmanagerTracker
            end;
        }
        field(15;State;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;

            trigger OnValidate()
            begin
                SetAddress
            end;
        }
        field(16;"Street Name";Text[250])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Mailing Address":="House Number"+ ' '+"Premises/Estate"+ ' '+"Street Name";
            end;
        }
        field(17;"Date Of Birth";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18;Nationality;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Nationality;
        }
        field(19;Occupation;Text[100])
        {
            Caption = 'Occupation';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(20;"Mothers Maiden Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(21;Gender;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(22;"Marital Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Single,Married,Divorced,Widowed';
            OptionMembers = " ",Single,Married,Divorced,Widowed;
        }
        field(23;"Place of Birth";Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Sponsor First Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                checkifminor
            end;
        }
        field(25;"Sponsor Last Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                checkifminor
            end;
        }
        field(26;"Sponsor Middle Names";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                  checkifminor
            end;
        }
        field(27;SponsorTitle;Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Salutation;

            trigger OnValidate()
            begin
                checkifminor
            end;
        }
        field(28;"Identification Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Please_Select,Passport,Driving Licence,ID Card,National ID Card,Voters Cards,Others';
            OptionMembers = Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;
        }
        field(29;"Identification Number";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Type of ID");
            end;
        }
        field(30;"BVN Number";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31;"Bank Code";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(32;"Bank Branch";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branches"."Branch Code" WHERE (Bank Code=FIELD(Bank Code));
        }
        field(33;"Bank Account Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34;"Bank Account Number";Code[30])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(35;Jurisdiction;Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(36;"US Tax Number";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(37;"Is Politically Exposed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38;"Political Information";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(39;Religion;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Religion;
        }
        field(40;NIN;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(41;"Birth Place";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(42;"Diaspora Client";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(43;"Client Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Inactive,Closed';
            OptionMembers = Active,Inactive,Closed;
        }
        field(44;LGA;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Local Governments";

            trigger OnValidate()
            begin
                SetAddress
            end;
        }
        field(50;"Email Notification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51;"Post Notification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52;"Office Notification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(53;"SMS Notification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(54;"Social Media Engagement";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(93;"Created Dates";Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(94;"Created By User ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(95;"Last Modified Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(96;"Last Modified By User ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(102;"E-Mail";Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                "E-Mail":=UPPERCASE("E-Mail");
            end;
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Client Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Individual,Joint,Corporate,Minor';
            OptionMembers = " ",Individual,Joint,Corporate,Minor;
        }
        field(200;"Last Modified By";Code[20])
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
        field(202;"Main Account";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;

            trigger OnValidate()
            begin
                ValidateClientID
            end;
        }
    }

    keys
    {
        key(Key1;"Member ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        IF "Membership ID" = '' THEN BEGIN
          ClientManagementSetup.GET;
          ClientManagementSetup.TESTFIELD("Client Nos");
          NoSeriesMgt.InitSeries(ClientManagementSetup."Client Nos",xRec."No. Series",0D,"Membership ID","No. Series");
        END;
    end;

    var
        PostCode: Record "Post Code";
        ClientManagementSetup: Record "Client Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AccountManagersTracker: Record "Account Managers Tracker";
        Text001: Label 'You cannot set a client as a master of itself';
        Text002: Label '%1 is a master account for %2';

    local procedure SetAddress()
    begin
        "Mailing Address":="House Number"+ ', '+"Premises/Estate"+ ', '+"City/Town"+ ', '+LGA+ ', '+State+ ', '+Country;
    end;

    local procedure AccountmanagerTracker()
    begin
        IF Rec."Account Executive Code"=xRec."Account Executive Code" THEN
          EXIT;
          AccountManagersTracker.INIT;
          AccountManagersTracker."Client ID":="Membership ID";
          AccountManagersTracker."Account Manager":="Account Executive Code";
          AccountManagersTracker."Date Assigned":=TODAY;
          AccountManagersTracker."Assigned By":=USERID;
          AccountManagersTracker.INSERT;
    end;

    local procedure ValidateClientID()
    var
        Client: Record Client;
    begin
        IF "Main Account"="Membership ID" THEN
          ERROR(Text001);
        IF Client.GET("Main Account") THEN
             IF Client."Main Account"="Membership ID" THEN
                ERROR(Text002,"Membership ID","Main Account")
    end;

    local procedure checkifminor()
    begin
        TESTFIELD("Client Type","Client Type"::Minor);
    end;
}

