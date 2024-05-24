codeunit 443 "Sales-Post Prepayment (Yes/No)"
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Do you want to post the prepayments for %1 %2?';
        Text001: Label 'Do you want to post a credit memo for the prepayments for %1 %2?';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";

    [Scope('Personalization')]
    procedure PostPrepmtInvoiceYN(var SalesHeader2: Record "Sales Header";Print: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ConfirmManagement: Codeunit "Confirm Management";
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
    begin
        SalesHeader.Copy(SalesHeader2);
        with SalesHeader do begin
          if not ConfirmManagement.ConfirmProcess(
               StrSubstNo(Text000,"Document Type","No."),true)
          then
            exit;

          SalesPostPrepayments.Invoice(SalesHeader);

          if Print then
            GetReport(SalesHeader,0);

          Commit;
          SalesHeader2 := SalesHeader;
        end;
    end;

    [Scope('Personalization')]
    procedure PostPrepmtCrMemoYN(var SalesHeader2: Record "Sales Header";Print: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ConfirmManagement: Codeunit "Confirm Management";
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
    begin
        SalesHeader.Copy(SalesHeader2);
        with SalesHeader do begin
          if not ConfirmManagement.ConfirmProcess(
               StrSubstNo(Text001,"Document Type","No."),true)
          then
            exit;

          SalesPostPrepayments.CreditMemo(SalesHeader);

          if Print then
            GetReport(SalesHeader,1);

          Commit;
          SalesHeader2 := SalesHeader;
        end;
    end;

    local procedure GetReport(var SalesHeader: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo")
    begin
        with SalesHeader do
          case DocumentType of
            DocumentType::Invoice:
              begin
                SalesInvHeader."No." := "Last Prepayment No.";
                SalesInvHeader.SetRecFilter;
                SalesInvHeader.PrintRecords(false);
              end;
            DocumentType::"Credit Memo":
              begin
                SalesCrMemoHeader."No." := "Last Prepmt. Cr. Memo No.";
                SalesCrMemoHeader.SetRecFilter;
                SalesCrMemoHeader.PrintRecords(false);
              end;
          end;
    end;
}

