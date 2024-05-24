codeunit 27 "Confirm Management"
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    procedure ConfirmProcess(ConfirmQuestion: Text;DefaultButton: Boolean): Boolean
    begin
        if not GuiAllowed then
          exit(DefaultButton);
        exit(Confirm(ConfirmQuestion,DefaultButton));
    end;

    procedure ConfirmProcessUI(ConfirmQuestion: Text;DefaultButton: Boolean): Boolean
    begin
        if not GuiAllowed then
          exit(false);
        exit(Confirm(ConfirmQuestion,DefaultButton));
    end;
}

