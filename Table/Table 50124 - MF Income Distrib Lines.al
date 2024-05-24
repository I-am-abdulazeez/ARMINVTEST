table 50124 "MF Income Distrib Lines"
{
    // version MFD-1.0

    DrillDownPageID = "Daily Income distrib Lines";
    LookupPageID = "Daily Income distrib Lines";

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";
        }
        field(4;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"No of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;"Income Per unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:12;
        }
        field(8;"Income accrued";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(9;"Client Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Fully Paid";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Payment Mode";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Full Redemption,Payout,Full Transfer';
            OptionMembers = " ","Full Redemption",Payout,"Full Transfer";
        }
        field(12;"Payment Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Transaction No";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15;Transferred;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Transferred from account";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Transfer Ref no";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"inserted on update";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Penalty Charge";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Charges No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Nominee Client";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Portfolio Code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(23;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Date Processed";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;No,"Line No")
        {
        }
        key(Key2;"Account No","Value Date")
        {
            SumIndexFields = "Income accrued";
        }
        key(Key3;"Payment Date","Fully Paid","Fund Code")
        {
        }
    }

    fieldgroups
    {
    }
}

