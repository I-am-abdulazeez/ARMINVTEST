page 5212 "Absence Registration"
{
    // version NAVW113.02

    ApplicationArea = BasicHR;
    Caption = 'Absence Registration';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Absence";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the last day of the employee''s absence registered on this line.';
                }
                field("Cause of Absence Code";"Cause of Absence Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a cause of absence code to define the type of absence.';
                }
                field(Description;Description)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a description of the absence.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the quantity associated with absences, in hours or days.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the quantity associated with absences, in hours or days.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies if a comment is associated with this entry.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                Caption = 'A&bsence';
                Image = Absence;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=CONST("Employee Absence"),
                                  "Table Line No."=FIELD("Entry No.");
                    ToolTip = 'View or add comments for the record.';
                }
                separator(Separator31)
                {
                }
                action("Overview by &Categories")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Overview by &Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Absence Overview by Categories";
                    RunPageLink = "Employee No. Filter"=FIELD("Employee No.");
                    ToolTip = 'View categorized absence information for employees.';
                }
                action("Overview by &Periods")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Overview by &Periods';
                    Image = AbsenceCalendar;
                    RunObject = Page "Absence Overview by Periods";
                    ToolTip = 'View absence information for employees by period.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        exit(Employee.Get("Employee No."));
    end;

    var
        Employee: Record Employee;
}
