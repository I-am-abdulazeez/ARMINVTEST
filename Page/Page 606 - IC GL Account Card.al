page 606 "IC G/L Account Card"
{
    // version NAVW113.00

    Caption = 'Intercompany G/L Account Card';
    PageType = Card;
    SourceTable = "IC G/L Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the name of the IC general ledger account.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Map-to G/L Acc. No.";"Map-to G/L Acc. No.")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the number of the G/L account in your chart of accounts that corresponds to this intercompany G/L account.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("IC A&ccount")
            {
                Caption = 'IC A&ccount';
                Image = Intercompany;
                action("&List")
                {
                    ApplicationArea = Intercompany;
                    Caption = '&List';
                    Image = OpportunitiesList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "IC G/L Account List";
                    ShortCutKey = 'Shift+Ctrl+L';
                    ToolTip = 'View the list of intercompany G/L accounts.';
                }
            }
        }
    }
}

