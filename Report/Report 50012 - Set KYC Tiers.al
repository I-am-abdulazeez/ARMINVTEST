report 50012 "Set KYC Tiers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Set KYC Tiers.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {

            trigger OnAfterGetRecord()
            begin
                KYCTier.Reset;
                if KYCTier.FindFirst then
                  repeat
                    change:=false;
                    KYCTierRequirements.Reset;
                    KYCTierRequirements.SetRange("KYC Tier",KYCTier."KYC Code");
                    if KYCTierRequirements.FindFirst then
                      repeat
                        KYCLinks.Reset;
                        KYCLinks.SetRange("Client ID",Client."Membership ID");
                        KYCLinks.SetRange("KYC Type",KYCTierRequirements.Requirement);
                        if KYCLinks.FindFirst then
                          change:=true
                        else
                          change:=false;

                      until KYCTierRequirements.Next=0;
                      if change then begin
                        ClientAccount.Reset;
                        ClientAccount.SetRange("Client ID",Client."Membership ID");
                        ClientAccount.ModifyAll("KYC Tier",KYCTier."KYC Code");
                      end
                    until KYCTier.Next=0;
            end;
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

    labels
    {
    }

    var
        KYCTier: Record "KYC Tier";
        KYCTierRequirements: Record "KYC Tier Requirements";
        KYCLinks: Record "KYC Links";
        change: Boolean;
        ClientAccount: Record "Client Account";
}

