page 1810 "Data Migration Entities"
{
    // version NAVW113.02

    Caption = 'Data Migration Entities';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Data Migration Entity";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control8)
            {
                ShowCaption = false;
                group(Control9)
                {
                    ShowCaption = false;
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                    }
                }
            }
            repeater(Group)
            {
                field(Selected;Selected)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the table will be migrated. If the check box is selected, then the table will be migrated.';
                    Visible = NOT HideSelected;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the table to be migrated.';
                }
                field("No. of Records";"No. of Records")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of records in the table to be migrated.';
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the total monetary value, in your local currency, of all entities in the table.';
                    Visible = ShowBalance;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ShowBalance := false;
        HideSelected := false;
        Description := 'Verify that the number of records are correct.';
    end;

    var
        ShowBalance: Boolean;
        HideSelected: Boolean;
        Description: Text;

    [Scope('Personalization')]
    procedure CopyToSourceTable(var TempDataMigrationEntity: Record "Data Migration Entity" temporary)
    begin
        DeleteAll;

        if TempDataMigrationEntity.FindSet then
          repeat
            Init;
            TransferFields(TempDataMigrationEntity);
            Insert;
          until TempDataMigrationEntity.Next = 0;
    end;

    [Scope('Personalization')]
    procedure CopyFromSourceTable(var TempDataMigrationEntity: Record "Data Migration Entity" temporary)
    begin
        TempDataMigrationEntity.Reset;
        TempDataMigrationEntity.DeleteAll;

        if FindSet then
          repeat
            TempDataMigrationEntity.Init;
            TempDataMigrationEntity.TransferFields(Rec);
            TempDataMigrationEntity.Insert;
          until Next = 0;
    end;

    [Scope('Personalization')]
    procedure SetShowBalance(ShowBalances: Boolean)
    begin
        ShowBalance := ShowBalances;
    end;

    [Scope('Personalization')]
    procedure SetPostingInfromation(PostJournals: Boolean;PostingDate: Date)
    var
        TempDataMigrationEntity: Record "Data Migration Entity" temporary;
    begin
        TempDataMigrationEntity.Copy(Rec,true);
        TempDataMigrationEntity.ModifyAll(Post,PostJournals);
        TempDataMigrationEntity.ModifyAll("Posting Date",PostingDate);
    end;

    [Scope('Personalization')]
    procedure SetHideSelected(HideCheckBoxes: Boolean)
    begin
        HideSelected := HideCheckBoxes;
    end;
}

