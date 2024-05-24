page 5954 "Service Item Substitutions"
{
    // version NAVW113.00

    Caption = 'Service Item Substitutions';
    DataCaptionFields = Interchangeable;
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Item Substitution";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Substitute Type";"Substitute Type")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the type of the item that can be used as a substitute.';
                }
                field("Substitute No.";"Substitute No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the number of the item that can be used as a substitute.';
                }
                field("Substitute Variant Code";"Substitute Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the code of the variant that can be used as a substitute.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the description of the substitute item.';
                }
                field("Sub. Item No.";"Sub. Item No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the item number of the catalog substitute item.';
                }
                field(Condition;Condition)
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies that a condition exists for this substitution.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies how many units (such as pieces, boxes, or cans) of the item are available.';
                }
                field("Relations Level";"Relations Level")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the priority level of this substitute item.';
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
        area(processing)
        {
            action("&Condition")
            {
                ApplicationArea = Service;
                Caption = '&Condition';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sub. Conditions";
                RunPageLink = Type=FIELD(Type),
                              "No."=FIELD("No."),
                              "Variant Code"=FIELD("Variant Code"),
                              "Substitute Type"=FIELD("Substitute Type"),
                              "Substitute No."=FIELD("Substitute No."),
                              "Substitute Variant Code"=FIELD("Substitute Variant Code");
                ToolTip = 'Specify a condition for the item substitution, which is for information only and does not affect the item substitution.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if ("Substitute Type" <> "Substitute Type"::"Nonstock Item") and
           ("Sub. Item No." <> '')
        then
          Clear("Sub. Item No.");
    end;
}

