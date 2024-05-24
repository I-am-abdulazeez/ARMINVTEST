table 50060 "Redemption Schedule Lines"
{
    DrillDownPageID = "Redemption Lines";
    LookupPageID = "Redemption Lines";

    fields
    {
        field(1;"Schedule Header";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Redemption Schedule Header";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Staff ID";Code[40])
        {
            DataClassification = ToBeClassified;
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
        field(20;"Employee Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Employee Amount"<>0 then
                  ValidateAmount
                else begin
                 "Employee No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(21;"Employer Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Employer Amount"<>0 then
                  ValidateAmount
                else begin
                  "Employer No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(22;"Total Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Total Amount"<>0 then
                  ValidateAmount
                else begin
                  "Total No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(40;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Selected By":=UserId;
            end;
        }
        field(41;"Employee No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "Employee No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(42;"Employer No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "Employer No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(43;"Price Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;
        }
        field(44;"Total No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "Total No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(45;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;

            trigger OnValidate()
            begin

                if FundRec.Get("Fund Code") then
                begin
                "Fund Name":=FundRec.Name;
                if "Employee Amount"<>0 then
                Validate("Employee Amount");
                end;
            end;
        }
        field(46;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;
        }
        field(47;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(100;"Bank Narration";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(101;"Redemption Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Part,Full';
            OptionMembers = "Part",Full;

            trigger OnValidate()
            begin
                /*CALCFIELDS("Active Lien");*/
                
                
                ValidateAmount;

            end;
        }
        field(102;"Current Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No")));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"Employee Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Contribution Type"=CONST(Employee)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(104;"Employer Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Contribution Type"=CONST(Employer)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(105;"Employer Bank Code";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Groups"."Bank Code";
        }
        field(106;"Employer Bank Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(107;"Employer Bank Account Name";Code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(108;"Employer Payment Option";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Bank Transfer,Cheque';
            OptionMembers = "Bank Transfer",Cheque;
        }
        field(109;"Sent to Treasury";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(110;"Date Sent to Treasury";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(111;"Treasury Batch";Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Schedule Header","Line No")
        {
        }
    }

    fieldgroups
    {
    }

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
          "Fund Code" := ClientAccount."Fund No";
        if ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Subscription") then
          Error('There is are a restriction on this account that Restricts Subscription');
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
        end
    end;

    local procedure ValidateAmount()
    var
        SubscriptionSchedulesHeader: Record "Redemption Schedule Header";
    begin
        if SubscriptionSchedulesHeader.Get("Schedule Header") then begin
        SubscriptionSchedulesHeader.TestField("Value Date");
        CalcFields("Current Unit Balance","Employer Unit Balance","Employee Unit Balance");
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code",SubscriptionSchedulesHeader."Value Date",TransactType::Redemption);
        "Employee No. Of Units":=FundAdministration.GetFundNounits("Fund Code",SubscriptionSchedulesHeader."Value Date","Employee Amount",TransactType::Redemption);
        "Employer No. Of Units":=FundAdministration.GetFundNounits("Fund Code",SubscriptionSchedulesHeader."Value Date","Employer Amount",TransactType::Redemption);
        "Total No. Of Units":=FundAdministration.GetFundNounits("Fund Code",SubscriptionSchedulesHeader."Value Date","Total Amount",TransactType::Redemption);
         "Employee Amount":="Employee No. Of Units"*"Price Per Unit";
         "Employer Amount":="Employer No. Of Units"*"Price Per Unit";
        
        "Total No. Of Units":="Employee No. Of Units"+"Employer No. Of Units";
        "Total Amount":="Employer Amount"+"Employee Amount";
        
        if ("Total No. Of Units">="Current Unit Balance") or ("Redemption Type"="Redemption Type"::Full)then begin
         /* IF ("No. Of Units">"Current Unit Balance")  THEN
            ERROR('The current account balance is less than the requested Amount. Please check');*/
        
          "Redemption Type":="Redemption Type"::Full;
          "Total No. Of Units":="Current Unit Balance";
          "Total Amount":="Current Unit Balance"*"Price Per Unit";
          "Employee No. Of Units":="Employee Unit Balance";
          "Employee Amount":="Employee Unit Balance"*"Price Per Unit";
          "Employer No. Of Units":="Employer Unit Balance";
          "Employer Amount":="Employer Unit Balance"*"Price Per Unit";
        
        end;
        if "Employee No. Of Units">"Employee Unit Balance" then begin
         "Employee No. Of Units":="Employee Unit Balance";
          "Employee Amount":="Employee Unit Balance"*"Price Per Unit";
        
        end;
        if "Employer No. Of Units">"Employer Unit Balance" then begin
          "Employer No. Of Units":="Employer Unit Balance";
          "Employer Amount":="Employer Unit Balance"*"Price Per Unit";
        end;
        
        "Total No. Of Units":="Employee No. Of Units"+"Employer No. Of Units";
        "Total Amount":="Employer Amount"+"Employee Amount";
        
        
        
        end

    end;
}

