xmlport 50089 "ImportClients agent"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Client;Client)
            {
                AutoUpdate = true;
                XmlName = 'client';
                fieldelement(ID;Client."Membership ID")
                {
                }
                fieldelement(newID;Client."Account Executive Code")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,Client."Membership ID");
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
        Message('Done');
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#######');
    end;

    var
        window: Dialog;
}

