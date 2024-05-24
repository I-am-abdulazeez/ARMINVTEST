xmlport 50015 "Import Bank Redemption Recon"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(root)
        {
            tableelement("Redemption Recon Lines";"Redemption Recon Lines")
            {
                XmlName = 'Lines';
                fieldelement(TransDate;"Redemption Recon Lines"."Transaction Date")
                {
                }
                fieldelement(Reference;"Redemption Recon Lines".Reference)
                {
                }
                fieldelement(Narration;"Redemption Recon Lines".Narration)
                {
                }
                fieldelement(ValueDate;"Redemption Recon Lines"."Value Date")
                {
                }
                fieldelement(Debit;"Redemption Recon Lines"."Debit Amount")
                {
                }
                fieldelement(Credit;"Redemption Recon Lines"."Credit Amount")
                {
                }
                fieldelement(Channel;"Redemption Recon Lines".Channel)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    "Redemption Recon Lines"."Bank Fee":=FundTransactionManagement.GetBankCharges(Fundcode,"Redemption Recon Lines".Amount);
                    "Redemption Recon Lines"."Total Amount":="Redemption Recon Lines".Amount+"Redemption Recon Lines"."Bank Fee";
                end;

                trigger OnBeforeInsertRecord()
                begin
                    Lineno:=Lineno+1;
                    "Redemption Recon Lines"."Header No":=Headerno;
                    "Redemption Recon Lines"."Line No":=Lineno;
                    "Redemption Recon Lines"."Fund Code":=Fundcode;
                    "Redemption Recon Lines"."Bank Fee":=FundTransactionManagement.GetBankCharges(Fundcode,"Redemption Recon Lines"."Credit Amount");
                    "Redemption Recon Lines"."Total Amount":="Redemption Recon Lines"."Credit Amount"+"Redemption Recon Lines"."Bank Fee";
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
        FundTransactionManagement: Codeunit "Fund Transaction Management";

    procedure Getheader(pHeaderno: Code[20];fcode: Code[20])
    begin
        Headerno:=pHeaderno;
        Fundcode:=fcode;
        Lineno:=0
    end;
}

