table 50042 "Subscription & Redemp Fundware"
{

    fields
    {
        field(1;OrderNO;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2;PlanCode;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;FolioNo;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;TransactionType;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5;PostDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;TradeDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;TradeUnits;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;TradeNav;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;TradeAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;LoadAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11;SettledDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12;SettledAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13;BankID;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14;BankAccountNo;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15;OrderStatus;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(16;SwitchPlanCode;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(17;Data_Id;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Record Type";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(19;IsPreSettlement;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20;RefundAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21;TransferredtoIntegra;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22;DateTransferred;DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Entry No";Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(24;"Fund code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25;TransactionSubType;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Unit Transfer,Bank Transfer,Dividend ReInvestment,Ordinary Redemption,Dividend Payout,Bank Transaction,Account-to-Account Transfer';
            OptionMembers = "Unit Transfer","Bank Transfer","Dividend ReInvestment","Ordinary Redemption","Dividend Payout","Bank Transaction","Account-to-Account Transfer";
        }
        field(26;TransferType;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27;BuyBack;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Reversed Transaction";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Penalty Charge";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;PostDate,"Entry No",PlanCode)
        {
        }
    }

    fieldgroups
    {
    }
}

