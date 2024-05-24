page 50204 "Loan Admin Role Center"
{
    // version THL-LOAN-1.0.0

    Caption = '', Comment='{Dependency=Match,"ProfileDescription_ORDERPROCESSOR"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control30;"Headline RC Business Manager")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control1907692008;"Loan Product Types")
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
            action("Loan Product Types")
            {
                Caption = 'Loan Product Types';
                RunObject = Page "Loan Product Types";
            }
            action("Fund Managers")
            {
                Caption = 'Fund Managers';
                RunObject = Page "Fund Managers";
            }
            action("Loan Management Setup")
            {
                Caption = 'Loan Management Setup';
                RunObject = Page "Loan Management Setup";
            }
        }
        area(sections)
        {
            group("Client Management")
            {
                Caption = 'Client Management';
                Image = Sales;
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
            group(Loans)
            {
                Caption = 'Loans';
                Image = LotInfo;
                action("Loan Applications")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Loan Applications';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Loan Applications";
                }
                action(New)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'New';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST(New));
                }
                action("Pending Approval")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pending Approval';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST("Pending Approval"));
                }
                action(Approved)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Approved';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST(Approved),
                                        Disbursed=CONST(false));
                }
                action(Rejected)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Rejected';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST(Rejected));
                }
                action("Page Loan Applications")
                {
                    Caption = 'At Treasury';
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST("At Treasury"));
                }
                action(Disbursed)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Disbursed';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST(Approved),
                                        Disbursed=CONST(true));
                }
                action("Partially Repaid")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Partially Repaid';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST("Partially Repaid"),
                                        Disbursed=CONST(true));
                }
                action("Non-Performing")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Non-Performing';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST("Non-Performing"));
                }
                action("On Repayment Holiday")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'On Repayment Holiday';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Applications";
                    RunPageView = WHERE(Status=CONST("On Repayment Holiday"));
                }
                action(Action68)
                {
                    Caption = 'Loan Product Types';
                    RunObject = Page "Loan Product Types";
                }
                action(Action67)
                {
                    Caption = 'Fund Managers';
                    RunObject = Page "Fund Managers";
                }
                action("Loan Batch Upload")
                {
                    Caption = 'Loan Batch Upload';
                    RunObject = Page "Loan Batch List";
                }
                action(Action69)
                {
                    Caption = 'New';
                    RunObject = Page "Loan Batch List";
                    RunPageView = WHERE(Status=CONST(New));
                }
                action(Pending)
                {
                    Caption = 'Pending';
                    RunObject = Page "Loan Batch List";
                    RunPageView = WHERE(Status=CONST("Pending Approval"));
                }
                action(Action71)
                {
                    Caption = 'Approved';
                    RunObject = Page "Loan Batch List";
                    RunPageView = WHERE(Status=CONST(Approved));
                }
                action("At Treasury")
                {
                    Caption = 'At Treasury';
                    RunObject = Page "Loan Batch List";
                    RunPageView = WHERE(Status=CONST(Treasury));
                }
                action(Action73)
                {
                    Caption = 'Disbursed';
                    RunObject = Page "Loan Batch List";
                    RunPageView = WHERE(Status=CONST(Disbursed));
                }
            }
            group("Loan Variations")
            {
                Caption = 'Loan Variations';
                Image = Transactions;
                action("Loan Variation")
                {
                    Caption = 'Loan Variation';
                    RunObject = Page "Loan Variations";
                }
                action("Loan Top Up")
                {
                    Caption = 'Loan Top Up';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Top Up"));
                }
                action(Action39)
                {
                    Caption = 'New';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Top Up"),
                                        Status=CONST(New));
                }
                action(Action40)
                {
                    Caption = 'Pending';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Top Up"),
                                        Status=CONST(Pending));
                }
                action(Action41)
                {
                    Caption = 'Approved';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Top Up"),
                                        Status=CONST(Approved));
                }
                action(Action42)
                {
                    Caption = 'Rejected';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Top Up"),
                                        Status=CONST(Rejected));
                }
                action("Loan Termination")
                {
                    Caption = 'Loan Termination';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST(Terminate));
                }
                action(Action48)
                {
                    Caption = 'New';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST(Terminate),
                                        Status=CONST(New));
                }
                action(Action47)
                {
                    Caption = 'Pending';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST(Terminate),
                                        Status=CONST(Pending));
                }
                action(Action46)
                {
                    Caption = 'Approved';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST(Terminate),
                                        Status=CONST(Approved));
                }
                action(Action45)
                {
                    Caption = 'Rejected';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST(Terminate),
                                        Status=CONST(Rejected));
                }
                action("Change of Tenure")
                {
                    Caption = 'Change of Tenure';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Change of Tenure"));
                }
                action(Action53)
                {
                    Caption = 'New';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Change of Tenure"),
                                        Status=CONST(New));
                }
                action(Action52)
                {
                    Caption = 'Pending';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Change of Tenure"),
                                        Status=CONST(Pending));
                }
                action(Action51)
                {
                    Caption = 'Approved';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Change of Tenure"),
                                        Status=CONST(Approved));
                }
                action(Action50)
                {
                    Caption = 'Rejected';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Change of Tenure"),
                                        Status=CONST(Rejected));
                }
                action("Loan Conversion")
                {
                    Caption = 'Loan Conversion';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Loan Conversion"));
                }
                action(Action63)
                {
                    Caption = 'New';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Loan Conversion"),
                                        Status=CONST(New));
                }
                action(Action62)
                {
                    Caption = 'Pending';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Loan Conversion"),
                                        Status=CONST(Pending));
                }
                action(Action61)
                {
                    Caption = 'Approved';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Loan Conversion"),
                                        Status=CONST(Approved));
                }
                action(Action60)
                {
                    Caption = 'Rejected';
                    RunObject = Page "Loan Variations";
                    RunPageView = WHERE("Type of Variation"=CONST("Loan Conversion"),
                                        Status=CONST(Rejected));
                }
            }
            group(Repayments)
            {
                Caption = 'Repayments';
                Image = Receivables;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                action("Loan Repayment")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Loan Repayment';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Repayment";
                }
                action(Action20)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'New';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Repayment";
                    RunPageView = WHERE(Status=CONST(Open));
                }
                action(Action22)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pending';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Repayment";
                    RunPageView = WHERE(Status=CONST(Pending));
                }
                action(Treated)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Treated';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Repayment";
                    RunPageView = WHERE(Status=CONST("Effected (Employer Advised)"));
                }
                action("<Page Loan Repayment>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Rejected';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Repayment";
                    RunPageView = WHERE(Status=CONST("Payment Received"));
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Fully Settled Loans")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fully Settled Loans';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Fully Settled Loans";
                }
                action("Effected Loan Variations")
                {
                    Caption = 'Effected Loan Variations';
                    RunObject = Page "Effected Loan Variations";
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                Image = Ledger;
                ToolTip = 'Manage physical or service-type items that you trade in by setting up item cards with rules for pricing, costing, planning, reservation, and tracking. Set up storage places or warehouses and how to transfer between such locations. Count, adjust, reclassify, or revalue inventory.';
                Visible = false;
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
        }
        area(processing)
        {
            group("Loan Reports")
            {
                Caption = 'Loan Reports';
                action("Amortization Schedule")
                {
                    Caption = 'Amortization Schedule';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Loan Repayment Schedule";
                }
                action("Summary of Total Loan")
                {
                    Caption = 'Summary of Total Loan';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Summary of Total Loans";
                }
                action("Pre-Retirement Advance")
                {
                    Caption = 'Pre-Retirement Advance';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Pre-Retirement Advance";
                }
                action("Repayments Due Schedule")
                {
                    Caption = 'Repayments Due Schedule';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Repayments Due Schedule";
                }
                action("Defaulters Schedule")
                {
                    Caption = 'Defaulters Schedule';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Defaulters Schedule";
                }
                action("Repayments Received Schedule")
                {
                    Caption = 'Repayments Received Schedule';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Repayments Received Schedule";
                }
                action("Fund Managers Loan Report")
                {
                    Caption = 'Fund Managers Loan Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Fund Managers Loans Report";
                }
                action("Part Repayments Schedule")
                {
                    Caption = 'Part Repayments Schedule';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Part Repayments Received";
                }
                action(Action58)
                {
                    Caption = 'Loan Variations';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Loan Variations";
                }
                action("Issued Loans")
                {
                    RunObject = Report "Issued Loans";
                }
                action("Issued Loans Historical")
                {
                    RunObject = Report "Issued Loans (Historical)";
                }
                action("Int lncome Earned On Loans")
                {
                    RunObject = Report "Int lncome Earned On Loans";
                }
                action("Summary Of Liquidated Loans")
                {
                    Caption = 'Summary Of Liquidated Loans';
                    RunObject = Report "Summary Of Liquidated Loans";
                }
                action("Summary Of Liquidated Loans Hist")
                {
                    Caption = 'Summary Of Liquidated Loans Hist';
                    RunObject = Report "Summary Of Liquidated Loans-H";
                }
                action("Active Loans")
                {
                    Caption = 'Active Loans';
                    RunObject = Report "Active Loans";
                }
                action("Active Loans 2")
                {
                    Caption = 'Active Loans 2';
                    RunObject = Report "Active Loans 2";
                }
                action("Out Of Pocket")
                {
                    Caption = 'Out Of Pocket';
                    RunObject = Report "Out Of Pocket Loan Repayment";
                }
                action("Out Of Pocket Historical")
                {
                    Caption = 'Out Of Pocket Historical';
                    RunObject = Report "Out Of Pcket Loan Repaymnt - H";
                }
                action("Refer N Earn Report")
                {
                    RunObject = Report "Refer N Earn Report";
                }
            }
        }
    }
}

