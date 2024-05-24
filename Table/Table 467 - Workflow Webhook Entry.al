table 467 "Workflow Webhook Entry"
{
    // version NAVW113.02

    Caption = 'Workflow Webhook Entry';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(3;"Workflow Step Instance ID";Guid)
        {
            Caption = 'Workflow Step Instance ID';
        }
        field(5;"Initiated By User ID";Code[50])
        {
            Caption = 'Initiated By User ID';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("Initiated By User ID");
            end;
        }
        field(7;Response;Option)
        {
            Caption = 'Response';
            OptionCaption = 'NotExpected,Pending,Cancel,Continue,Reject';
            OptionMembers = NotExpected,Pending,Cancel,Continue,Reject;
        }
        field(8;"Response Argument";Guid)
        {
            Caption = 'Response Argument';
        }
        field(9;"Date-Time Initiated";DateTime)
        {
            Caption = 'Date-Time Initiated';
        }
        field(11;"Last Date-Time Modified";DateTime)
        {
            Caption = 'Last Date-Time Modified';
        }
        field(13;"Last Modified By User ID";Code[50])
        {
            Caption = 'Last Modified By User ID';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnLookup()
            begin
                UserMgt.LookupUserID("Last Modified By User ID");
            end;
        }
        field(15;"Data ID";Guid)
        {
            Caption = 'Data ID';
        }
        field(17;"Record ID";RecordID)
        {
            Caption = 'Record ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Workflow Step Instance ID")
        {
        }
        key(Key3;"Data ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Date-Time Modified" := CreateDateTime(Today,Time);
        "Last Modified By User ID" := UserId;
    end;

    var
        UserMgt: Codeunit "User Management";
        PageManagement: Codeunit "Page Management";

    [Scope('Personalization')]
    procedure SetDefaultFilter(var WorkflowWebhookEntry: Record "Workflow Webhook Entry")
    var
        UserSetup: Record "User Setup";
        IsApprovalAdmin: Boolean;
        ResponseUserID: Code[50];
    begin
        IsApprovalAdmin := false;

        if UserSetup.Get(UserId) then begin
          if UserSetup."Approval Administrator" then
            IsApprovalAdmin := true;
        end;

        Clear(WorkflowWebhookEntry);
        WorkflowWebhookEntry.Init;
        WorkflowWebhookEntry.SetRange(Response,WorkflowWebhookEntry.Response::Pending);

        if not IsApprovalAdmin then begin
          if WorkflowWebhookEntry.FindSet then
            repeat
              if WorkflowWebhookEntry."Initiated By User ID" = UserId then
                WorkflowWebhookEntry.Mark(true)
              else
                // Look to see if the entry is awaiting a response from the active user
                if GetResponseUserIdFromArgument(WorkflowWebhookEntry."Response Argument",ResponseUserID) then
                  if ResponseUserID = UserId then
                    WorkflowWebhookEntry.Mark(true);
            until WorkflowWebhookEntry.Next = 0;
          WorkflowWebhookEntry.MarkedOnly(true);
        end;
    end;

    local procedure GetResponseUserIdFromArgument(Argument: Guid;var ResponseUserID: Code[50]): Boolean
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        Clear(ResponseUserID);

        if not IsNullGuid(Argument) then begin
          WorkflowStepArgument.Init;
          if WorkflowStepArgument.Get(Argument) then
            case WorkflowStepArgument."Response Type" of
              WorkflowStepArgument."Response Type"::"User ID":
                begin
                  ResponseUserID := WorkflowStepArgument."Response User ID";
                  exit(true);
                end;
            end;
        end;

        exit(false);
    end;

    [Scope('Personalization')]
    procedure ShowRecord()
    var
        RecRef: RecordRef;
    begin
        // When called on a Workflow Webhook Entry row, finds the associated parent record and navigates to
        // the appropriate page to show that record.
        // Used by the Flow Entries page. Based on code from the Approval Entries page/Approval Entry table.
        if not RecRef.Get("Record ID") then
          exit;
        RecRef.SetRecFilter;
        PageManagement.PageRun(RecRef);
    end;
}

