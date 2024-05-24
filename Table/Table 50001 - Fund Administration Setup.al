table 50001 "Fund Administration Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Fund Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3;"Subscription Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4;"Redemption Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5;"Direct Debit Setup Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6;"Direct Debit Cancel Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7;"Online Indemnity Setup Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(8;"Online Indemnity Cancel Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(9;"Subscription Matching Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(10;"Fund Transfer Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(11;"Daily Distributable Income Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(12;"End of Quarter Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(13;"Subscription Schedule Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(14;"Unit Switch Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(15;"Commission No";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(16;"Redemption Schedule Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(17;"NIBS Webservice";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"External Registrar Webservice";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Redemption Recon Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(20;"Treasury Payment Limit";Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(21;"CX Verification Threshold";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Online Threshold";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Recon Nos";Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Holding Period";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Batch Fund Transfer Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(26;"Mutual Fund Nominee Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(27;"MF Distributable Income Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(28;"Mutual Fund Payment Nos";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(29;"External Webservice";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(30;"CRM Webservice";Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

