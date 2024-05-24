table 50028 "Posted Redemption"
{

    fields
    {
        field(1;No;Code[40])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
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
            TableRelation = Bank;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(12;"Creation Date";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Account No";Code[40])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
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
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                  if "No. Of Units"<0 then
                  Error('You cannot purchase Negative No. of Shares');
            end;
        }
        field(45;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
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
            TableRelation = Client;
        }
        field(47;"Fund Sub Account";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(81;"Redemption Status";Option)
        {
            DataClassification = ToBeClassified;
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
        field(88;"Fund Name";Text[50])
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
        field(97;"Redemption Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Part,Full';
            OptionMembers = "Part",Full;
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
        field(105;"Accrued Dividend Paid";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE ("Account No"=FIELD("Account No"),
                                                                                   "Fully Paid"=CONST(true),
                                                                                   "Transaction No"=FIELD(No)));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(106;"Total Amount Payable";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:4;
            Editable = true;
        }
        field(107;"Active Lien";Decimal)
        {
            CalcFormula = Sum("Account Liens".Amount WHERE ("Account No"=FIELD("Account No"),
                                                            status=CONST("Pending Verification")));
            DecimalPlaces = 2:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(108;"Has Schedule?";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(114;Comments;Text[250])
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
        field(131;"Reversal Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Pending Reversal,Approved,Rejected';
            OptionMembers = " ","Pending Reversal",Approved,Rejected;
        }
        field(132;"Date sent To Audit";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(133;"Reversal Document Link";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(134;"Rejection Reason";Text[150])
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
        field(147;"Bank Response Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Successful,Failed';
            OptionMembers = ,Successful,Failed;
        }
        field(148;"Bank Response Comment";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(150;"Treasury Batch";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(151;"Recon No";Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(152;"Buyback Subscription CaseNo";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(153;BoughtBack;Boolean)
        {
            DataClassification = ToBeClassified;
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
    }

    keys
    {
        key(Key1;No)
        {
        }
        key(Key2;"Recon No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundRec: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Validate("Fund Code",ClientAccount."Fund No");
        "Fund Sub Account":=ClientAccount."Fund Sub Account";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        "Street Address":=Client."Mailing Address";
        "Phone No":=Format(Client."Phone Number");
        "E-mail":=Client."E-Mail";
        "Agent Code":=Client."Account Executive Code";
    end;

    local procedure ValidateAmount()
    begin
        if Amount<>0 then begin
        "Price Per Unit":=FundAdministration.GetFundPrice("Fund Code","Value Date",TransactType::Redemption);
        "No. Of Units":=FundAdministration.GetFundNounits("Fund Code","Value Date",Amount,TransactType::Redemption);
        end
    end;
}

