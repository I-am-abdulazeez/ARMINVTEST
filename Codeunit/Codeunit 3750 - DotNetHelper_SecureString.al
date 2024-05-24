codeunit 3750 DotNetHelper_SecureString
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    var
        SecureStringSizeLimitErr: Label 'SecureString exceeds size limitation, check documentation on dotnet 4.7.2.';

    [Scope('Personalization')]
    procedure SecureStringFromString(var DotNet_SecureString: Codeunit DotNet_SecureString;String: Text)
    var
        I: Integer;
        Length: Integer;
    begin
        Length := StrLen(String);
        if Length > 65536 then
          Error(SecureStringSizeLimitErr);

        DotNet_SecureString.SecureString;
        for I := 1 to Length do
          DotNet_SecureString.AppendChar(String[I]);
    end;
}
