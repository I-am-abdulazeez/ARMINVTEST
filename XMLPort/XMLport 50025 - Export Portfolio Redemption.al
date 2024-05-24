xmlport 50025 "Export Portfolio Redemption"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(PortfolioRedResponse)
        {
            tableelement("Posted Redemption";"Posted Redemption")
            {
                XmlName = 'Lines';
                SourceTableView = WHERE(Posted=CONST(true),"Request Mode"=CONST(Portfolio));
                fieldelement(ReconNo;"Posted Redemption"."Recon No")
                {
                }
                fieldelement(No;"Posted Redemption".No)
                {
                }
                fieldelement(NoOfUnits;"Posted Redemption"."No. Of Units")
                {
                }
                fieldelement(FeeUnits;"Posted Redemption"."Fee Units")
                {
                }
                fieldelement(FeeAmount;"Posted Redemption"."Fee Amount")
                {
                }
                fieldelement(Price;"Posted Redemption"."Price Per Unit")
                {
                }
                textelement(TotalUnits)
                {
                }

                trigger OnAfterGetRecord()
                begin
                      TotalUnits := Format("Posted Redemption"."No. Of Units" + "Posted Redemption"."Fee Units")
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
}

