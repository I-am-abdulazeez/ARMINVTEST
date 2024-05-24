codeunit 6317 "Power BI Session Manager"
{
    // version NAVW113.01

    // // This is singleton class to maintain information about Power BI for a user session.

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        HasPowerBILicense: Boolean;

    procedure SetHasPowerBILicense(Value: Boolean)
    begin
        HasPowerBILicense := Value;
    end;

    procedure GetHasPowerBILicense(): Boolean
    begin
        exit(HasPowerBILicense);
    end;
}

