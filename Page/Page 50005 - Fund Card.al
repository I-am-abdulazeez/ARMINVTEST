page 50005 "Fund Card"
{
    PageType = Card;
    SourceTable = Fund;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fund Code";"Fund Code")
                {
                    ShowMandatory = true;
                }
                field(Name;Name)
                {
                    ShowMandatory = true;
                }
                field("Fund Type";"Fund Type")
                {
                }
                field("Dividend Distribution Type";"Dividend Distribution Type")
                {
                }
                field(Picture;Picture)
                {
                }
                field("Dividend Period";"Dividend Period")
                {
                }
                field("Active Fund";"Active Fund")
                {
                    Editable = false;
                }
                field("Approval Status";"Approval Status")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field("Asset Class";"Asset Class")
                {
                }
                field(Classification;Classification)
                {
                }
                field(Sector;Sector)
                {
                }
                field("Fund Group";"Fund Group")
                {
                }
                field(Unitized;Unitized)
                {
                }
                field("Ext Registrar Verification Req";"Ext Registrar Verification Req")
                {
                }
                field("Minimum Holding Period";"Minimum Holding Period")
                {
                }
                field("Percentage Penalty";"Percentage Penalty")
                {
                }
                field("Minimum Holding Balance";"Minimum Holding Balance")
                {
                    Caption = 'Minimum Holding Balance*';
                }
            }
            group("Fund Pricing")
            {
                field("Bid Price Factor";"Bid Price Factor")
                {
                    Caption = 'Bid Price Factor*';
                }
                field("Offer Price Factor";"Offer Price Factor")
                {
                    Caption = 'Offer Price Factor*';
                }
                field("Rounded Price";"Rounded Price")
                {
                }
                field("Rounded Nav";"Rounded Nav")
                {
                }
                field("Rounded Units";"Rounded Units")
                {
                }
                field("Special Bid Price";"Special Bid Price")
                {
                }
                field("Special offer Price";"Special offer Price")
                {
                }
                field("Special Price Date";"Special Price Date")
                {
                }
            }
            group("Fund Summary")
            {
                field("No of Units";"No of Units")
                {
                }
                field("No of Accounts";"No of Accounts")
                {
                }
                field(NAV;NAV)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Fund Prices")
            {
                Image = ResourcePrice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Fund Prices";
                RunPageLink = "Fund No."=FIELD("Fund Code");
            }
            action("Fund Bank Accounts")
            {
                Image = BankAccount;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Fund Bank Accounts";
                RunPageLink = "Fund Code"=FIELD("Fund Code");
            }
            action("Client Accounts")
            {
                Image = VendorLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewFundAccountsSubscribed("Fund Code");
                end;
            }
            action("Payout Charges")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Fund Payout Charges";
                RunPageLink = "Fund No"=FIELD("Fund Code");
            }
            action("Send Fund for Verification")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Visible = Showverify;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to send this Fund for verification?') then
                      Error('');
                    "Approval Status":="Approval Status"::"Pending Approval";
                    Modify;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund Code","No of Units");
        toggleshow
    end;

    trigger OnOpenPage()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund Code","No of Units");
        toggleshow
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
        Showverify: Boolean;

    local procedure toggleshow()
    begin
        if ("Approval Status"="Approval Status"::Created) or ("Approval Status"="Approval Status"::Rejected) then
          Showverify:=true
        else
          Showverify:=false;
    end;
}

