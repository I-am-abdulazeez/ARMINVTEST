table 50065 "Notification Setups"
{

    fields
    {
        field(1;EntryNo;Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Redemption CX Verification,

Redemeption ARMRegistrar,

Rejected Redemption,

Posted Redemption,

Received Subscription,

Posted Subscription,

Unmatched Subscription,

Unit Transfer ARMRegistrar,

Rejected Unit Transfer,

Posted Unit Transfer,

DD ARMRegistrar,

DD logged at Bank,

DD Approved by Bank,

DD Rejected by Bank,

DD Cancelled,

Online Indemnity at ARM Registrar,

Verified Online Indemnity,

Rejected Online Indemnity,

Redemption Schedule Confirmation,

Posted Redemption Schedule,

Rejected Redemption Schedule,

Subscription Schedule Confirmation,

Posted Subscription Schedule,

Rejected Subscription Schedule';
            OptionMembers = " ","Redemption CX Verification","

RMRegistrar","

mption","

tion","

cription","

iption","

scription","

 ARMRegistrar","

 Transfer","

ransfer","

ar","

Bank","

y Bank","

y Bank","""

,""

ity at ARM Registrar"",""

ne Indemnity"",""

ne Indemnity"",""

hedule Confirmation"",""

tion Schedule"",""

mption Schedule"",""

Schedule Confirmation"",""

iption Schedule"",""

cription Schedule""";
        }
        field(3;"Send to";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4;CC;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;BCC;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;EntryNo)
        {
        }
    }

    fieldgroups
    {
    }
}

