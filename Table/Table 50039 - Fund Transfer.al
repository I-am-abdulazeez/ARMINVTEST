table 50039 "Fund Transfer"
{

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Fund Transfer Nos");
                   "No. Series" := '';
                end;
            end;
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
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
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
        field(34;"Bank Account Name";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
            TableRelation = IF (Type=CONST("Same Fund")) "Client Account"."Account No" WHERE ("Fund No"=FIELD("From Fund Code"))
                            ELSE IF (Type=CONST("Across Funds")) "Client Account"."Account No";

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
            DecimalPlaces = 4:8;
            Editable = false;
            MinValue = 0;
        }
        field(56;"To No. Of Units";Decimal)
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
                if "Transfer Type"="Transfer Type"::Part then begin
                  Amount:=0;
                  "No. Of Units":=0;

                end;
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
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"Unit Balance after Redmption";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106;"Total Amount Payable";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = false;
        }
        field(107;"Accrued Dividend";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("From Account No"),
                                                                                   "Fully Paid"=CONST(false)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(126;"Registrar Control ID";Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(127;"Registrar Comments";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(128;SignatureStatus;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(129;AdditionalComments;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(132;"Fee Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(133;"Fee Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(134;"Net Amount Payable";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(137;"Quarter Filter";Code[20])
        {
            CalcFormula = Lookup(Quarters.Code WHERE (Closed=CONST(false)));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                /*Quarters.RESET;
                Quarters.SETRANGE(Closed, FALSE);
                IF Quarters.FINDFIRST THEN
                  "Quarter Filter" := Quarters.Code;*/

            end;
        }
        field(138;"Reason For Rejection";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Variation in Amount booked,Insufficient balance,Unclear instruction,Instruction not signed,Instruction not dated,Signature irregular,signature different,Wrong Beneficiary selected';
            OptionMembers = " ","Variation in Amount booked","Insufficient balance","Unclear instruction","Instruction not signed","Instruction not dated","Signature irregular","signature different","Wrong Beneficiary selected";
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
             FundAdministrationSetup.TestField(FundAdministrationSetup."Fund Transfer Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Fund Transfer Nos",xRec."No. Series",0D,No,"No. Series");
          end;

        if "Data Source"<>'IMPORTED' then
           "Value Date":=Today;
        "Transaction Date":=Today;
        "Created By":=UserId;
        "Creation Date":=Today;
        FundAdministration.InsertFundTransferTracker("Fund Transfer Status",No);
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
        Fund: Record Fund;
        NAVBAL: Decimal;

    local procedure ValidateFromaccount()
    begin
        if ClientAccount.Get("From Account No") then begin
        "From Client ID":=ClientAccount."Client ID";
        if (ClientAdministration.CheckifResctrictionExists("From Account No",1,Restrictiontype::"Restrict Redemption")) or (ClientAdministration.CheckifResctrictionExists("From Account No",1,Restrictiontype::"Restrict Both")) then
          Error('There is a restriction on this account that Restricts Redemption');
        Validate("From Fund Code",ClientAccount."Fund No");
        "From Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("From Client ID") then
        "From Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
        "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
        Remarks:='Unit Transfer From '+"From Account No"+ ' To '+"To Account No";
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
        TestField("From Account No");
        TestField("To Account No");
        if Amount<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code","Value Date",TransactType::Redemption);
        "No. Of Units":=FundAdministration.GetFundNounits("From Fund Code","Value Date",Amount,TransactType::Redemption);
        //Maxwell: Unit Transfer Charges BEGIN
        if (("To Fund Code" <> 'ARMMMF') and (Type <> Type::"Same Fund")) then begin
          "Fee Amount" := FundAdministration.GetFee("From Fund Code",Amount);
          "Fee Units" := FundAdministration.GetFundNounits("From Fund Code","Value Date","Fee Amount",TransactType::Redemption);
        end;
        //END
        CalcFields("Current Unit Balance");
        if ("No. Of Units">"Current Unit Balance") or ("Transfer Type"="Transfer Type"::Full) then begin
          "No. Of Units":="Current Unit Balance";
          "Transfer Type":="Transfer Type"::Full;
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        end else begin
          "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";
           if Fund.Get("From Fund Code") then ;
          NAVBAL:="Unit Balance after Redmption"*"Price Per Unit";
          if NAVBAL<Fund."Minimum Holding Balance" then begin
           "Transfer Type":="Transfer Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
          end
        end;
        "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);
        end;
        if "Transfer Type"="Transfer Type"::Full then begin
          //Maxwell: Added Fee Amount to the codes below --01/02/2020
          "Total Amount Payable":=Amount+"Accrued Dividend";
          "Net Amount Payable" := Amount+"Accrued Dividend"-"Fee Amount";
        end else begin
        "Total Amount Payable":=Amount+"Fee Amount";
        "Net Amount Payable":= Amount;
        end;
    end;

    local procedure ValidateToaccount()
    var
        FundBankAccounts: Record "Fund Bank Accounts";
    begin
        if ClientAccount.Get("To Account No") then begin
        "To Client ID":=ClientAccount."Client ID";
        if (ClientAdministration.CheckifResctrictionExists("To Account No",1,Restrictiontype::"Restrict Subscription")) or (ClientAdministration.CheckifResctrictionExists("From Account No",1,Restrictiontype::"Restrict Both")) then
          Error('There is a restriction on this account that Restricts Subscription');
        Validate("To Fund Code",ClientAccount."Fund No");
        "To Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("To Client ID") then
        "To Client Name":=Client.Name;
        Remarks:='Unit Transfer From '+"From Account No"+ ' To '+"To Account No";
        if Type=Type::"Across Funds" then begin
        FundBankAccounts.Reset;
        FundBankAccounts.SetRange("Fund Code","To Fund Code");
        FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Subscription);
        if FundBankAccounts.FindFirst then begin
        "Bank Code":=FundBankAccounts."Bank Code";
        "Bank Account No":=FundBankAccounts."Bank Account No";
        "Bank Account Name":=FundBankAccounts."Bank Account Name";

        end

        end

        end else begin
        "To Client ID":='';
        "To Fund Code":='';
        "To Fund Sub Account":='';
        "To Client Name":='';

        end
    end;

    local procedure ValidateUnits()
    begin
        TestField("From Account No");
        TestField("To Account No");

        CalcFields("Current Unit Balance");
        if "Transfer Type"="Transfer Type"::Full then
        "No. Of Units":="Current Unit Balance";
        if "No. Of Units"<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code","Value Date",TransactType::Redemption);
        Amount:="No. Of Units"*"Price Per Unit";

        if "No. Of Units">"Current Unit Balance" then begin
          "No. Of Units":="Current Unit Balance";
          "Transfer Type":="Transfer Type"::Full;
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        end else begin
          "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";

          //Maxwell: Unit Transfer Charges BEGIN
          if (("To Fund Code" <> 'ARMMMF') and (Type <> Type::"Same Fund")) then begin
            "Fee Amount" := FundAdministration.GetFee("From Fund Code",Amount);
            "Fee Units" := FundAdministration.GetFundNounits("From Fund Code","Value Date","Fee Amount",TransactType::Redemption);
          end;
          //END

           Fund.Reset;
          if Fund.Get("From Fund Code") then ;
          NAVBAL:="Unit Balance after Redmption"*"Price Per Unit";
          if NAVBAL<Fund."Minimum Holding Balance" then begin
           "Transfer Type":="Transfer Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
          end
        end;
        "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);

        end;

        if "Transfer Type"="Transfer Type"::Full then begin
          //Maxwell: Added Fee Amount
          "Total Amount Payable":=Amount+"Accrued Dividend";
          "Net Amount Payable" := Amount+"Accrued Dividend"-"Fee Amount";
        end else begin
        "Total Amount Payable":=Amount+"Fee Amount";
        "Net Amount Payable" := Amount;
        end;
    end;
}

