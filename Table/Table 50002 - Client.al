table 50002 Client
{
    DrillDownPageID = "Client List";
    LookupPageID = "Client List";

    fields
    {
        field(1;"Membership ID";Code[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                if "Membership ID" <> xRec."Membership ID" then begin
                  ClientManagementSetup.Get;
                  NoSeriesMgt.TestManual(ClientManagementSetup."Client Nos");
                  "No. Series" := '';
                end;
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
                ClientAdministration.ValidateFirstname("First Name");
                  Validate(Title);
                  //Checkduplicates;
            end;
        }
        field(4;Surname;Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                 ClientAdministration.ValidateSurname(Surname);
                  Validate(Title);
                 //Checkduplicates;
            end;
        }
        field(5;"Other Name/Middle Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                 ClientAdministration.Validateothername("Other Name/Middle Name");
                 Validate(Title);
                 //Checkduplicates;
            end;
        }
        field(6;"Mailing Address";Text[250])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(7;"City/Town";Text[50])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin

                //SetAddress
            end;
        }
        field(8;Contact;Text[50])
        {
            Caption = 'Contact';
            DataClassification = ToBeClassified;
        }
        field(9;"Phone Number";Code[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                ClientAdministration.ValidatePhoneNo("Phone Number");
                Checkduplicates;
            end;
        }
        field(10;Title;Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Salutation;

            trigger OnValidate()
            begin
                 Name:=Title+' '+"First Name"+' '+"Other Name/Middle Name"+' '+Surname;
            end;
        }
        field(11;"House Number";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(12;"Premises/Estate";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(13;Country;Code[100])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(14;"Account Executive Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager";

            trigger OnValidate()
            begin
                AccountmanagerTracker
            end;
        }
        field(15;State;Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(16;"Street Name";Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(17;"Date Of Birth";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Date Of Birth"> Today then
                  Error('Date of birth cannot be greater than today');
            end;
        }
        field(18;Nationality;Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Nationality;
        }
        field(19;"Business/Occupation";Text[100])
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
            OptionCaption = ' ,Single,Married,Divorced,Widowed,Not Available,Unmarried';
            OptionMembers = " ",Single,Married,Divorced,Widowed,"Not Available",Unmarried;
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
        field(28;"Type of ID";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Please_Select,International Passport,Driving Licence,National ID Card,Voters Cards,NIMC';
            OptionMembers = Please_Select,"International Passport","Driving Licence","National ID Card","Voters Cards",NIMC;
        }
        field(29;"ID Card Number";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Type of ID");
            end;
        }
        field(30;"BVN Number";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Maxwell: Commented for EUROBOND and ARM FIF
                //ClientAdministration.ValidateBVN("BVN Number");
            end;
        }
        field(31;"Bank Code";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;

            trigger OnValidate()
            begin
                ClientAccount.Reset;
                ClientAccount.SetCurrentKey("Client ID");
                ClientAccount.SetRange("Client ID","Membership ID");
                if ClientAccount.FindSet then repeat
                  ClientAccount.Validate("Client ID");
                until ClientAccount.Next = 0;

            end;
        }
        field(32;"Bank Branch";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branches"."Branch Code" WHERE ("Bank Code"=FIELD("Bank Code"));

            trigger OnValidate()
            begin
                Validate("Bank Code");
            end;
        }
        field(33;"Bank Account Name";Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Bank Code");
            end;
        }
        field(34;"Bank Account Number";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                //ClientAdministration.ValidateAccountNo("Bank Account Number");
                Validate("Bank Code");
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
        field(37;"Politically Exposed Persons";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Politically Exposed Persons" then
                TestField("Political Information");
            end;
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
        field(43;"Account Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Active,Inactive,Closed';
            OptionMembers = Active,Inactive,Closed;
        }
        field(44;LGA;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Local Governments";

            trigger OnValidate()
            begin
                //SetAddress
            end;
        }
        field(50;"Email Notification";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("E-Mail");
            end;
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

            trigger OnValidate()
            begin
                TestField("Phone Number");
            end;
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
        field(97;"Last Update Source";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(102;"E-Mail";Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                "E-Mail":=UpperCase("E-Mail");
                ClientAdministration.ValidateEmail("E-Mail");
                 Checkduplicates;
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
        field(200;"Last Modified By";Code[100])
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
        field(203;"No of Cautions";Integer)
        {
            CalcFormula = Count("Client Cautions" WHERE ("Client ID"=FIELD("Membership ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(204;"Caution Restrictions";Option)
        {
            CalcFormula = Lookup("Client Cautions"."Restriction Type" WHERE ("Client ID"=FIELD("Membership ID"),
                                                                             Status=FILTER(=Verified)));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'No Restrictions,Restrict Subscription,Restrict Redemption,Restrict Both';
            OptionMembers = "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";
        }
        field(205;"IV Number";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(206;"Reason for Deactivation";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(207;"Staff ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(208;Position;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(209;"Certificate of Incorporation";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(210;"Category of Business";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(211;"Sector/Industry";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(212;"AOD Verified";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Created,Pending Approval,Approved,Rejected';
            OptionMembers = Created,"Pending Approval",Approved,Rejected;
        }
        field(213;"AOD Verified By";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(214;"New Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Membership ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Membership ID" = '' then begin
          ClientManagementSetup.Get;
          ClientManagementSetup.TestField("Client Nos");
          NoSeriesMgt.InitSeries(ClientManagementSetup."Client Nos",xRec."No. Series",0D,"Membership ID","No. Series");
        end;
        "Account Status":="Account Status"::Inactive;
    end;

    trigger OnModify()
    begin
        ClientAccount.Reset;
        ClientAccount.SetFilter("Client ID", "Membership ID");
        if ClientAccount.FindFirst then begin
          repeat
            ClientAccount."Agent Code" := "Account Executive Code";
            ClientAccount."Bank Account Name":= "Bank Account Name";
            ClientAccount."Bank Account Number":="Bank Account Number";
            ClientAccount."Bank Code":="Bank Code";
            ClientAccount.Modify;
          until ClientAccount.Next = 0;
        end
    end;

    var
        PostCode: Record "Post Code";
        ClientManagementSetup: Record "Client Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AccountManagersTracker: Record "Account Managers Tracker";
        Text001: Label 'You cannot set a client as a master of itself';
        Text002: Label '%1 is a master account for %2';
        ClientAdministration: Codeunit "Client Administration";
        SMTPMail: Codeunit "SMTP Mail";
        ClientAccount: Record "Client Account";

    local procedure SetAddress()
    begin
        //"Mailing Address" :="House Number"+ ', '+"Premises/Estate"+', '+"Street Name"+ ', '+"City/Town"+ ','+State+ ', '+Country;
    end;

    local procedure AccountmanagerTracker()
    begin
        if Rec."Account Executive Code"=xRec."Account Executive Code" then
          exit;
          AccountManagersTracker.Init;
          AccountManagersTracker."Client ID":="Membership ID";
          AccountManagersTracker."Account Manager":="Account Executive Code";
          AccountManagersTracker."Date Assigned":=Today;
          AccountManagersTracker."Assigned By":=UserId;
          AccountManagersTracker.Insert;
    end;

    local procedure ValidateClientID()
    var
        Client: Record Client;
    begin
        if "Main Account"="Membership ID" then
          Error(Text001);
        if Client.Get("Main Account") then
             if Client."Main Account"="Membership ID" then
                Error(Text002,"Membership ID","Main Account")
    end;

    local procedure checkifminor()
    begin
        //TESTFIELD("Client Type","Client Type"::Minor);
    end;

    local procedure Checkduplicates()
    begin
        ClientAdministration.CheckClientDuplicates(Rec);
    end;
}

