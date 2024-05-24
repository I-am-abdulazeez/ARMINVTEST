xmlport 50000 "Import Bank Statement"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(root)
        {
            tableelement("Subscription Matching Lines";"Subscription Matching Lines")
            {
                XmlName = 'Lines';
                fieldelement(TransDate;"Subscription Matching Lines"."Transaction Date")
                {
                }
                fieldelement(Reference;"Subscription Matching Lines".Reference)
                {
                }
                fieldelement(Narration;"Subscription Matching Lines".Narration)
                {
                }
                fieldelement(ValueDate;"Subscription Matching Lines"."Value Date")
                {
                }
                fieldelement(Debit;"Subscription Matching Lines"."Debit Amount")
                {
                }
                fieldelement(Credit;"Subscription Matching Lines"."Credit Amount")
                {
                }
                fieldelement(Channel;"Subscription Matching Lines".Channel)
                {
                    MinOccurs = Zero;
                }
                fieldelement(PayMode;"Subscription Matching Lines"."Payment Mode")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    Lineno:=Lineno+1;
                    "Subscription Matching Lines"."Header No":=Headerno;
                    "Subscription Matching Lines"."Line No":=Lineno;
                    "Subscription Matching Lines"."Fund Code":=Fundcode;
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

