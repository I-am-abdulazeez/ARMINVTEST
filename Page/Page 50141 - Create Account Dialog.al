page 50141 "Create Account Dialog"
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(ClientID;ClientID)
            {
                Caption = 'Client ID';
                Editable = false;
            }
            field(FundCode;FundCode)
            {
                Caption = 'Fund Code';
                TableRelation = Fund;
            }
            field("Pay Day";Payday)
            {

                trigger OnValidate()
                begin
                    if FundCode<>'ARMMMF' then
                      Error('Fund Code must be ARMMMF');
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction=ACTION::OK then begin
          if FundCode='' then
            Error('Please Select Fund code');
          if Payday then
            ClientAdministration.NewPaydayACC(ClientID,FundCode,'PDY'+ClientID)
          else
          ClientAdministration.NewAccount(ClientID,FundCode);
        end
    end;

    var
        ClientID: Code[40];
        FundCode: Code[40];
        ClientAdministration: Codeunit "Client Administration";
        Payday: Boolean;

    procedure getClientId(pid: Code[40])
    begin
        ClientID:=pid
    end;
}

