page 749 "Date Lookup"
{
    // version NAVW111.00

    Caption = 'Date Lookup';
    PageType = List;
    SourceTable = "Date Lookup Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the time period associated with the date lookup.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        YearFilter: Integer;
    begin
        CopyFilter("Period Type",Date."Period Type");
        YearFilter := Date2DMY(Today,3);
        Date.SetRange("Period Start",DMY2Date(1,1,YearFilter),DMY2Date(30,12,YearFilter));
        Date.FindSet;
        repeat
          TransferFields(Date);
          Insert;
        until Date.Next = 0;
        FindFirst;
    end;

    var
        Date: Record Date;
}
