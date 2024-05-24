codeunit 9802 "Logon Management"
{
    // version NAVW113.02

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        LogonInProgress: Boolean;

    [Scope('Personalization')]
    procedure IsLogonInProgress(): Boolean
    begin
        exit(LogonInProgress);
    end;

    [Scope('Personalization')]
    procedure SetLogonInProgress(Value: Boolean)
    begin
        LogonInProgress := Value;
    end;
}

