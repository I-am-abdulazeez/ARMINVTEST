xmlport 50124 "Import Caution"
{
    // version IntegraData

    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Cautions)
        {
            tableelement("Client Cautions";"Client Cautions")
            {
                XmlName = 'Caution';
                fieldelement(ClientID;"Client Cautions"."Client ID")
                {
                    FieldValidate = yes;
                }
                fieldelement(AccountNo;"Client Cautions"."Account No")
                {
                    FieldValidate = no;
                }
                fieldelement(RestrictionType;"Client Cautions"."Restriction Type")
                {
                }
                fieldelement(DocumentLink;"Client Cautions"."Document Link")
                {
                    FieldValidate = yes;
                }
                fieldelement(CautionType;"Client Cautions"."Caution Type")
                {
                }
                fieldelement(CauseCode;"Client Cautions"."Cause Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "Client Cautions".Validate("Cause Code");
                    "Client Cautions".Validate("Caution Type");
                end;

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                    ClientID: Code[40];
                begin
                    "Client Cautions".Status := "Client Cautions".Status::Verified;
                end;

                trigger OnBeforeModifyRecord()
                begin
                    window.Update(1,"Client Cautions"."Account No");
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
        window.Open('uploading #1#####');
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        client: Record Client;
        window: Dialog;
}

