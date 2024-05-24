xmlport 50083 "ImportClients new ID"
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
                fieldelement(newID;Client."New Client ID")
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
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#####');
    end;

    var
        window: Dialog;
}

