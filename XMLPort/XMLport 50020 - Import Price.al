xmlport 50020 "Import Price"
{
    Format = VariableText;

    schema
    {
        textelement(Prices)
        {
            tableelement("Fund Prices";"Fund Prices")
            {
                XmlName = 'FundPrice';
                fieldelement(FundNo;"Fund Prices"."Fund No.")
                {
                    FieldValidate = yes;
                }
                fieldelement(Vdate;"Fund Prices"."Value Date")
                {
                    FieldValidate = yes;
                }
                fieldelement(Bid;"Fund Prices"."Bid Price")
                {
                    FieldValidate = yes;
                }
                fieldelement(Offer;"Fund Prices"."Offer Price")
                {
                    FieldValidate = yes;
                }
                fieldelement(Mid;"Fund Prices"."Mid Price")
                {
                    FieldValidate = yes;
                }

                trigger OnBeforeInsertRecord()
                begin
                    /*IF Firstline THEN BEGIN
                      Firstline:=FALSE;
                      currXMLport.SKIP;
                    END;*/

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

    trigger OnPreXmlPort()
    begin
        Firstline:=true;
    end;

    var
        Firstline: Boolean;
}

