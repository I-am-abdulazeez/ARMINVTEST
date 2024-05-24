table 2000000095 "API Webhook Subscription"
{
    // version NAVW113.01

    Caption = 'API Webhook Subscription';
    DataPerCompany = false;
    ReplicateData = false;

    fields
    {
        field(1;"Subscription Id";Text[150])
        {
            Caption = 'Subscription Id';
        }
        field(2;"Entity Publisher";Text[40])
        {
            Caption = 'Entity Publisher';
        }
        field(3;"Entity Group";Text[40])
        {
            Caption = 'Entity Group';
        }
        field(4;"Entity Version";Text[10])
        {
            Caption = 'Entity Version';
        }
        field(5;"Entity Set Name";Text[250])
        {
            Caption = 'Entity Set Name';
        }
        field(6;"Company Name";Text[30])
        {
            Caption = 'Company Name';
        }
        field(7;"Notification Url Blob";BLOB)
        {
            Caption = 'Notification Url Blob';
        }
        field(8;"User Id";Guid)
        {
            Caption = 'User Id';
            TableRelation = User."User Security ID";
        }
        field(9;"Last Modified Date Time";DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(10;"Client State";Text[250])
        {
            Caption = 'Client State';
        }
        field(11;"Expiration Date Time";DateTime)
        {
            Caption = 'Expiration Date Time';
        }
        field(12;"Resource Url Blob";BLOB)
        {
            Caption = 'Resource Url Blob';
        }
        field(13;"Notification Url Prefix";Text[250])
        {
            Caption = 'Notification Url Prefix';
        }
        field(14;"Source Table Id";Integer)
        {
            Caption = 'Source Table Id';
        }
    }

    keys
    {
        key(Key1;"Subscription Id")
        {
        }
        key(Key2;"Notification Url Prefix")
        {
        }
        key(Key3;"Source Table Id")
        {
        }
        key(Key4;"Expiration Date Time","Company Name")
        {
        }
    }

    fieldgroups
    {
    }
}

