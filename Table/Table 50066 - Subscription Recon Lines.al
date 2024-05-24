table 50066 "Subscription Recon Lines"
{
    DrillDownPageID = 52132266;
    LookupPageID = 52132266;

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
        field(5;Reference;Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6;Narration;Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ReplaceString (Narration,' ','',NarrationWithoutSpace);
            end;
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
            end;
        }
        field(11;"Account No";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Fund Code"=FILTER(<>'')) "Client Account" WHERE ("Fund No"=FIELD("Fund Code"))
                            ELSE "Client Account";

            trigger OnValidate()
            begin
                Validateaccount;
                Validate(Narration );
            end;
        }
        field(12;"Non Client Transaction";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Non Client Transaction" then
                  TestField(Matched,false);
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
        field(104;"Manual Reference";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(110;"Bank code";Code[40])
        {
            CalcFormula = Lookup("Subscription Matching header"."Bank Code" WHERE (No=FIELD("Header No")));
            FieldClass = FlowField;
        }
        field(111;"Header Value Date";Date)
        {
            CalcFormula = Lookup("Subscription Matching header"."Value Date" WHERE (No=FIELD("Header No")));
            FieldClass = FlowField;
        }
        field(112;NarrationWithoutSpace;Text[250])
        {
            DataClassification = ToBeClassified;
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

    trigger OnInsert()
    begin
        Validate (Narration);
    end;

    trigger OnModify()
    begin
        Validate(Narration);
    end;

    var
        ClientAccount: Record "Client Account";
        Client: Record Client;

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        Matched:=true;
    end;

    procedure ReplaceString(String: Text;FindWhat: Text[500];ReplaceWith: Text[500];var NewString: Text)
    begin
        while StrPos(String,FindWhat) > 0 do
          String := DelStr(String,StrPos(String,FindWhat)) + ReplaceWith + CopyStr(String,StrPos(String,FindWhat) + StrLen(FindWhat));
        NewString := String;

        //MESSAGE('tHE sTRING %',NewString);
    end;
}

