xmlport 50005 "Import Bank Statement Recon"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(root)
        {
            tableelement("Subscription Recon Lines";"Subscription Recon Lines")
            {
                XmlName = 'Lines';
                fieldelement(TransDate;"Subscription Recon Lines"."Transaction Date")
                {
                }
                fieldelement(Reference;"Subscription Recon Lines".Reference)
                {
                }
                fieldelement(Narration;"Subscription Recon Lines".Narration)
                {
                }
                fieldelement(ValueDate;"Subscription Recon Lines"."Value Date")
                {
                }
                fieldelement(Debit;"Subscription Recon Lines"."Debit Amount")
                {
                }
                fieldelement(Credit;"Subscription Recon Lines"."Credit Amount")
                {
                }
                fieldelement(Channel;"Subscription Recon Lines".Channel)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    Lineno:=Lineno+1;
                    "Subscription Recon Lines"."Header No":=Headerno;
                    "Subscription Recon Lines"."Line No":=Lineno;
                    "Subscription Recon Lines"."Fund Code":=Fundcode;
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

    var
        Headerno: Code[20];
        Lineno: Integer;
        Fundcode: Code[30];

    procedure Getheader(pHeaderno: Code[20];fcode: Code[20])
    begin
        Headerno:=pHeaderno;
        Fundcode:=fcode;
        Lineno:=0
    end;
}

