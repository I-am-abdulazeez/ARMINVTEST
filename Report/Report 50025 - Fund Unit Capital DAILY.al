report 50025 "Fund Unit Capital DAILY"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Fund Unit Capital DAILY.rdlc';

    dataset
    {
        dataitem(Date;Date)
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
                column(NavDate;Date."Period Start")
                {
                }

                trigger OnPreDataItem()
                begin
                    Fund.SetFilter("Fund Code",FundCode);
                    Fund.SetFilter("Date Filter",'..%1',Date."Period Start");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Date.SetRange("Period Start",StartDate,EndDate);
            end;

            trigger OnPreDataItem()
            begin
                if StartDate=0D then Error('Please Input Start Date');
                if EndDate=0D then Error('Please Input End Date');
                if FundCode='' then Error('Please Input FundCode');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(options)
                {
                    field("Start Date";StartDate)
                    {
                    }
                    field("End Date";EndDate)
                    {
                    }
                    field(Fund;FundCode)
                    {
                        TableRelation = Fund;
                    }
                }
            }
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
        StartDate: Date;
        EndDate: Date;
        FundCode: Code[30];
}

