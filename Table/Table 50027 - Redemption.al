table 50027 Redemption
{

    fields
    {
        field(1;"Transaction No";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            NotBlank = false;

            trigger OnValidate()
            begin
                if "Transaction No" <> xRec."Transaction No" then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Redemption Nos");
                   "No. Series" := '';
                end;
                "Redemption Status":="Redemption Status"::"ARM Registrar";
            end;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //ValidateAmount
                /*IF "Value Date"<TODAY THEN
                  ERROR('You cannot backdate a transaction');
                  */

            end;
        }
        field(3;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Pay Mode";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
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
            Editable = false;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UserMgt.LookupUserID("Created By");
            end;
        }
        field(12;"Creation Date";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13;"Account No";Code[40])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            Editable = true;
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
            DecimalPlaces = 2:4;
            Editable = true;

            trigger OnValidate()
            begin
                TestField("Value Date");
                TestField("Account No");
                if Amount<>0 then
                  ValidateAmount
                else begin
                  if "Redemption Type"="Redemption Type"::Full then
                    Error('Amount cannot be zero for full redemption');
                  "No. Of Units":=0;
                  "Price Per Unit":=0;
                  "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
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
            Editable = true;
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
        field(81;"Redemption Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Rejected,Verified,Posted,Customer Experience Verification';
            OptionMembers = Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";
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
        field(97;"Redemption Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Part,Full';
            OptionMembers = "Part",Full;

            trigger OnValidate()
            begin
                CalcFields("Active Lien");
                if "Redemption Type"="Redemption Type"::Part then begin
                    Amount:=0;
                    "No. Of Units":=0;
                end ;
                if "Redemption Type"="Redemption Type"::Full then
                  if "Active Lien">0 then
                    Error('There is a Lien on this account and thus you cannot do full redemption');


                ValidateAmount;
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
        field(100;"Online Indemnity Exist";Boolean)
        {
            CalcFormula = Exist("Online Indemnity Mandate" WHERE (Status=CONST("Verification Successful"),
                                                                  "Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Request Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Walk in,Online,Portfolio';
            OptionMembers = "Walk in",Online,Portfolio;
        }
        field(102;"Current Unit Balance";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No")));
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
        field(104;"Ongoing Customer Update";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Accrued Dividend";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("Account No"),
                                                                                   "Fully Paid"=CONST(false)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(106;"Total Amount Payable";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = false;
        }
        field(107;"Active Lien";Decimal)
        {
            CalcFormula = Sum("Account Liens".Amount WHERE ("Account No"=FIELD("Account No"),
                                                            status=CONST(Verified)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108;"Has Schedule?";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if not "Has Schedule?" then begin
                /*  IF FundTransactionManagement.CheckifredempLinesExist(Rec) THEN
                    ERROR('Kindly delete the schedule lines before you can uncheck this');*/
                end

            end;
        }
        field(109;"Ongoing Redemptions Units";Decimal)
        {
            FieldClass = Normal;
        }
        field(114;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(115;"Document Path";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(116;"Document Path2";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(117;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(118;"Sent to Treasury";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(119;"Date Sent to Treasury";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(120;"Time Sent to Treasury";Time)
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
        field(124;"Processed By Bank";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(125;"Date Processed By Bank";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(126;"Time Processed By Bank";Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(127;"Payment Status";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(128;"Payment Description";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(129;Reconciled;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(130;"Reconciled Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(138;"Registrar Control ID";Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(139;"Registrar Comments";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(140;SignatureStatus;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(141;AdditionalComments;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(142;"OLD Account No";Code[40])
        {
            CalcFormula = Lookup("Client Account"."Old Account Number" WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(143;"Fee Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(145;"Fee Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(146;"Net Amount Payable";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(151;"Recon No";Code[15])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Recon No" <> xRec."Recon No" then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Recon Nos");
                   "No. Series" := '';
                end;
            end;
        }
        field(180;"Bank Sort Code";Code[30])
        {
            CalcFormula = Lookup(Bank."Sort Code" WHERE (code=FIELD("Bank Code")));
            FieldClass = FlowField;
        }
        field(181;"Bank Name";Text[100])
        {
            CalcFormula = Lookup(Bank.Name WHERE (code=FIELD("Bank Code")));
            FieldClass = FlowField;
        }
        field(182;"Charges On Accrued Interest";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(183;"Interest After Redemption";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(184;"For Verification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(185;"Charge Units";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(186;"Date And Time Posted";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(187;"Quarter Filter";Code[20])
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
    }

    keys
    {
        key(Key1;"Transaction No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Transaction No" = '' then begin
             FundAdministrationSetup.Get;
             FundAdministrationSetup.TestField(FundAdministrationSetup."Redemption Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Redemption Nos",xRec."No. Series",0D,"Transaction No","No. Series");
          end;

         //Maxwell: To generate Recon No
        if "Recon No" = '' then begin
          FundAdministrationSetup.Get;
          FundAdministrationSetup.TestField(FundAdministrationSetup."Recon Nos");
          NoSeriesMgt.InitSeries(FundAdministrationSetup."Recon Nos",xRec."No. Series",0D,"Recon No","No. Series");
        end;

        if "Value Date"=0D then
           "Value Date":=Today;
        "Transaction Date":=Today;
        "Created By":=UserId;
        "Creation Date":=CurrentDateTime;
        FundAdministration.InsertRedemptionTracker("Redemption Status","Transaction No");
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
        Lienunits: Decimal;
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        UserMgt: Codeunit "User Management";
        Fund: Record Fund;

    local procedure Validateaccount()
    begin
        if CheckIftodaysredemptionexist then
          Message('A redemption has been done today for this client Account. Please check to ensure that this is not a duplicate');
        ClientAdministration.ValidateKYC("Account No");

        if ClientAccount.Get("Account No") then begin
        "Client ID":=ClientAccount."Client ID";
        if ClientAdministration.CheckifResctrictionExists("Account No",1,Restrictiontype::"Restrict Redemption") then
          Error('There is a caution on this account %1 that restricts redemption', "Account No");
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        if Client.Get("Client ID") then
        "Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
         "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
        "Bank Code":=ClientAccount."Bank Code";
        "Bank Account No":=ClientAccount."Bank Account Number";
        "Bank Account Name":=ClientAccount."Bank Account Name";
        end else begin
        "Client ID":='';
        "Fund Code":='';
        "Fund Sub Account":='';
        "Client Name":='';
        "Street Address":='';
        "Phone No":='';
        "E-mail":='';
        "Agent Code":='';
        "Redemption Type":="Redemption Type"::Part;
        Amount:=0;
        "No. Of Units":=0;
        "Bank Code":='';
        "Bank Account No":='';
        "Bank Account Name":='';
        end;
        CalcFields("Current Unit Balance");
    end;

    local procedure ValidateAmountold()
    var
        NAVBal: Decimal;
    begin
        /*("Current Unit Balance","Accrued Dividend","Active Lien");
        
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Redemption);
        IF "Redemption Type"="Redemption Type"::Full THEN
          Amount:="Current Unit Balance"*"Price Per Unit";
        IF Amount<>0 THEN BEGIN
        
        "No. Of Units":=FundAdministration.GetFundNounits("Fund Code","Value Date",Amount,TransactType::Redemption);
        
        IF "Active Lien">0 THEN BEGIN
          Lienunits:=FundAdministration.GetFundNounits("Fund Code","Value Date","Active Lien",TransactType::Redemption);
          IF "No. Of Units">("Current Unit Balance"-Lienunits) THEN BEGIN
            "No. Of Units":="Current Unit Balance"-Lienunits;
            MESSAGE('There is a Lien on the account that limits the maximum you can redeem');
          END;
        END;
        
        
        IF ("No. Of Units">=ROUND("Current Unit Balance",0.0001,'=') )OR ("Redemption Type"="Redemption Type"::Full)THEN BEGIN
          IF ("No. Of Units">ROUND("Current Unit Balance",0.0001,'='))  THEN
            ERROR('The current account balance is less than the requested Amount for client account %1. Please check',"Account No");
        
          "Redemption Type":="Redemption Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        END ELSE BEGIN
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
          Fund.RESET;
          IF Fund.GET("Fund Code") THEN ;
          NAVBal:="Unit Balance after Redmption"*"Price Per Unit";
          IF (NAVBal<Fund."Minimum Holding Balance") AND ("Fund Sub Account"<>'99') THEN BEGIN
           "Redemption Type":="Redemption Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
          END
        END
        END;
        "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        
        IF "Redemption Type"="Redemption Type"::Full THEN
          "Total Amount Payable":=Amount+"Accrued Dividend"
        ELSE
        "Total Amount Payable":=Amount;
        */

    end;

    local procedure ValidateUnitsold()
    var
        NAVBal: Decimal;
    begin
        /*CALCFIELDS("Current Unit Balance","Accrued Dividend","Active Lien");
        
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Redemption);
        IF "Redemption Type"="Redemption Type"::Full THEN
          "No. Of Units":="Current Unit Balance";
        
        IF "No. Of Units"<>0 THEN BEGIN
        IF "Active Lien">0 THEN BEGIN
          Lienunits:=FundAdministration.GetFundNounits("Fund Code","Value Date","Active Lien",TransactType::Redemption);
          IF "No. Of Units">("Current Unit Balance"-Lienunits) THEN BEGIN
            "No. Of Units":="Current Unit Balance"-Lienunits;
            MESSAGE('There is a Lien on the account that limits the maximum you can redeem');
            END;
        END;
        
        IF ("No. Of Units">="Current Unit Balance") OR ("Redemption Type"="Redemption Type"::Full)THEN BEGIN
          IF ("No. Of Units">"Current Unit Balance")  THEN
            ERROR('The current account balance is less than the requested Amount. Please check');
        
          "Redemption Type":="Redemption Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
        END ELSE BEGIN
          Amount:="No. Of Units"*"Price Per Unit";
          "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
           Fund.RESET;
          IF Fund.GET("Fund Code") THEN ;
          NAVBal:="Unit Balance after Redmption"*"Price Per Unit";
          IF (NAVBal<Fund."Minimum Holding Balance") AND ("Fund Sub Account"<>'99') THEN BEGIN
           "Redemption Type":="Redemption Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
          END
        END
        END;
        "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        IF "Redemption Type"="Redemption Type"::Full THEN
          "Total Amount Payable":=Amount+"Accrued Dividend"
        ELSE
        "Total Amount Payable":=Amount;
        */

    end;

    local procedure CheckIftodaysredemptionexist(): Boolean
    begin
        Redemption.Reset;
        Redemption.SetRange("Account No","Account No");
        Redemption.SetRange("Value Date","Value Date");
        Redemption.SetFilter("Redemption Status",'<>%1',Redemption."Redemption Status"::Rejected);
        if Redemption.FindFirst then
          exit( true);
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Account No","Account No");
        PostedRedemption.SetRange("Value Date","Value Date");
        if PostedRedemption.FindFirst then
          exit( true)
        else
          exit(false);
    end;

    local procedure ValidateAmount()
    var
        NAVBal: Decimal;
        AvailableInterest: Decimal;
    begin
        CalcFields("Current Unit Balance","Accrued Dividend","Active Lien");
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Redemption);
        if "Redemption Type"="Redemption Type"::Full then
          Amount:="Current Unit Balance"*"Price Per Unit";

        if Amount<>0 then begin
          "No. Of Units":=FundAdministration.GetFundNounits("Fund Code","Value Date",Amount,TransactType::Redemption);
          if "Active Lien">0 then begin
            Lienunits:=FundAdministration.GetFundNounits("Fund Code","Value Date","Active Lien",TransactType::Redemption);
            if "No. Of Units">("Current Unit Balance"-Lienunits) then begin
              "No. Of Units":="Current Unit Balance"-Lienunits;
              Message('There is a Lien on the account that limits the maximum you can redeem');
            end;
          end;
        //Charges on interest begin
          "Charges On Accrued Interest" := 0; //FundAdministration.GetMutualFundPenaltyCharge("Fund Code", "No. Of Units", "Account No", "Transaction No","Value Date");
          "Charge Units" := 0;//FundAdministration.GetFundNounits("Fund Code","Value Date","Charges On Accrued Interest",TransactType::Redemption);

          if ("No. Of Units">=Round("Current Unit Balance",0.0001,'=') )or ("Redemption Type"="Redemption Type"::Full)then begin
            if (Abs("No. Of Units"-Round("Current Unit Balance",0.0001,'='))>0.05)  then
              Error('The current account balance is less than the requested Amount for client account %1. Please check',"Account No");

            "Redemption Type":="Redemption Type"::Full;
            "No. Of Units":="Current Unit Balance";
            Amount:="Current Unit Balance"*"Price Per Unit";
            "Unit Balance after Redmption":=0;
          end else begin
              "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
            Fund.Reset;
            if Fund.Get("Fund Code") then ;
            NAVBal:="Unit Balance after Redmption"*"Price Per Unit";
            if (NAVBal<Fund."Minimum Holding Balance") and ("Fund Sub Account"<>'99') then begin
              "Redemption Type":="Redemption Type"::Full;
            "No. Of Units":="Current Unit Balance";
            Amount:="Current Unit Balance"*"Price Per Unit";
            "Unit Balance after Redmption":=0;
            end
          end
        end;

        "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        "Fee Amount":=FundAdministration.GetFee("Fund Code",Amount);
        "Fee Units":=FundAdministration.GetFundNounits("Fund Code","Value Date","Fee Amount",TransactType::Redemption);

        if "Fund Code" = 'ARMMMF' then
          "Interest After Redemption" := "Accrued Dividend" - "Charges On Accrued Interest"
        else
          "Interest After Redemption" := 0;

        if "Redemption Type"="Redemption Type"::Full then begin
          if "Fund Code" = 'ARMMMF' then begin
            "Interest After Redemption" := 0;
            "Net Amount Payable":=Amount+"Accrued Dividend"-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount+"Accrued Dividend";
          end else begin
            "Interest After Redemption" := 0;
            "Net Amount Payable":=Amount-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount;
          end;
        end else begin
          if "Fund Code" = 'ARMMMF' then begin
            "Total Amount Payable":=Amount+"Fee Amount";
            "Net Amount Payable":="Total Amount Payable"-"Fee Amount";
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";
          end else begin
            "Total Amount Payable":=Amount+"Fee Amount"+"Charges On Accrued Interest";
            "Net Amount Payable":="Total Amount Payable"-"Fee Amount"-"Charges On Accrued Interest";
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units"-"Charge Units";
          end;
          if "Unit Balance after Redmption"<0 then begin
            "Redemption Type":="Redemption Type"::Full;
            "No. Of Units":="Current Unit Balance";
            Amount:="Current Unit Balance"*"Price Per Unit";
            "Unit Balance after Redmption":=0;
           "Interest After Redemption" := 0;
           if "Fund Code" = 'ARMMMF' then begin
            "Net Amount Payable":=Amount+"Accrued Dividend"-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount+"Accrued Dividend";
           end else begin
            "Net Amount Payable":=Amount-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount;
           end;
          end;
        end
    end;

    local procedure ValidateUnits()
    var
        NAVBal: Decimal;
        AvailableInterest: Decimal;
    begin
        CalcFields("Current Unit Balance","Accrued Dividend","Active Lien");
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Redemption);
        if "Redemption Type"="Redemption Type"::Full then
          "No. Of Units":="Current Unit Balance";

        //Charges on interest begin
          "Charges On Accrued Interest" := 0; //FundAdministration.GetMutualFundPenaltyCharge("Fund Code", "No. Of Units", "Account No", "Transaction No","Value Date");
          "Charge Units" := 0; //FundAdministration.GetFundNounits("Fund Code","Value Date","Charges On Accrued Interest",TransactType::Redemption);

        if "No. Of Units"<>0 then begin
          if "Active Lien">0 then begin
            Lienunits:=FundAdministration.GetFundNounits("Fund Code","Value Date","Active Lien",TransactType::Redemption);
            if "No. Of Units">("Current Unit Balance"-Lienunits) then begin
              "No. Of Units":="Current Unit Balance"-Lienunits;
              Message('There is a Lien on the account that limits the maximum you can redeem');
              end;
          end;

          if ("No. Of Units">=Round("Current Unit Balance",0.0001,'=') )or ("Redemption Type"="Redemption Type"::Full)then begin
            if (Abs("No. Of Units"-Round("Current Unit Balance",0.0001,'='))>0.05)  then
              Error('The current account balance is less than the requested Amount for client account %1. Please check',"Account No");

            "Redemption Type":="Redemption Type"::Full;
            "No. Of Units":="Current Unit Balance";
            Amount:="Current Unit Balance"*"Price Per Unit";
            "Unit Balance after Redmption":=0;
          end else begin
            Amount:="No. Of Units"*"Price Per Unit";
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
             Fund.Reset;
            if Fund.Get("Fund Code") then ;
            NAVBal:="Unit Balance after Redmption"*"Price Per Unit";
            if (NAVBal<Fund."Minimum Holding Balance") and ("Fund Sub Account"<>'99') then begin
              "Redemption Type":="Redemption Type"::Full;
              "No. Of Units":="Current Unit Balance";
              Amount:="Current Unit Balance"*"Price Per Unit";
              "Unit Balance after Redmption":=0;
            end
          end
        end;

        "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units";
        "Fee Amount":=FundAdministration.GetFee("Fund Code",Amount);
        "Fee Units":=FundAdministration.GetFundNounits("Fund Code","Value Date","Fee Amount",TransactType::Redemption);

        if "Fund Code" = 'ARMMMF' then
          "Interest After Redemption" := "Accrued Dividend" - "Charges On Accrued Interest"
        else
          "Interest After Redemption" := 0;

        if "Redemption Type"="Redemption Type"::Full then begin
           if "Fund Code" = 'ARMMMF' then begin
            "Interest After Redemption" := 0;
            "Net Amount Payable":=Amount+"Accrued Dividend"-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount+"Accrued Dividend";
          end else begin
            "Interest After Redemption" := 0;
            "Net Amount Payable":=Amount-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount;
          end;
        end else begin
          if "Fund Code" = 'ARMMMF' then begin
            "Total Amount Payable":=Amount+"Fee Amount";
            "Net Amount Payable":="Total Amount Payable"-"Fee Amount";
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";
          end else begin
            "Total Amount Payable":=Amount+"Fee Amount"+"Charges On Accrued Interest";
            "Net Amount Payable":="Total Amount Payable"-"Fee Amount"-"Charges On Accrued Interest";
            "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units"-"Charge Units";
          end;
          if "Unit Balance after Redmption"<0 then begin
            "Redemption Type":="Redemption Type"::Full;
          "No. Of Units":="Current Unit Balance";
          Amount:="Current Unit Balance"*"Price Per Unit";
          "Unit Balance after Redmption":=0;
          "Interest After Redemption" := 0;
          if "Fund Code" = 'ARMMMF' then begin
            "Net Amount Payable":=Amount+"Accrued Dividend"-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount+"Accrued Dividend";
           end else begin
            "Net Amount Payable":=Amount-"Fee Amount"-"Charges On Accrued Interest";
            "Total Amount Payable":=Amount;
           end;
          end
        end
    end;
}

