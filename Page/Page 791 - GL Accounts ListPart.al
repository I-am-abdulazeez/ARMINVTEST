page 791 "G/L Accounts ListPart"
{
    // version NAVW113.00

    Caption = 'G/L Accounts ListPart';
    Editable = false;
    PageType = ListPart;
    SourceTable = "G/L Account";
    SourceTableView = WHERE("Account Type"=CONST(Posting));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies is the general ledger account is an income statement account or a balance sheet account.';
                }
            }
        }
    }

    actions
    {
    }
}
