page 50150 "Investment Role Center"
{
    // version NAVW113.00

    Caption = '', Comment='{Dependency=Match,"ProfileDescription_ORDERPROCESSOR"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1907692008;"Fund List")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control13;"Power BI Report Spinner Part")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control4;"My Job Queue")
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
            part(Control21;"Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox"=R;
                ApplicationArea = Suite;
            }
            systempart(Control1901377608;MyNotes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            ToolTip = 'Manage sales processes, view KPIs, and access your favorite items and customers.';
            action("Client List")
            {
                Caption = 'Client List';
                RunObject = Page "Client List";
            }
            action("Client Accounts")
            {
                Caption = 'Client Accounts';
                RunObject = Page "Client Accounts";
            }
            action("Fund List")
            {
                Caption = 'Fund List';
                RunObject = Page "Fund List";
            }
        }
        area(sections)
        {
            group("Client Management")
            {
                Caption = 'Client Management';
                Image = Sales;
                ToolTip = 'Make quotes, orders, and credit memos to customers. Manage customers and view transaction history.';
                action(Action6)
                {
                    Caption = 'Client List';
                    RunObject = Page "Client List";
                }
                action(Action5)
                {
                    Caption = 'Client Accounts';
                    RunObject = Page "Client Accounts";
                }
                action("Account Managers")
                {
                    Caption = 'Account Managers';
                    RunObject = Page "Account Manager List";
                }
            }
            group("Direct Debit Mandates")
            {
                Caption = 'Direct Debit Mandates';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Direct Debit Setup Request")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Direct Debit Setup Request';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Direct Debit Setup Requests";
                    ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                }
                action("Direct Debits Received at Retail")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Direct Debits Received at Retail';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Direct Debits at Registrar";
                    ToolTip = 'Create purchase quotes to represent your request for quotes from vendors. Quotes can be converted to purchase orders.';
                }
            }
            group("Online Indemnity")
            {
                Caption = 'Online Indemnity';
                Image = Marketing;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Online Indmenity requests")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Online Indmenity requests';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Online Indemnity Requests";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
            }
            group(Subscription)
            {
                Caption = 'Subscription';
                Image = LotInfo;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Received Subscriptions")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Received Subscriptions';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Received Subscriptions";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Confirmed Subscriptions")
                {
                    Caption = 'Confirmed Subscriptions';
                    RunObject = Page "Confirmed Subscriptions";
                }
                action(" Posted Subscriptions")
                {
                    Caption = ' Posted Subscriptions';
                    RunObject = Page "Posted Subscriptions";
                }
                action("Audit Subscriptions Reversal")
                {
                    Caption = 'Audit Subscriptions Reversal';
                    RunObject = Page "Audit Subscription Reversal";
                }
                action("Reversed Subscriptions")
                {
                    Caption = 'Reversed Subscriptions';
                    RunObject = Page "Reversed Subscriptions";
                }
            }
            group(Redemption)
            {
                Caption = 'Redemption';
                Image = Receivables;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Redemption Requests Received")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Redemption Requests Received';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Redemption Requests Received";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Redemptions ARM Registrar")
                {
                    Caption = 'Redemptions ARM Registrar';
                    RunObject = Page "Redemptions ARM Registrar";
                }
                action("Redemptions Rejected")
                {
                    Caption = 'Redemptions Rejected';
                    RunObject = Page "Redemptions Rejected";
                }
                action("Redemptions Verified")
                {
                    Caption = 'Redemptions Verified';
                    RunObject = Page "Redemptions Verified";
                }
                action("Posted Redemptions")
                {
                    Caption = 'Posted Redemptions';
                    RunObject = Page "Posted Redemptions";
                }
                action("Audit Redemptions Reversal")
                {
                    Caption = 'Audit Redemptions Reversal';
                    RunObject = Page "Audit Redemption Reversal";
                }
                action("Reversed Redemptions")
                {
                    Caption = 'Reversed Redemptions';
                    RunObject = Page "Reversed Redemptions";
                }
            }
            group("Fund Transfer")
            {
                Caption = 'Fund Transfer';
                Image = RegisteredDocs;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Fund Transfer Requests")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fund Transfer Requests';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Unit Transfer Requests";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Mass Unit Transfer Request")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mass Unit Transfer Request';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Mass Transfer Request";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Fund Transfer ARM  Reg")
                {
                    Caption = 'Fund Transfer ARM  Reg';
                    RunObject = Page "Unit Transfer ARM  Reg";
                }
                action("Fund Transfer Verified")
                {
                    Caption = 'Fund Transfer Verified';
                    RunObject = Page "Unit Transfer Verified";
                }
                action("Fund Transfer Rejected")
                {
                    Caption = 'Fund Transfer Rejected';
                    RunObject = Page "Unit Transfer Rejected";
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                Image = Ledger;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action(Action17)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Online Indmenity requests';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Online Indemnity Requests";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
            }
            group("Income Distribution")
            {
                Caption = 'Income Distribution';
                Image = RegisteredDocs;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Portfolio Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Portfolio Setup';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Portfolio Setup";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("<Page  Income Register>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Money Market Income Register';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Income Register";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("DailyDistributable Income")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'DailyDistributable Income';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Daily Distributable Income";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Mutual Funds Income Register")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mutual Funds Income Register';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MF Income Register";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("MF Distributable Income")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'MF Distributable Income';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MF Distributable Income";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Mutual Fund Payments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mutual Fund Payments';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Mutual Fund Payments";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("Mutual Fund Payments Generated")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mutual Fund Payments Generated';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MFP Generated";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("MFP Verified")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'MFP Verified';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MFP Verified";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("MFP Process Payout")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'MFP Process Payout';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MFP Process Payout";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                    Visible = false;
                }
                action("MFP Reinvested")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'MFP Reinvested';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MFP Reinvested";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
                action("MFP Payouts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'MFP Payouts';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "MFP Payouts";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }
            }
            group(Reversals)
            {
                Caption = 'Reversals';
                Image = Journals;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                Visible = false;
                action("Reverse Entries")
                {
                    RunObject = Page "Reverse Transactions";
                }
                action("Reverse Entries Pending Approval")
                {
                    RunObject = Page "Reverse Transactions Pending";
                    Visible = false;
                }
                action("Approved Reverse Entries")
                {
                    RunObject = Page "Reverse Transactions Approved";
                }
                action("Rejected Reverse Entries")
                {
                    RunObject = Page "Rejected Reversed Transactions";
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = History;
                ToolTip = 'Get all your business Reports';
                action("Refer N Earn Report")
                {
                    RunObject = Report "Refer N Earn Report";
                }
            }
        }
    }
}

