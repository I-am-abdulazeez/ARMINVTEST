page 50241 "Reversal Card View"
{
    // version Rev-1.0

    DeleteAllowed = false;
    InsertAllowed = false;
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
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Dividend Mandate";"Dividend Mandate")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Account Status";"Account Status")
                {
                }
                field("Reversal Approval";"Reversal Approval")
                {
                    Editable = false;
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
                    Editable = false;
                }
                field("Split Percentage";"Split Percentage")
                {
                    Editable = false;
                }
                field("Old MembershipID";"Old MembershipID")
                {
                    Editable = false;
                }
                field("Old Account Number";"Old Account Number")
                {
                    Editable = false;
                }
                field("Institutional Active Fund";"Institutional Active Fund")
                {
                    Editable = false;
                }
                field("Institutional Active Date";"Institutional Active Date")
                {
                }
                field("Fund Group";"Fund Group")
                {
                }
                field("Staff ID";"Staff ID")
                {
                    Editable = false;
                }
                field("Nominee Client";"Nominee Client")
                {
                    Editable = false;
                }
                field("Portfolio Code";"Portfolio Code")
                {
                    Editable = false;
                }
                field("Document Link";"Document Link")
                {
                    Editable = false;
                }
                field("Rejection Reason";"Reversal Rejection Reason")
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
                field("Total withdrawn Amount On Hold";"Total withdrawn Amount On Hold")
                {
                }
                field("Net Amount On Hold";"Net Amount On Hold")
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
            action(Transactions)
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewPendingClientTransactions("Client ID");
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsPending;

                trigger OnAction()
                begin
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Client ID",Rec."Client ID");
                    ClientAccount.SetRange("Account No",Rec."Account No");
                    ClientAccount.SetRange("Reversal Approval",ClientAccount."Reversal Approval"::pending);
                    if ClientAccount.FindFirst then begin
                      TempClientTransaction.Reset;
                     TempClientTransaction.SetRange("Client ID",ClientAccount."Client ID");
                     TempClientTransaction.SetRange("Account No",ClientAccount."Account No");
                     TempClientTransaction.SetRange(Approved,false);
                     TempClientTransaction.SetRange(Rejected,false);
                     if TempClientTransaction.FindFirst then begin
                       repeat
                       TempClientTransaction.Approved := true;
                       TempClientTransaction."Approved By" := UserId;
                       TempClientTransaction."Approved Date" := Today;
                       TempClientTransaction.Modify;
                       until TempClientTransaction.Next=0;
                       end;
                      ClientAccount."Reversal Approval" := ClientAccount."Reversal Approval"::approved;
                      ClientAccount.Modify;
                      Message('Approved');
                      end;
                end;
            }
            action(Reject)
            {
                Image = Cancel;
                Visible = IsPending;

                trigger OnAction()
                begin
                    if "Reversal Rejection Reason" = '' then
                      Error('Kindly state a rejection reason before rejecting.');
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Client ID",Rec."Client ID");
                    ClientAccount.SetRange("Account No",Rec."Account No");
                    ClientAccount.SetRange("Reversal Approval",ClientAccount."Reversal Approval"::pending);
                    if ClientAccount.FindFirst then begin
                      TempClientTransaction.Reset;
                     TempClientTransaction.SetRange("Client ID",ClientAccount."Client ID");
                     TempClientTransaction.SetRange("Account No",ClientAccount."Account No");
                     TempClientTransaction.SetRange(Approved,false);
                     TempClientTransaction.SetRange(Rejected,false);
                     if TempClientTransaction.FindFirst then begin
                       repeat
                       TempClientTransaction.Rejected := true;
                       TempClientTransaction."Rejected By" := UserId;
                       TempClientTransaction."Rejected Date" := Today;
                       TempClientTransaction.Modify;
                       until TempClientTransaction.Next=0;
                       end;
                      ClientAccount."Reversal Approval" := ClientAccount."Reversal Approval"::reject;
                      ClientAccount.Modify;
                      Message('Rejected');
                      end;
                end;
            }
            action("View Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Document Link");
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

    trigger OnInit()
    begin
        IsApproved := false;
        IsPending := false;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Reversal Approval" = Rec."Reversal Approval"::approved then begin
          IsApproved := true;
          IsPending := false;
          end else begin
          IsApproved := false;
          end;
          if Rec."Reversal Approval" = Rec."Reversal Approval"::pending then begin
          IsPending := true;
          IsApproved := false;
          end else begin
          IsPending := false;
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
        ClientAccount: Record "Client Account";
        IsPending: Boolean;
        IsApproved: Boolean;
        TempClientTransaction: Record "Temp Client Transactions";

    local procedure getclientID()
    begin
    end;
}

