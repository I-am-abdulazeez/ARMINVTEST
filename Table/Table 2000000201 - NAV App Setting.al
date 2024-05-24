table 2000000201 "NAV App Setting"
{
    // version NAVW113.01

    Caption = 'NAV App Setting';
    DataPerCompany = false;
    ReplicateData = false;

    fields
    {
        field(1;"App ID";Guid)
        {
            Caption = 'App ID';
        }
        field(2;"Allow HttpClient Requests";Boolean)
        {
            Caption = 'Allow HttpClient Requests';
        }
    }

    keys
    {
        key(Key1;"App ID")
        {
        }
    }

    fieldgroups
    {
    }
}
