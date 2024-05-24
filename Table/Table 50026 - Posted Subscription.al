table 50026 "Posted Subscription"
{

    fields
    {
        field(1;No;Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
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
            DecimalPlaces = 4:8;
            Editable = false;
            MinValue = 0;
        }
        field(44;"No. Of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:8;
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
            TableRelation = Client;
        }
        field(47;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(81;"Subscription Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,Confirmed,Posted';
            OptionMembers = Received,Confirmed,Posted;
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
        field(118;"Payment Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash Deposits & Bank Account Transfers,Direct debit - CMMS,Direct Debit - Flutterwave,Direct Debit - GAPS,Direct Debit - Standing Instruction,E-Payment,Dividend,Buy Back,Others';
            OptionMembers = " ","Cash Deposits & Bank Account Transfers","Direct debit - CMMS","Direct Debit - Flutterwave","Direct Debit - GAPS","Direct Debit - Standing Instruction","E-Payment",Dividend,"Buy Back",Others;
        }
        field(119;"Automatch Ref";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(120;"Reference Code";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(121;Reversed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(122;"Reversed By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(123;"Date Time reversed";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(124;"Reversal Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Client,Fund';
            OptionMembers = " ",Client,Fund;
        }
        field(125;"Reverse To Client";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";
        }
        field(126;"Reversal Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Pending Reversal,Approved,Rejected';
            OptionMembers = " ","Pending Reversal",Approved,Rejected;
        }
        field(127;"Date sent To Audit";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(128;"Reversal Document Link";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(129;"Rejection Reason";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(142;"OLD Account No";Code[40])
        {
            CalcFormula = Lookup("Client Account"."Old Account Number" WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
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

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundRec: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
        "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
    end;

    local procedure ValidateAmount()
    begin
        if Amount<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Subscription);
        "No. Of Units":=FundAdministration.GetFundNounits("Fund Code","Value Date",Amount,TransactType::Subscription);
        end
    end;
}

