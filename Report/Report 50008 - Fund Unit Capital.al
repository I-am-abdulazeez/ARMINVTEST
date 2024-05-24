report 50008 "Fund Unit Capital"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Fund Unit Capital.rdlc';

    dataset
    {
        dataitem(Fund;Fund)
        {
            RequestFilterFields = "Fund Code","Date Filter";
            column(NoofAccounts_Fund;Fund."No of Accounts")
            {
            }
            column(NoofUnits_Fund;Fund."No of Units")
            {
            }
            column(FundCode_Fund;Fund."Fund Code")
            {
            }
            column(Name_Fund;Fund.Name)
            {
            }
            column(Company;Companyinfo.Name)
            {
            }
            column(datefilter;datefilter)
            {
            }
            column(ActiveAccountHolders_Fund;Fund."Active Account Holders")
            {
            }

            trigger OnPreDataItem()
            begin
                if Fund.GetFilter("Date Filter")<>'' then
                 datefilter:=Fund.GetRangeMax("Date Filter")
                else
                  datefilter:= Today;
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

    trigger OnPreReport()
    begin
        Companyinfo.Get
    end;

    var
        Companyinfo: Record "Company Information";
        datefilter: Date;
}

