xmlport 50090 "update switch"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Client Transactions";"Client Transactions")
            {
                AutoUpdate = true;
                XmlName = 'client';
                fieldelement(ID;"Client Transactions"."Entry No")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Client Transactions"."Entry No");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "Client Transactions"."Transaction Sub Type 3":="Client Transactions"."Transaction Sub Type 3"::"Unit Switch";
                end;

                trigger OnBeforeModifyRecord()
                begin
                    "Client Transactions"."Transaction Sub Type 3":="Client Transactions"."Transaction Sub Type 3"::"Unit Switch";
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

