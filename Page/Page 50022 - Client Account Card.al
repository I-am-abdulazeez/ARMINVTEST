page 50022 "Client Account Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Client Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                    ShowMandatory = true;
                }
                field("Client Name";"Client Name")
                {
                }
                field("Fund No";"Fund No")
                {
                    ShowMandatory = true;
                }
                field("Phone No.";"Phone No.")
                {
                    Editable = false;
                }
                field("Bank Code";"Bank Code")
                {
                    Editable = false;
                }
                field("Bank Branch";"Bank Branch")
                {
                    Editable = false;
                }
                field("Bank Account Name";"Bank Account Name")
                {
                    Editable = false;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    Editable = false;
                }
                field("Foreign Bank Account";"Foreign Bank Account")
                {
                    Caption = 'Foreign Bank Name';
                }
                field("Swift Code";"Swift Code")
                {
                }
                field("Routing No";"Routing No")
                {
                    Caption = 'Routing(ABA) No';
                }
                field("Benificiary Account Number";"Benificiary Account Number")
                {
                }
                field("Final Credit";"Final Credit")
                {
                }
                field("E-Mail";"E-Mail")
                {
                    Editable = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                }
                field("Last Modified DateTime";"Last Modified DateTime")
                {
                }
                field("KYC Tier";"KYC Tier")
                {
                    ShowMandatory = true;
                }
                field("Dividend Mandate";"Dividend Mandate")
                {
                    ShowMandatory = true;
                }
                field("Account Status";"Account Status")
                {
                }
                field("Online Indemnity Exist";"Online Indemnity Exist")
                {
                }
                field("Direct Debit Exist";"Direct Debit Exist")
                {
                }
                field("Split Dividend";"Split Dividend")
                {
                }
                field("Account No To Split To";"Account No To Split To")
                {
                }
                field("Split Percentage";"Split Percentage")
                {
                }
                field("Old MembershipID";"Old MembershipID")
                {
                    Editable = false;
                }
                field("Old Account Number";"Old Account Number")
                {
                }
                field("Institutional Active Fund";"Institutional Active Fund")
                {
                }
                field("Institutional Active Date";"Institutional Active Date")
                {
                }
                field("Fund Group";"Fund Group")
                {
                }
                field("Staff ID";"Staff ID")
                {
                }
                field("Nominee Client";"Nominee Client")
                {
                }
                field("Portfolio Code";"Portfolio Code")
                {
                }
            }
            group("Account Summary")
            {
                field("No of Units";"No of Units")
                {
                }
                field(NAV;NAV)
                {
                    DecimalPlaces = 4:4;
                    Editable = false;
                }
                field("Total Amount Invested";"Total Amount Invested")
                {
                }
                field("Total Amount Withdrawn";"Total Amount Withdrawn")
                {
                }
                field("Net Accrued Interest";"Net Accrued Interest")
                {
                    Caption = 'Total Accrued Interest';
                }
                field("Charges on Accrued Interest";"Charges on Accrued Interest")
                {
                }
                field("Accrued Interest";"Accrued Interest")
                {
                    Caption = 'Net Accrued Interest';
                }
                field("Total Amount on Hold";"Total Amount on Hold")
                {
                }
            }
            group("Loyalty Details")
            {
                field("Referrer Membership ID";"Referrer Membership ID")
                {
                }
                field("Clients Referred";"Clients Referred")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Account Statement")
            {
                Image = SalesTaxStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewClientstatement("Account No",1);
                end;
            }
            action(Liens)
            {
                Image = ReceivableBill;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewAccountLines("Account No",1);
                end;
            }
            action("Accrued Dividends")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewAccruedinterest("Account No",1);
                end;
            }
            action("Historical Dividends")
            {
                Image = RegisteredDocs;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.Viewpostedinterest("Account No",1);
                end;
            }
            action("Institutional Account Statement")
            {
                Image = SalesTaxStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewInstClientstatement("Client ID","Fund Group");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
         NAV:=FundAdministration.GetNAV(Today,"Fund No","No of Units");
         //CHARGES ON INTEREST
         "Net Accrued Interest" := "Accrued Interest" - "Charges on Accrued Interest";
         //END
        if "Bank Account Number" = '' then begin

          end;
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
        NetAccruedInterest: Decimal;
        FundTransMgt: Codeunit "Fund Transaction Management";
        AvailableInterest: Decimal;
        ClientTrans: Record "Client Transactions";
        NetAmountOnHold: Decimal;

    local procedure getclientID()
    begin
    end;
}

