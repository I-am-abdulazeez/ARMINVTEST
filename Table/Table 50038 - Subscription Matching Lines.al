table 50038 "Subscription Matching Lines"
{
    DrillDownPageID = "Subscription Matching Lines";
    LookupPageID = "Subscription Matching Lines";

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Subscription Matching header";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;Reference;Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;Narration;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Debit Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Credit Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;Channel;Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10;Matched;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Value Date");
                TestField("Account No");
                //TESTFIELD("Credit Amount");
                TestField("Client ID");
                Amount:="Credit Amount";
                if Matched then
                  TestField("Non Client Transaction",false);

                "Matched By":=UserId;
            end;
        }
        field(11;"Account No";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Fund Code"=FILTER(<>'')) "Client Account" WHERE ("Fund No"=FIELD("Fund Code"))
                            ELSE "Client Account";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(12;"Non Client Transaction";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Non Client Transaction" then
                  Validate("Account No",'');
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
        field(36;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Selected By":=UserId;
            end;
        }
        field(45;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;
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
        field(96;"Selected By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(97;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(98;"Subscription No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(99;Rejected;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(100;"Rejection Comments";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(101;"Rejected by";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(102;Reconciled;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(103;"Reconciled Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(104;"Assigned User";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(105;"Assigned By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(106;"Date Time Assigned";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(107;"Matched By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(108;"Auto Matched";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(109;TransactionReference;Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(110;"Bank code";Code[40])
        {
            CalcFormula = Lookup("Subscription Matching header"."Bank Code" WHERE (No=FIELD("Header No")));
            FieldClass = FlowField;
        }
        field(111;"Header Transaction  Date";Date)
        {
            CalcFormula = Lookup("Subscription Matching header"."Transaction Date" WHERE (No=FIELD("Header No")));
            FieldClass = FlowField;
        }
        field(118;"Payment Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash Deposits & Bank Account Transfers,Direct debit - CMMS,Direct Debit - Flutterwave,Direct Debit - GAPS,Direct Debit - Standing Instruction,E-Payment,Dividend,Buy Back,Others';
            OptionMembers = " ","Cash Deposits & Bank Account Transfers","Direct debit - CMMS","Direct Debit - Flutterwave","Direct Debit - GAPS","Direct Debit - Standing Instruction","E-Payment",Dividend,"Buy Back",Others;
        }
        field(119;"Creation Date";DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Creation Date" := CurrentDateTime;
            end;
        }
        field(120;"Automatch Reference";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No","Line No","Automatch Reference")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creation Date" := CurrentDateTime;
        if "Automatch Reference" <> '' then begin
        transREF := "Automatch Reference";
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange(TransactionReference,transREF);
        if SubscriptionMatchingLines.FindSet then Error('already exist');
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Automatch Reference",transREF);
        if SubscriptionMatchingLines.FindSet then Error('already exist');





        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange(TransactionReference,transREF);
        if SubscriptionMatchingLines.FindSet then Error('already exist');
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Automatch Reference",transREF);
        if SubscriptionMatchingLines.FindSet then Error('already exist');
        end
    end;

    trigger OnModify()
    begin
        if "Automatch Reference" <> '' then begin
          transREF := "Automatch Reference";
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange(TransactionReference,TransactionReference);
        SubscriptionMatchingLines.SetFilter("Header No",'<>%1',"Header No");
        SubscriptionMatchingLines.SetFilter("Line No",'<>%1',"Line No");
        if SubscriptionMatchingLines.FindSet then Error('already exist');
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Automatch Reference",TransactionReference);
        SubscriptionMatchingLines.SetFilter("Header No",'<>%1',"Header No");
        SubscriptionMatchingLines.SetFilter("Line No",'<>%1',"Line No");
        if SubscriptionMatchingLines.FindSet then Error('already exist');





        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange(TransactionReference,"Automatch Reference");
        SubscriptionMatchingLines.SetFilter("Header No",'<>%1',"Header No");
        SubscriptionMatchingLines.SetFilter("Line No",'<>%1',"Line No");
        if SubscriptionMatchingLines.FindSet then Error('02');
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Automatch Reference","Automatch Reference");
        SubscriptionMatchingLines.SetFilter("Header No",'<>%1',"Header No");
        SubscriptionMatchingLines.SetFilter("Line No",'<>%1',"Line No");
        if SubscriptionMatchingLines.FindSet then Error('02');
          end
    end;

    var
        ClientAccount: Record "Client Account";
        Client: Record Client;
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        transREF: Text[200];

    local procedure Validateaccount()
    begin
        if  ClientAccount.Get("Account No") then begin
        "Client ID":=ClientAccount."Client ID";
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        Matched:=true;
        "Non Client Transaction":=false;
        end
        else begin
        Matched:=false;
        "Client ID":='';
        "Client Name":='';
        end;
    end;
}

