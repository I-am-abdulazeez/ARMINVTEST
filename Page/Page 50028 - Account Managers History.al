page 50028 "Account Managers History"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Account Managers Tracker";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Manager";"Account Manager")
                {
                }
                field(Name;Name)
                {
                }
                field("Date Assigned";"Date Assigned")
                {
                }
                field(Active;Active)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Name:=ClientSetupFunctions.GetAccountManagerName("Account Manager");
    end;

    var
        ClientSetupFunctions: Codeunit "Client Administration";
        Name: Text;
}

