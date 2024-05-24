table 50004 "Client Account"
{
    DrillDownPageID = "Client Accounts";
    LookupPageID = "Client Accounts";

    fields
    {
        field(1;"Account No";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(10;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;

            trigger OnValidate()
            begin

                //GenerateAccountNo;
                ValidateClient;
            end;
        }
        field(20;"Fund No";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Fund;

            trigger OnValidate()
            begin
                GenerateAccountNo
            end;
        }
        field(21;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31;"Bank Code";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;

            trigger OnValidate()
            begin
                ValidateClient;
            end;
        }
        field(32;"Bank Branch";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branches"."Branch Code" WHERE ("Bank Code"=FIELD("Bank Code"));
        }
        field(33;"Bank Account Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(34;"Bank Account Number";Code[30])
        {
            Caption = 'Bank Account Number';
            DataClassification = ToBeClassified;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidateClient;
            end;
        }
        field(100;"Online Indemnity Exist";Boolean)
        {
            CalcFormula = Exist("Online Indemnity Mandate" WHERE (Status=CONST("Verification Successful"),
                                                                  "Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Direct Debit Exist";Boolean)
        {
            CalcFormula = Exist("Direct Debit Mandate" WHERE (Status=CONST("Approved By Bank"),
                                                              "Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"E-Mail";Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                "E-Mail":=UpperCase("E-Mail");
            end;
        }
        field(103;"Reversal Approval";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'open,pending,approved,reject,reversed,completed';
            OptionMembers = open,pending,approved,reject,reversed,completed;
        }
        field(104;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Reversal Rejection Reason";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(200;"Last Modified By";Code[50])
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
        field(202;"KYC Tier";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "KYC Tier";

            trigger OnValidate()
            begin
                ValidateClient;
            end;
        }
        field(203;"Dividend Mandate";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payout,Reinvest';
            OptionMembers = " ",Payout,Reinvest;
        }
        field(204;"No of Units";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Value Date"=FIELD("Date Filter"),
                                                                         "Transaction Type"=FILTER(<>Dividend)));
            DecimalPlaces = 4:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(205;"Account Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Created,Active,In Active,Closed';
            OptionMembers = Created,Active,"In Active",Closed;
        }
        field(206;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(207;"Client Name";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(208;"Total Amount Invested";Decimal)
        {
            CalcFormula = Sum("Client Transactions".Amount WHERE ("Account No"=FIELD("Account No"),
                                                                  "Value Date"=FIELD("Date Filter"),
                                                                  "Transaction Type"=CONST(Subscription)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(209;"Total Amount Withdrawn";Decimal)
        {
            CalcFormula = Sum("Client Transactions".Amount WHERE ("Account No"=FIELD("Account No"),
                                                                  "Value Date"=FIELD("Date Filter"),
                                                                  "Transaction Type"=FILTER(Redemption|Fee)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(210;"MF Accrued Interest";Decimal)
        {
            CalcFormula = Sum("MF Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("Account No"),
                                                                                Processed=CONST(false),
                                                                                "Value Date"=FIELD("Date Filter"),
                                                                                "Fund Code"=FIELD("Fund No")));
            FieldClass = FlowField;
        }
        field(211;"Accrued Interest";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("Account No"),
                                                                                   "Fully Paid"=CONST(false),
                                                                                   "Value Date"=FIELD("Date Filter"),
                                                                                   "Fund Code"=FIELD("Fund No"),
                                                                                   Quarter=FIELD("Quarter Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(212;"Last update Source";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(213;"Employee Units";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Value Date"=FIELD("Date Filter"),
                                                                         "Contribution Type"=CONST(Employee)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(214;"Employer Units";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Value Date"=FIELD("Date Filter"),
                                                                         "Contribution Type"=CONST(Employer)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(215;"Split Dividend";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Split Dividend" then  begin
                  TestField("Account No To Split To");
                  TestField("Split Percentage");
                end
            end;
        }
        field(216;"Account No To Split To";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";
        }
        field(217;"Split Percentage";Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(218;"Institutional Active Fund";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validateinstitutional
            end;
        }
        field(219;"Institutional Active Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(220;"Old MembershipID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(221;"Fund Group";Code[40])
        {
            CalcFormula = Lookup(Fund."Fund Group" WHERE ("Fund Code"=FIELD("Fund No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(222;"Staff ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(223;"Old Account Number";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(224;"Pay Day";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(225;"New Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(226;"Agent Code";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager"."Agent Code";
        }
        field(227;"Referrer Membership ID";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(229;"Clients Referred";Integer)
        {
            CalcFormula = Count(Referral WHERE ("Referrer Membership ID"=FIELD("Client ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(232;"Total Amount on Hold";Decimal)
        {
            CalcFormula = Sum("Client Transactions".Amount WHERE ("Account No"=FIELD("Account No"),
                                                                  "Value Date"=FIELD("Date Filter"),
                                                                  "On Hold"=CONST(true)));
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(233;"Total Amount Settled";Decimal)
        {
            CalcFormula = Sum("Client Transactions".Amount WHERE ("Account No"=FIELD("Account No"),
                                                                  "On Hold"=CONST(false),
                                                                  "Transaction Type"=FILTER(Subscription)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(234;"Charges on Accrued Interest";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("Account No"),
                                                                                   "Penalty Charge"=FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(235;"Total withdrawn Amount On Hold";Decimal)
        {
            CalcFormula = Sum("Client Transactions".AmountChargedOn WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(236;"Net Amount On Hold";Decimal)
        {
            CalcFormula = Sum("Holding Period Transactions".Amount WHERE ("Client Account No"=FIELD("Account No"),
                                                                          Posted=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(237;"Net Accrued Interest";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(238;"Foreign Bank Account";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(239;"Swift Code";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(240;"Routing No";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(241;"Final Credit";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(242;"Benificiary Account Number";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(243;"Nominee Client";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(244;"Portfolio Code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(245;Goals;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(246;"Goal Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(247;"Goals Maturity Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(248;"Created Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(249;"Total Units Withdrawn";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Value Date"=FIELD("Date Filter"),
                                                                         "Transaction Type"=FILTER(Redemption|Fee)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(250;"Total Units Settled";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "On Hold"=CONST(false),
                                                                         "Transaction Type"=FILTER(Subscription)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(251;"Total Units on Hold";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Account No"=FIELD("Account No"),
                                                                         "Value Date"=FIELD("Date Filter"),
                                                                         "On Hold"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(252;"Quarter Filter";Code[20])
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
        key(Key1;"Account No")
        {
        }
        key(Key2;"Client ID")
        {
        }
        key(Key3;"Old MembershipID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Account No","Client ID","Fund No","Fund Sub Account")
        {
        }
    }

    trigger OnInsert()
    begin
        if ("Client ID"<>'') and ("Fund No"='') then
          "Account No":="Client ID";
        if "Account No"='' then "Account No":=Format(Time);
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    var
        ClientAccount: Record "Client Account";
        Client: Record Client;
        ClientAdministration: Codeunit "Client Administration";
        ClientAccount2: Record "Client Account";
        ClientAccountCopy: Record "Client Account";
        PayDayAccount: Code[10];

    local procedure GenerateAccountNo()
    var
        IsPayDay: Boolean;
    begin
        if ("Client ID"<>'') and ("Fund No"<>'') then begin
          IsPayDay := false; //CheckIfPayDayExists("Client ID");
          ClientAccount.Reset;
          ClientAccount.SetRange("Client ID","Client ID");
          ClientAccount.SetRange("Fund No","Fund No");
          ClientAccount.SetFilter("Fund Sub Account",'<>%1','');
          ClientAccount.SetFilter("Account No",'<>%1',"Account No");
          if not IsPayDay then begin
            ClientAccount.SetRange("Pay Day",false);
            if Goals then begin
              ClientAccount.SetRange(Goals, true);
              if (ClientAccount.FindLast) and (ClientAccount."Fund Sub Account" <> '99') then begin
                "Fund Sub Account":=IncStr(ClientAccount."Fund Sub Account");
              end else
              "Fund Sub Account":='90';
            end else begin
              if ClientAccount.FindLast then begin
                "Fund Sub Account":=IncStr(ClientAccount."Fund Sub Account");
              end else
              "Fund Sub Account":='01';
              if "Pay Day" then  begin
                "Fund Sub Account":='99';
                "Old Account Number":='PDY'+"Client ID";
              end;
            end;
              "Account No" := "Client ID"+'-'+"Fund No"+'-'+"Fund Sub Account";
          end
        end;
    end;

    local procedure ValidateClient()
    begin
        // IF Client.GET("Client ID") THEN BEGIN
        //  "Phone No.":=FORMAT(Client."Phone Number");
        //  "E-Mail":=Client."E-Mail";
        //  "Client Name":=Client.Name;
        //  "Old MembershipID":=Client."Membership ID";
        //  "Bank Code":=Client."Bank Code";
        //  "Bank Branch":=Client."Bank Branch";
        //  "Bank Account Number":=FORMAT(Client."Bank Account Number");
        //  "Bank Account Name":=Client."Bank Account Name";
        //  "KYC Tier":=ClientAdministration.GetTier("Client ID");
        //  //"Agent Code" := Client."Account Executive Code";
        //  IF "Referrer Membership ID" = '' THEN
        //  "Agent Code":= Client."Account Executive Code"
        // END
        if Client.Get("Client ID") then begin
          "Phone No.":=Format(Client."Phone Number");
          "E-Mail":=Client."E-Mail";
          "Client Name":=Client.Name;
          "Old MembershipID":=Client."Membership ID";
          if Client."Bank Code" <> '' then
          "Bank Code":=Client."Bank Code";
          if Client."Bank Branch" <> '' then
          "Bank Branch":=Client."Bank Branch";
          if Client."Bank Account Number" <> '' then
          "Bank Account Number":=Format(Client."Bank Account Number");
          if Client."Bank Account Name" <> '' then
          "Bank Account Name":=Client."Bank Account Name";
          //"KYC Tier":=ClientAdministration.GetTier("Client ID");
          //"Agent Code" := Client."Account Executive Code";
          if "Referrer Membership ID" = '' then
          "Agent Code":= Client."Account Executive Code"
        end
    end;

    local procedure Validateinstitutional()
    begin
        if "Institutional Active Fund" then begin
          CalcFields("Fund Group");
          if "Fund Group"='' then
            Error('All institutional Funds must have a fund group');
          ClientAccount.Reset;
          ClientAccount.SetRange("Client ID","Client ID");
          ClientAccount.SetFilter("Account No",'<>%1',"Account No");
          ClientAccount.SetRange("Fund Group","Fund Group");
          ClientAccount.SetRange("Institutional Active Fund",true);
            if ClientAccount.FindFirst then
              Error('This Client already has an active institutional Fund Account no %1. Please Deactivate first',ClientAccount."Account No");
          "Institutional Active Date":=Today;
        end else
        "Institutional Active Date":=Today;
    end;

    procedure CheckIfPayDayExists(ClientID: Code[40]): Boolean
    var
        ClientAcct: Record "Client Account";
        ClientAcct2: Record "Client Account";
    begin
        ClientAcct.Reset;
        ClientAcct.SetRange("Client ID", ClientID);
        ClientAcct.SetRange("Fund No", 'ARMMMF');
        ClientAcct.SetRange(Goals, true);
        if ClientAcct.Count = 9 then begin
          ClientAcct2.Reset;
          ClientAcct2.SetRange("Client ID", ClientID);
          ClientAcct2.SetRange("Fund No", 'ARMMMF');
          ClientAcct2.SetRange("Pay Day", true);
          if ClientAcct2.FindLast then
            exit(true)
          else
            exit(false);
        end else begin
          exit(false);
        end;
    end;
}

