table 50126 "MF Payment Lines"
{
    // version MFD-1.0

    DrillDownPageID = "EOQ Lines";
    LookupPageID = "EOQ Lines";

    fields
    {
        field(1;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "EOQ Header";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Client Account";
        }
        field(4;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Client;
        }
        field(5;"Client Name";Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Dividend Mandate";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payout,Reinvest';
            OptionMembers = " ",Payout,Reinvest;
        }
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Bank Branch";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Bank Account";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Dividend Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(12;Verified;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"DateTime Verified";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"DateTime Processed";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16;Split;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Total Dividend Earned";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(18;"Split to Account";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Split Percentage";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Tax Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Tax Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"MF Income Batch No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(142;"OLD Account No";Code[40])
        {
            CalcFormula = Lookup("Client Account"."Old Account Number" WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(143;"OLD Membership No";Code[40])
        {
            CalcFormula = Lookup("Client Account"."Old MembershipID" WHERE ("Account No"=FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(144;"Portfolio Code";Code[20])
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
}

