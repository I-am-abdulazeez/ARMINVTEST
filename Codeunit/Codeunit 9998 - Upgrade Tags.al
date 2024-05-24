codeunit 9998 "Upgrade Tags"
{
    // version NAVW113.07


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 9999, 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var TempUpgradeTags: Record "Upgrade Tags" temporary)
    var
        UpgradeTagMgt: Codeunit "Upgrade Tag Mgt";
    begin
        UpgradeTagMgt.RegisterUpgradeTag(GetItemCategoryOnItemAPIUpgradeTag,TempUpgradeTags);
        UpgradeTagMgt.RegisterUpgradeTag(GetVATRepSetupPeriodRemCalcUpgradeTag,TempUpgradeTags);
    end;

    [EventSubscriber(ObjectType::Codeunit, 9999, 'OnGetPerDatabaseUpgradeTags', '', false, false)]
    local procedure RegisterPerDatabaseTags(var TempUpgradeTags: Record "Upgrade Tags" temporary)
    var
        UpgradeTagMgt: Codeunit "Upgrade Tag Mgt";
    begin
        UpgradeTagMgt.RegisterUpgradeTag(GetNewISVPlansUpgradeTag,TempUpgradeTags);
    end;

    [Scope('Personalization')]
    procedure GetNewISVPlansUpgradeTag(): Code[250]
    begin
        exit('MS-287563-NewISVPlansAdded-20181105');
    end;

    [Scope('Personalization')]
    procedure GetItemCategoryOnItemAPIUpgradeTag(): Code[250]
    begin
        exit('MS-279686-ItemCategoryOnItemAPI-20180903');
    end;

    [Scope('Personalization')]
    procedure GetVATRepSetupPeriodRemCalcUpgradeTag(): Code[250]
    begin
        exit('MS-306583-VATReportSetup-20190402');
    end;
}

