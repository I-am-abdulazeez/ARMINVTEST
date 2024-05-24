xmlport 50082 "ImportClient accounts -V2"
{
    Format = VariableText;

    schema
    {
        textelement(Clientaccounts)
        {
            tableelement("Client Account";"Client Account")
            {
                XmlName = 'clientaccount';
                UseTemporary = true;
                fieldelement(oldacc;"Client Account"."Old Account Number")
                {
                }
                fieldelement(Phone;"Client Account"."Phone No.")
                {
                }
                fieldelement(ID;"Client Account"."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(Fund;"Client Account"."Fund No")
                {
                }
                fieldelement(BankAccNo;"Client Account"."Bank Account Number")
                {
                    FieldValidate = no;
                }
                fieldelement(Bank;"Client Account"."Bank Code")
                {
                    FieldValidate = no;
                }
                fieldelement(Bname;"Client Account"."Bank Account Name")
                {
                }
                fieldelement(Email;"Client Account"."E-Mail")
                {
                }
                fieldelement(KYCTier;"Client Account"."KYC Tier")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Client Account"."Client ID");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if  StrPos("Client Account"."Old Account Number",'PDY')=1 then begin
                                      ClientID:=DelStr("Client Account"."Old Account Number",1,3);
                                      "Client Account"."Account No":=ClientAdministration.NewPaydayACC(ClientID,"Client Account"."Fund No","Client Account"."Old Account Number");
                                      "Client Account"."Client ID":=ClientID;
                                    end else
                                    "Client Account"."Account No":=ClientAdministration.NewAccountReturnACC("Client Account"."Client ID","Client Account"."Fund No");

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
        //ClientAdministration.NewPaydayACC('1162037','ARMMMF','PDY1162037');
    end;

    var
        window: Dialog;
        ClientAdministration: Codeunit "Client Administration";
        Accno: Code[40];
        clientaccount: Record "Client Account";
        ClientID: Code[40];
}

