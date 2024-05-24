table 50122 "Temp Client Transactions"
{
    // version Rev-1.0

    DrillDownPageID = "Client Transactions";
    LookupPageID = "Client Transactions";

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Fund Sub Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Agent Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Price Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
        }
        field(9;"No of Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(10;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Subscription,Redemption,Fee';
            OptionMembers = Subscription,Redemption,Fee;
        }
        field(11;"Transaction Sub Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Initial,additional,Full Redemption,Part Redemption';
            OptionMembers = Initial,additional,"Full Redemption","Part Redemption";
        }
        field(12;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Employee No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employer;
        }
        field(15;Reversed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Reversed By Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Reversed Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(19;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(20;Currency;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(21;Narration;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Transaction No";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Transaction Sub Type 2";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Unit Transfer,Bank Transfer,Dividend ReInvestment,Ordinary Redemption,Dividend Payout,Bank Transaction,Account-to-Account Transfer';
            OptionMembers = "Unit Transfer","Bank Transfer","Dividend ReInvestment","Ordinary Redemption","Dividend Payout","Bank Transaction","Account-to-Account Transfer";
        }
        field(24;"Transaction Sub Type 3";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash Deposits & Bank Account Transfers,E-Payment,Direct Debit - Flutterwave,Direct debit - CMMS,Online Redemption,Manual Redemption,Card Redemption,Dividend,Unit Transfer,Unit Switch,Others,Direct Debit - GAPS,Direct Debit - Standing Instruction,Buy Back';
            OptionMembers = " ","Cash Deposits & Bank Account Transfers","E-Payment","Direct Debit - Flutterwave","Direct debit - CMMS","Online Redemption","Manual Redemption","Card Redemption",Dividend,"Unit Transfer","Unit Switch",Others,"Direct Debit - GAPS","Direct Debit - Standing Instruction","Buy Back";
        }
        field(25;"Transaction Source Document";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Subscription,Redemption,Fund Transfer,Dividend Reinvest,Unit Switch,Subscription Schedule';
            OptionMembers = " ",Subscription,Redemption,"Fund Transfer","Dividend Reinvest","Unit Switch","Subscription Schedule";
        }
        field(26;"Contribution Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,Employer,Principal,Interest';
            OptionMembers = Employee,Employer,Principal,Interest;
        }
        field(27;"Old Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Fund Group";Code[40])
        {
            CalcFormula = Lookup(Fund."Fund Group" WHERE ("Fund Code"=FIELD("Fund Code")));
            FieldClass = FlowField;
        }
        field(30;"On Hold";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(31;"Charges On Interest";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32;"Holding Due Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33;AmountChargedOn;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(34;"Net Amount On Hold";Decimal)
        {
            CalcFormula = Sum("Holding Period Transactions".Amount WHERE ("Transac Entry No"=FIELD("Entry No"),
                                                                          Posted=CONST(true)));
            FieldClass = FlowField;
        }
        field(35;"Transfer Type";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(36;"Send Reversed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37;Select;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38;Approved;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39;"Approved By";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(40;"Approved Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(41;Rejected;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(42;"Rejected By";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(43;"Rejected Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
        key(Key2;"Account No","Client ID","Value Date")
        {
            SumIndexFields = Amount;
        }
        key(Key3;"Agent Code","Value Date")
        {
        }
        key(Key4;"Value Date","Transaction Type")
        {
        }
        key(Key5;"Value Date","Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR('You are not allowed to delete a client transaction');
    end;

    trigger OnModify()
    begin
        //ERROR('You are not allowed to modify a client transaction');
    end;
}

