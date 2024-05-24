report 99001045 "Calc. Machine Center Calendar"
{
    // version NAVW111.00

    Caption = 'Calc. Machine Center Calendar';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Machine Center";"Machine Center")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                TestField("Work Center No.");
                TestField(Capacity);
                TestField(Efficiency);

                CalendarMgt.CalculateSchedule(
                  1,
                  "No.",
                  "Work Center No.",
                  StartingDate,
                  EndingDate)
            end;

            trigger OnPreDataItem()
            begin
                if StartingDate = 0D then
                  Error(Text004);

                if EndingDate = 0D then
                  Error(Text005);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate;StartingDate)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date that you will start creating new calendar entries.';
                    }
                    field(EndingDate;EndingDate)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the final date that you will create new calendar entries.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            if StartingDate = 0D then
              StartingDate := DMY2Date(1,1,Date2DMY(WorkDate,3));
            if EndingDate = 0D then
              EndingDate := DMY2Date(31,12,Date2DMY(WorkDate,3));
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Window.Open(
          Text000 +
          Text001);
    end;

    var
        Text000: Label 'Calculating Machine Center...\\';
        Text001: Label 'No.            #1##########';
        Text004: Label 'You must enter the Starting Date.';
        Text005: Label 'You must enter the Ending Date.';
        CalendarMgt: Codeunit CalendarManagement;
        Window: Dialog;
        StartingDate: Date;
        EndingDate: Date;

    [Scope('Personalization')]
    procedure InitializeRequest(NewStartingDate: Date;NewEndingDate: Date)
    begin
        StartingDate := NewStartingDate;
        EndingDate := NewEndingDate;
    end;
}

