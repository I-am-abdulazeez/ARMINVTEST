table 50025 Subscription
{

    fields
    {
        field(1;No;Code[40])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Subscription Nos");
                   "No. Series" := '';
                end;
            end;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateAmount;
            end;
        }
        field(3;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Cheque No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Cheque Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Cheque Type";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(9;"Received From";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"On Behalf Of";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(12;"Creation Date";DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Creation Date" := CurrentDateTime;
            end;
        }
        field(13;"Account No";Code[40])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;"Client Name";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16;Posted;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17;"Date Posted";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18;"Time Posted";Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19;"Posted By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(20;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:8;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Amount<>0 then
                  ValidateAmount
                else begin
                  "No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(21;Remarks;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Transaction Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(33;"Bank Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Selected By":=UserId;
            end;
        }
        field(43;"Price Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;
        }
        field(44;"No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(45;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Fund;

            trigger OnValidate()
            begin

                if FundRec.Get("Fund Code") then
                begin
                "Fund Name":=FundRec.Name;
                if Amount<>0 then
                Validate(Amount);
                end;
            end;
        }
        field(46;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Client;
        }
        field(47;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(81;"Subscription Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,Confirmed,Posted,Rejected';
            OptionMembers = Received,Confirmed,Posted,Rejected;
        }
        field(82;"Date Sent to Reg";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(83;"Date Received From Reg";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(88;"Fund Name";Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91;"Street Address";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(92;"E-mail";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(93;"Phone No";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(95;"Data Source";Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(96;"Selected By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(97;"Agent Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager";
        }
        field(98;Currency;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(99;"Matching Header No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(100;"Bank Narration";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;AutoMatched;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(106;"Direct Posting";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(107;"OLD Account No";Code[40])
        {
            CalcFormula = Lookup("Client Account"."Old Account Number" WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(117;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            ExtendedDatatype = URL;
        }
        field(118;"Payment Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash Deposits & Bank Account Transfers,Direct debit - CMMS,Direct Debit - Flutterwave,Direct Debit - GAPS,Direct Debit - Standing Instruction,E-Payment,Dividend,Buy Back,Others';
            OptionMembers = " ","Cash Deposits & Bank Account Transfers","Direct debit - CMMS","Direct Debit - Flutterwave","Direct Debit - GAPS","Direct Debit - Standing Instruction","E-Payment",Dividend,"Buy Back",Others;
        }
        field(119;"Automatch Ref";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(120;"Reference Code";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(143;"Unit Bal After Subscriptions";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(144;"Current Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No")));
            FieldClass = FlowField;
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
             FundAdministrationSetup.TestField(FundAdministrationSetup."Subscription Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Subscription Nos",xRec."No. Series",0D,No,"No. Series");
          end;

        if "Data Source"<>'IMPORTED' then
          if "Value Date"=0D then
           "Value Date":=Today;
        "Transaction Date":=Today;
        "Created By":=UserId;
        "Creation Date":=CurrentDateTime;
        FundAdministration.InsertSubscriptionTracker("Subscription Status",No);
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundRec: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
        ClientAdministration: Codeunit "Client Administration";
        Restrictiontype: Option "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";

    local procedure Validateaccount()
    begin
        if ClientAccount.Get("Account No") then begin
        "Client ID":=ClientAccount."Client ID";
        if ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Subscription") then
          Error('There is a restriction on account %1 that restricts Subscription', "Account No");
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("Client ID") then
        "Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
        "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
        end else begin
        "Client ID":='';
        "Fund Code":='';
        "Fund Sub Account":='';
        "Client Name":='';
        "Street Address":='';
        "Phone No":='';
        "E-mail":='';
        "Agent Code":='';
        end;

        CalcFields("Current Unit Balance");
    end;

    local procedure ValidateAmount()
    begin
        if Amount<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Subscription);
        "No. Of Units":=FundAdministration.GetFundNounits("Fund Code","Value Date",Amount,TransactType::Subscription);
        end;
        CalcFields("Current Unit Balance");
        "Unit Bal After Subscriptions" := "Current Unit Balance" + "No. Of Units";
    end;
}

