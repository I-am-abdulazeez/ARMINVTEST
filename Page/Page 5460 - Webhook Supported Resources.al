page 5460 "Webhook Supported Resources"
{
    // version NAVW113.02

    APIGroup = 'runtime';
    APIPublisher = 'microsoft';
    Caption = 'webhookSupportedResources', Locked=true;
    DelayedInsert = true;
    Editable = false;
    EntityName = 'webhookSupportedResource';
    EntitySetName = 'webhookSupportedResources';
    ODataKeyFields = Name;
    PageType = API;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(resource;Name)
                {
                    ApplicationArea = All;
                    Caption = 'resource', Locked=true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        ApiWebhookEntity: Record "Api Webhook Entity";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        View: Text;
        ResourceUri: Text;
        I: Integer;
    begin
        if Initialized then
          exit(true);

        if not GraphMgtGeneralTools.IsApiSubscriptionEnabled then begin
          Initialized := true;
          exit(false);
        end;

        View := GetView;
        ApiWebhookEntity.SetRange("Object Type",ApiWebhookEntity."Object Type"::Page);
        ApiWebhookEntity.SetRange("Table Temporary",false);
        if not ApiWebhookEntity.FindSet then
          exit(false);

        repeat
          if not IsSystemTable(ApiWebhookEntity) then
            if not IsCompositeKey(ApiWebhookEntity) then begin
              ResourceUri := GetResourceUri(ApiWebhookEntity);
              if StrLen(ResourceUri) <= MaxStrLen(Name) then begin
                I += 1;
                ID := I;
                Name := CopyStr(ResourceUri,1,MaxStrLen(Name));
                Insert;
              end;
            end;
        until ApiWebhookEntity.Next = 0;

        SetView(View);
        FindFirst;
        Initialized := true;
        exit(true);
    end;

    var
        Initialized: Boolean;

    local procedure IsSystemTable(var ApiWebhookEntity: Record "Api Webhook Entity"): Boolean
    begin
        exit(ApiWebhookEntity."Table No." > 2000000000);
    end;

    local procedure IsCompositeKey(var ApiWebhookEntity: Record "Api Webhook Entity"): Boolean
    begin
        exit(StrPos(ApiWebhookEntity."Key Fields",',') > 0);
    end;

    local procedure GetResourceUri(var ApiWebhookEntity: Record "Api Webhook Entity"): Text
    begin
        if (ApiWebhookEntity.Publisher <> '') and (ApiWebhookEntity.Group <> '') then
          exit(StrSubstNo('%1/%2/%3/%4',
              ApiWebhookEntity.Publisher,ApiWebhookEntity.Group,ApiWebhookEntity.Version,ApiWebhookEntity.Name));
        exit(StrSubstNo('%1/%2',ApiWebhookEntity.Version,ApiWebhookEntity.Name));
    end;
}
