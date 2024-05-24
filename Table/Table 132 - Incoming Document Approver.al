table 132 "Incoming Document Approver"
{
    // version NAVW113.02

    Caption = 'Incoming Document Approver';
    ReplicateData = false;

    fields
    {
        field(1;"User ID";Guid)
        {
            Caption = 'User ID';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
    }

    keys
    {
        key(Key1;"User ID")
        {
        }
    }

    fieldgroups
    {
    }

    [Scope('Personalization')]
    procedure SetIsApprover(var User: Record User;IsApprover: Boolean)
    var
        IncomingDocumentApprover: Record "Incoming Document Approver";
        WasApprover: Boolean;
    begin
        IncomingDocumentApprover.LockTable;
        WasApprover := IncomingDocumentApprover.Get(User."User Security ID");
        if WasApprover and not IsApprover then
          IncomingDocumentApprover.Delete;
        if not WasApprover and IsApprover then begin
          IncomingDocumentApprover."User ID" := User."User Security ID";
          IncomingDocumentApprover.Insert;
        end;
    end;
}
