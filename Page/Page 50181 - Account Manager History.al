page 50181 "Account Manager History"
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
                field("Client ID";"Client ID")
                {
                }
                field("Account Manager";"Account Manager")
                {
                }
                field(Name;Name)
                {
                }
                field("Date Assigned";"Date Assigned")
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

