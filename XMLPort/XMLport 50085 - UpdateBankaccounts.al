xmlport 50085 UpdateBankaccounts
{
    Format = VariableText;

    schema
    {
        textelement(roo)
        {
            tableelement(Client;Client)
            {
                AutoUpdate = true;
                XmlName = 'cleint';
                UseTemporary = true;
                fieldelement(ClientID;Client."Membership ID")
                {
                }
                textelement(Bankacc)
                {
                }
                textelement(Bankcode)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    Clients: Record Client;
                begin
                    window.Update(1,Client."Membership ID");
                    if Clients.Get(Client."Membership ID" ) then
                    WebserviceFunctions.UpdateBankDetails(Client."Membership ID",Bankcode,'','',Bankacc,'')
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        window.Close;
        Message('Update complete');
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('Updating ... #1#####');
    end;

    var
        WebserviceFunctions: Codeunit WebserviceFunctions;
        window: Dialog;
}

