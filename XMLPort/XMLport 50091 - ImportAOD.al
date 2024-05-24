xmlport 50091 ImportAOD
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(KycLinks)
        {
            tableelement("KYC Links";"KYC Links")
            {
                AutoUpdate = true;
                XmlName = 'KycLinks';
                fieldelement(ClientID;"KYC Links"."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(Entryno;"KYC Links"."Entry No")
                {
                    FieldValidate = no;
                }
                fieldelement(KycType;"KYC Links"."KYC Type")
                {
                    FieldValidate = no;
                }
                fieldelement(Link;"KYC Links".Link)
                {
                    FieldValidate = no;
                }

                trigger OnBeforeInsertRecord()
                begin
                    window.Update(1,"KYC Links"."Client ID");
                    "Client Acc".Reset;
                    "Client Acc".SetRange("Client ID", "KYC Links"."Client ID");
                    if "Client Acc".FindFirst then
                      repeat
                        "Client Acc"."KYC Tier" := '173000002';
                        "Client Acc".Modify;
                     until "Client Acc".Next = 0;
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
        window.Open('uploading client #1#####');
    end;

    var
        "Client Acc": Record "Client Account";
        window: Dialog;
}

