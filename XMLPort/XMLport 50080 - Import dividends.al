xmlport 50080 "Import dividends"
{
    Format = VariableText;

    schema
    {
        textelement(Dividend)
        {
            tableelement("Daily Income Distrib Lines";"Daily Income Distrib Lines")
            {
                XmlName = 'dividendlines';
                fieldelement(No;"Daily Income Distrib Lines".No)
                {
                }
                fieldelement(lineno;"Daily Income Distrib Lines"."Line No")
                {
                }
                fieldelement(ClientID;"Daily Income Distrib Lines"."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(clientname;"Daily Income Distrib Lines"."Client Name")
                {
                    FieldValidate = no;
                }
                fieldelement(Fund;"Daily Income Distrib Lines"."Fund Code")
                {
                }
                fieldelement(Valuedate;"Daily Income Distrib Lines"."Value Date")
                {
                    FieldValidate = no;
                }
                fieldelement(Amount;"Daily Income Distrib Lines"."Income accrued")
                {
                    FieldValidate = no;
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Daily Income Distrib Lines"."Line No");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    // Accno:=ClientAdministration.NewAccountReturnACC("Client Account"."Client ID","Client Account"."Fund No");
                     // "Client Account".VALIDATE("Client Account"."Account No",Accno);

                    ClientAccount.Reset;
                    ClientAccount.SetRange("Old Account Number","Daily Income Distrib Lines"."Client ID");
                    ClientAccount.SetRange("Fund No","Daily Income Distrib Lines"."Fund Code");
                    if ClientAccount.FindFirst then  begin

                      "Daily Income Distrib Lines"."Account No":=ClientAccount."Account No";
                      "Daily Income Distrib Lines"."Client ID":=ClientAccount."Client ID";
                    end else begin

                    ClientAccount.Reset;
                    ClientAccount.SetRange("Client ID","Daily Income Distrib Lines"."Client ID");
                    ClientAccount.SetRange("Fund No","Daily Income Distrib Lines"."Fund Code");
                    if ClientAccount.FindFirst then
                      "Daily Income Distrib Lines"."Account No":=ClientAccount."Account No"
                    else
                      "Daily Income Distrib Lines"."Account No":="Daily Income Distrib Lines"."Client ID";
                    end
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
        window.Close
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#####');
    end;

    var
        window: Dialog;
        ClientAdministration: Codeunit "Client Administration";
        Accno: Code[40];
        ClientAccount: Record "Client Account";
}

