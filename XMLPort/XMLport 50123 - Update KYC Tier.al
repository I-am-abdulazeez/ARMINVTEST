xmlport 50123 "Update KYC Tier"
{
    // version MFD-1.0

    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Client Account";"Client Account")
            {
                AutoUpdate = true;
                XmlName = 'clientAccount';
                fieldelement(accountNo;"Client Account"."Account No")
                {
                }
                textelement(KYCTier)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Client Account"."Account No");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if "Client Account".Get("Client Account"."Account No") then
                      "Client Account"."KYC Tier" := KYCTier;
                end;

                trigger OnBeforeModifyRecord()
                begin
                    if "Client Account".Get("Client Account"."Account No") then
                      "Client Account"."KYC Tier" := KYCTier;
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
        window.Open('Updating KYC Tier #1#####');
    end;

    var
        window: Dialog;
}

