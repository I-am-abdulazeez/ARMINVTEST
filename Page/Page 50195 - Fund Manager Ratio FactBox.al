page 50195 "Fund Manager Ratio FactBox"
{
    // version THL-LOAN-1.0.0

    Caption = 'Fund Manager Ratios';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Product Fund Manager Ratio";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund Manager Name";"Fund Manager Name")
                {
                }
                field(Percentage;Percentage)
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
        SetRange("To",0D);
    end;

    trigger OnOpenPage()
    begin
        SetRange("To",0D);
    end;
}

