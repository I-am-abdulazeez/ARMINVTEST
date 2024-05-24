xmlport 50021 "Import Redemption"
{
    // version IntegraData

    Format = VariableText;

    schema
    {
        textelement(Redemptions)
        {
            tableelement(Redemption;Redemption)
            {
                XmlName = 'Redemption';
                fieldelement(Vdate;Redemption."Value Date")
                {
                    FieldValidate = yes;
                }
                fieldelement(Tdate;Redemption."Transaction Date")
                {
                    FieldValidate = yes;
                }
                fieldelement(ClientID;Redemption."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(FundCode;Redemption."Fund Code")
                {
                    FieldValidate = yes;
                }
                textelement(amount)
                {
                    XmlName = 'Amount';
                }
                textelement(redemptiontype)
                {
                    XmlName = 'RedemptionType';
                }
                fieldelement(AccountNo;Redemption."Account No")
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                    ClientID: Code[40];
                begin
                    Evaluate(AMT,Amount);
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Client ID",Redemption."Client ID");
                    //ClientAccount.SETRANGE("Fund No", Redemption."Fund Code");
                    ClientAccount.SetRange("Account No",Redemption."Account No");
                    if ClientAccount.FindFirst then  begin
                      Redemption."Account No":=ClientAccount."Account No";
                      Redemption."Client ID":=ClientAccount."Client ID";
                      if RedemptionType = 'Part' then
                        Redemption."Redemption Type" := Redemption."Redemption Type"::Part
                      else if RedemptionType = 'Full' then
                        Redemption."Redemption Type" := Redemption."Redemption Type"::Full
                      else
                        Error('Please enter a valid redemption type for %1. Redemption types are case-sensitive and can either be Part or Full.',Redemption."Client ID");
                      Redemption.Validate("Value Date");
                      Redemption.Validate("Account No");
                      Redemption.Validate("Client ID");
                      Redemption.Validate("No. Of Units");
                      Redemption.Validate("Redemption Type");
                      Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
                      Redemption.Validate("No. Of Units",AMT);
                    end else
                      Error('Client with Membership ID %1 and Fund Code %2 do not exist',Redemption."Client ID",Redemption."Fund Code")
                end;

                trigger OnBeforeModifyRecord()
                begin
                    window.Update(1,Redemption."Account No");
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
        //window.CLOSE;
        Message('Import completed successfully');
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading #1#####');
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        AMT: Decimal;
        window: Dialog;
}

