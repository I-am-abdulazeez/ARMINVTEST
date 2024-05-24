table 50061 "Unit Switch Lines"
{

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Unit Switch Header"."Transaction No";
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Same Fund,Across Funds';
            OptionMembers = "Same Fund","Across Funds";

            trigger OnValidate()
            begin
                Validate("To Account No",'');
            end;
        }
        field(5;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(10;"Staff ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(12;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"From Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                ValidateFromaccount
            end;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;"From Client Name";Text[250])
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
        field(21;Remarks;Text[100])
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
            DecimalPlaces = 2:4;
            Editable = false;
            MinValue = 0;
        }
        field(44;"No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
                  ValidateUnits
            end;
        }
        field(45;"From Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Fund;

            trigger OnValidate()
            begin

                if FundRec.Get("From Fund Code") then
                begin
                "From Fund Name":=FundRec.Name;
                if Amount<>0 then
                Validate(Amount);
                end;
            end;
        }
        field(46;"From Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Client;
        }
        field(47;"From Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50;"To Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                ValidateToaccount
            end;
        }
        field(51;"To Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Fund;

            trigger OnValidate()
            begin
                if Type=Type::"Across Funds" then
                  if "To Fund Code"="From Fund Code" then
                    Error('You cannot select account within the same fund for transfer across funds');

                if FundRec.Get("To Fund Code") then
                begin
                "To Fund Name":=FundRec.Name;
                if Amount<>0 then
                Validate(Amount);
                end;
            end;
        }
        field(52;"To Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Client;
        }
        field(53;"To Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54;"To Client Name";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55;"To Price Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = false;
            MinValue = 0;
        }
        field(56;"To No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(81;"Fund Transfer Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Rejected,Verified,Posted';
            OptionMembers = Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
        }
        field(82;"Date Sent to Reg";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(83;"Date Received From Reg";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(88;"From Fund Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(89;"To Fund Name";Text[50])
        {
            DataClassification = ToBeClassified;
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
        field(97;"Transfer Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Part,Full';
            OptionMembers = "Part",Full;

            trigger OnValidate()
            begin
                ValidateUnits
            end;
        }
        field(98;Currency;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(99;"Agent Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager";
        }
        field(101;"Request Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Walk in,Online';
            OptionMembers = "Walk in",Online;
        }
        field(102;"Current Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("From Account No")));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"Unit Balance after Redmption";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = false;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(120;"From Employee Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "From Employee Amount"<>0 then
                  ValidateAmount
                else begin
                 "From Employee No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(121;"From Employer Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "From Employer Amount"<>0 then
                  ValidateAmount
                else begin
                  "From Employer No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(122;"From Employee No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "From Employee No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(123;"From Employer No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "From Employer No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(124;"To Employee Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "To Employee Amount"<>0 then
                  ValidateAmount
                else begin
                 "To Employee No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(125;"To Employer Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "To Employer Amount"<>0 then
                  ValidateAmount
                else begin
                  "To Employer No. Of Units":=0;
                  "Price Per Unit":=0;
                end;
            end;
        }
        field(126;"To Employee No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "To Employee No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(127;"To Employer No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "To Employer No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(128;"Employer Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("From Account No"),
                                                                         "Contribution Type"=CONST(Employer)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(129;"Employee Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("From Account No"),
                                                                         "Contribution Type"=CONST(Employee)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Header No","Line No")
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
        UnitSwitchHeader: Record "Unit Switch Header";

    local procedure ValidateFromaccount()
    begin
        if ClientAccount.Get("From Account No") then begin
        "From Client ID":=ClientAccount."Client ID";
        if ClientAdministration.CheckifResctrictionExists("From Account No",1,Restrictiontype::"Restrict Redemption") then
          Error('There is are a restriction on this account that Restricts Redemption');
        Validate("From Fund Code",ClientAccount."Fund No");
        "From Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("From Client ID") then
        "From Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
        "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
        end else begin
        "From Client ID":='';
        "From Fund Code":='';
        "From Fund Sub Account":='';
        "From Client Name":='';
        "Street Address":='';
        "Phone No":='';
        "E-mail":='';
        "Agent Code":='';
        end
    end;

    local procedure ValidateAmount()
    begin
        if Amount<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code","Value Date",TransactType::Redemption);
        "No. Of Units":=FundAdministration.GetFundNounits("From Fund Code","Value Date",Amount,TransactType::Redemption);
        CalcFields("Current Unit Balance");
        if ("No. Of Units">"Current Unit Balance") or ("Transfer Type"="Transfer Type"::Full) then begin
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        end else begin
          "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        end;
        "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);

        end
    end;

    local procedure ValidateToaccount()
    begin
        if ClientAccount.Get("To Account No") then begin
        "To Client ID":=ClientAccount."Client ID";
        if ClientAdministration.CheckifResctrictionExists("To Account No",1,Restrictiontype::"Restrict Redemption") then
          Error('There is are a restriction on this account that Restricts Redemption');
        Validate("To Fund Code",ClientAccount."Fund No");
        "To Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("To Client ID") then
        "To Client Name":=Client.Name;

        end else begin
        "To Client ID":='';
        "To Fund Code":='';
        "To Fund Sub Account":='';
        "To Client Name":='';

        end
    end;

    local procedure ValidateUnits()
    begin
        if UnitSwitchHeader.Get("Header No") then;
        UnitSwitchHeader.TestField("Value Date");
        "Value Date":=UnitSwitchHeader."Value Date";
        CalcFields("Current Unit Balance","Employee Unit Balance","Employer Unit Balance");
        if "Transfer Type"="Transfer Type"::Full then
        "No. Of Units":="Current Unit Balance";
        if "No. Of Units"<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code",UnitSwitchHeader."Value Date",TransactType::Redemption);


        Amount:="No. Of Units"*"Price Per Unit";
        "From Employee No. Of Units":="Employee Unit Balance";
        "From Employer No. Of Units":="Employer Unit Balance";
        "From Employee Amount":="Employee Unit Balance"*"Price Per Unit";
        "From Employer Amount":="Employer Unit Balance"*"Price Per Unit";

        if "No. Of Units">"Current Unit Balance" then begin
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        end else begin
          "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        end;
        "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);
        "To Employee No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date","From Employee Amount",TransactType::Subscription);
        "To Employer No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date","From Employer Amount",TransactType::Subscription);
        "To Employee Amount":="To Employee No. Of Units"*"To Price Per Unit";
        "To Employer Amount":="To Employer No. Of Units"*"To Price Per Unit";
        end
    end;
}

