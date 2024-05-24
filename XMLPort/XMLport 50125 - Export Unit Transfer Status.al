xmlport 50125 "Export Unit Transfer Status"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(fundTrans)
        {
            tableelement("Fund Transfer";"Fund Transfer")
            {
                XmlName = 'fundTransfer';
                fieldelement(status;"Fund Transfer"."Fund Transfer Status")
                {
                }
                fieldelement(reason;"Fund Transfer".Field135)
                {
                }
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

    var
        window: Dialog;
}

