xmlport 50122 "Import Portfolio"
{
    // version MFD-1.0

    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Portfolio;Portfolio)
            {
                AutoUpdate = true;
                XmlName = 'portfolio';
                fieldelement(code;Portfolio."Portfolio Code")
                {
                }
                fieldelement(instrumentId;Portfolio."Instrument Id")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,Portfolio."Portfolio Code");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //Portfolio."Instrument Id" := 'F7';
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
        Message('Completed');
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('importing portfolio #1#####');
    end;

    var
        window: Dialog;
}

