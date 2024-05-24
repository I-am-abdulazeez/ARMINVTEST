page 50165 "Fund Card Approvals"
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
                }
                field(Name;Name)
                {
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
                }
            }
            group("Fund Pricing")
            {
                field("Bid Price Factor";"Bid Price Factor")
                {
                }
                field("Offer Price Factor";"Offer Price Factor")
                {
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
            action("Approve Fund")
            {
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not "Active Fund" then  begin
                      "Active Fund":=true;
                      "Approval Status":="Approval Status"::Approved;
                      Modify;
                    end

                    else Error('Fund already Active');
                end;
            }
            action("Reject Fund")
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if "Active Fund" then  begin
                      "Active Fund":=false;
                      "Approval Status":="Approval Status"::Rejected;
                      Modify;
                    end

                    else Error('Fund already In Active');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund Code","No of Units");
    end;

    trigger OnOpenPage()
    begin
        NAV:=FundAdministration.GetNAV(Today,"Fund Code","No of Units");
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
}

