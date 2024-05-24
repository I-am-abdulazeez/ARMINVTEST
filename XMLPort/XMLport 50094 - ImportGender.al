xmlport 50094 ImportGender
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(gender)
        {
            tableelement(Client;Client)
            {
                AutoUpdate = true;
                XmlName = 'Gender';
                fieldelement(ClientID;Client."Membership ID")
                {
                }
                fieldelement(ClientGender;Client.Gender)
                {
                }

                trigger OnBeforeModifyRecord()
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
        Message('Update complete');
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('Updating ... #1#####');
    end;

    var
        window: Dialog;
}

