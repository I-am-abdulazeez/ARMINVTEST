page 5105 Teams
{
    // version NAVW113.00

    ApplicationArea = Basic,Suite;
    Caption = 'Teams';
    PageType = List;
    SourceTable = Team;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the team.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the team.';
                }
                field("Next Task Date";"Next Task Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date of the next task involving the team.';

                    trigger OnDrillDown()
                    var
                        Task: Record "To-do";
                    begin
                        Task.SetCurrentKey("Team Code",Date,Closed);
                        Task.SetRange("Team Code",Code);
                        Task.SetRange(Closed,false);
                        Task.SetRange("System To-do Type",Task."System To-do Type"::Team);
                        if Task.FindFirst then
                          PAGE.Run(0,Task);
                    end;
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
            group("&Team")
            {
                Caption = '&Team';
                Image = SalesPurchaseTeam;
                action(Tasks)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tasks';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Team Code"=FIELD(Code),
                                  "System To-do Type"=FILTER(Team);
                    RunPageView = SORTING("Team Code");
                    ToolTip = 'View the list of marketing tasks that exist.';
                }
                action(Salespeople)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Salespeople';
                    Image = ExportSalesPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Team Salespeople";
                    RunPageLink = "Team Code"=FIELD(Code);
                    ToolTip = 'View a list of salespeople within the team.';
                }
            }
        }
        area(reporting)
        {
            action("Team - Tasks")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Team - Tasks';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Team - Tasks";
                ToolTip = 'View the list of marketing tasks that exist for the team.';
            }
            action("Salesperson - Tasks")
            {
                ApplicationArea = Suite;
                Caption = 'Salesperson - Tasks';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Salesperson - Tasks";
                ToolTip = 'View the list of marketing tasks that exist for the salesperson.';
            }
            action("Salesperson - Opportunities")
            {
                ApplicationArea = Suite;
                Caption = 'Salesperson - Opportunities';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Salesperson - Opportunities";
                ToolTip = 'View information about the opportunities handled by one or several salespeople.';
            }
        }
    }
}

