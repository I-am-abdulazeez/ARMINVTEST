table 50029 "Direct Debit Mandate"
{
    DrillDownPageID = "All Direct Debit Requests";
    LookupPageID = "All Direct Debit Requests";

    fields
    {
        field(1;No;Code[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Request Type"="Request Type"::Setup then begin
                  if No <> xRec.No then begin
                    FundAdministrationSetup.Get;
                    NoSeriesMgt.TestManual(FundAdministrationSetup."Direct Debit Setup Nos");
                     "No. Series" := '';
                  end;
                end
                else begin
                  if No <> xRec.No then begin
                    FundAdministrationSetup.Get;
                    NoSeriesMgt.TestManual(FundAdministrationSetup."Direct Debit Cancel Nos");
                     "No. Series" := '';
                  end;
                end
            end;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(3;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Client."Membership ID";

            trigger OnValidate()
            begin
                TestField("Account No",'');
            end;
        }
        field(4;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Fund;
        }
        field(5;"Sub Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Client Name";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Request Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Setup,Cancellation,Suspension';
            OptionMembers = Setup,Cancellation,Suspension;
        }
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(9;"Bank Branch Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Bank Account Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Bank Account Number";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ClientAdministration.ValidateAccountNo("Bank Account Number");
            end;
        }
        field(12;Frequency;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Variable,Weekly,Every 2 Weeks,Monthly,Every 2 Months,Every 3 Months,Every 4 Months,Every 5 Months,Every 6 Months';
            OptionMembers = Variable,Weekly,"Every 2 Weeks",Monthly,"Every 2 Months","Every 3 Months","Every 4 Months","Every 5 Months","Every 6 Months";
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,ARM Registrar,Logged on Bank Platform,Approved By Bank,Rejected By Bank,Rejected By ARM Reg,Cancelled,Batch ID Generated,Mandate Cancelled,Update Direct Debit,Sent letter to Bank,Received Response From Bank';
            OptionMembers = Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
        }
        field(14;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(15;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Request Type"="Request Type"::Setup then begin
                  TestField(Amount);
                  TestField("Account No");

                  if "Multiple Beneficiaries" then
                    if Amount <> "Total Beneficiaries Amount" then
                      Error('The Sum of amounts apportioned to the Beneficiaries must be equal to the Total Amount on Mandate no %1',No);
                end else begin
                  TestField("Cancellation Channel");
                  TestField("Direct Debit to Be cancelled");
                end;
                if Select then
                  "Selected By":=UserId
                else
                  "Selected By":='';
            end;
        }
        field(19;"Selected By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(20;"Cancellation Channel";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Online Channels,Bank';
            OptionMembers = " ","Online Channels",Bank;
        }
        field(21;"Direct Debit to Be cancelled";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Direct Debit Mandate".No WHERE (Status=CONST("Approved By Bank"),
                                                             "Account No"=FIELD("Account No"));

            trigger OnValidate()
            var
                DirectDebitMandate: Record "Direct Debit Mandate";
            begin
                if DirectDebitMandate.Get("Direct Debit to Be cancelled") then begin
                  Validate("Account No",DirectDebitMandate."Account No");
                 "Cancelled Reference Number":=DirectDebitMandate."Reference Number";
                end
            end;
        }
        field(22;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(23;"Multiple Beneficiaries";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if not "Multiple Beneficiaries" then
                  Checkbeneficiaries;
            end;
        }
        field(24;"Total Beneficiaries Amount";Decimal)
        {
            CalcFormula = Sum("Direct Debit Mandate Benefic".Amount WHERE ("Mandate No"=FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25;"Start Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "End Date":=CalcDate('10Y',"Start Date");
            end;
        }
        field(26;"End Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = PhoneNo;
        }
        field(28;"E-Mail";Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(106;Source;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(118;"Response Code";Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(119;"Response Description";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(120;"Reference Number";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(121;AdditionalComments;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(122;Blob;BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(123;FileName;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(124;"Nibbs Approval Status";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(125;"WorkFlow Status";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(126;"WorkFlow Status Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(127;"Cancelled Reference Number";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(128;"Rejected By";Code[10])
        {
            DataClassification = ToBeClassified;
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
        fieldgroup(DropDown;No,"Account No","Client ID","Fund Code")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Request Type"="Request Type"::Setup then begin
          if No = '' then begin
               FundAdministrationSetup.Get;
               FundAdministrationSetup.TestField(FundAdministrationSetup."Direct Debit Setup Nos");
               NoSeriesMgt.InitSeries(FundAdministrationSetup."Direct Debit Setup Nos",xRec."No. Series",0D,No,"No. Series");
            end;
        end
        else begin
           if No = '' then begin
               FundAdministrationSetup.Get;
               FundAdministrationSetup.TestField(FundAdministrationSetup."Direct Debit Cancel Nos");
               NoSeriesMgt.InitSeries(FundAdministrationSetup."Direct Debit Cancel Nos",xRec."No. Series",0D,No,"No. Series");
            end;

        end;
        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
        FundAdministration.InsertDirectDebitTracker(Status,No);
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        ShowBeneficiaries: Boolean;
        FundAdministration: Codeunit "Fund Administration";
        ClientAdministration: Codeunit "Client Administration";

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        "Fund Code":=ClientAccount."Fund No";
        "Sub Fund Code":=ClientAccount."Fund Sub Account";
        "Bank Account Name":=ClientAccount."Bank Account Name";
        "Bank Account Number":=ClientAccount."Bank Account Number";
        "Bank Code":=ClientAccount."Bank Code";
        "Bank Branch Code":=ClientAccount."Bank Branch";
        "E-Mail":=Client."E-Mail";
        "Phone No.":=Client."Phone Number";
    end;

    local procedure Checkbeneficiaries()
    var
        DirectDebitMandateBenefic: Record "Direct Debit Mandate Benefic";
    begin
        DirectDebitMandateBenefic.Reset;
        DirectDebitMandateBenefic.SetRange("Mandate No",No);
        if DirectDebitMandateBenefic.FindFirst then
          Error('you must delete the lines before unchecking this');
    end;

    [Scope('Personalization')]
    procedure ToBase64String(): Text
    var
        IStream: InStream;
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        Base64String: Text;
    begin
        if not Blob.HasValue then
          exit('');
        Blob.CreateInStream(IStream);
        MemoryStream := MemoryStream.MemoryStream;
        CopyStream(MemoryStream,IStream);
        Base64String := Convert.ToBase64String(MemoryStream.ToArray);
        MemoryStream.Close;
        exit(Base64String);
    end;
}

