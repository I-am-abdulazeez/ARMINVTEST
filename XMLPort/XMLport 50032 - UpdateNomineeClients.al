xmlport 50032 UpdateNomineeClients
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Client Account";"Client Account")
            {
                AutoUpdate = true;
                XmlName = 'Nominee';
                fieldelement(AccounttNo;"Client Account"."Account No")
                {
                }
                fieldelement(PortfolioCode;"Client Account"."Portfolio Code")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Client Account"."Account No");
                end;

                trigger OnBeforeModifyRecord()
                begin
                    "Client Account"."Nominee Client" := true;
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
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#####');
    end;

    var
        window: Dialog;
}

