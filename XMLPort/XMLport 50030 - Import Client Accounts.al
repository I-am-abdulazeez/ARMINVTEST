xmlport 50030 "Import Client Accounts"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Client Account";"Client Account")
            {
                XmlName = 'ClientAccount';
                fieldelement(AccountNo;"Client Account"."Account No")
                {
                }
                fieldelement(MembershipID;"Client Account"."Client ID")
                {
                }
                fieldelement(FundCode;"Client Account"."Fund No")
                {
                }
                fieldelement(KYCTier;"Client Account"."KYC Tier")
                {
                }
                fieldelement(Mandate;"Client Account"."Dividend Mandate")
                {
                }
                fieldelement(StaffID;"Client Account"."Staff ID")
                {
                }
                fieldelement(InstitutionalActive;"Client Account"."Institutional Active Fund")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,"Client Account"."Client ID");
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
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('Uploading Client #1#####');
    end;

    var
        window: Dialog;
}

