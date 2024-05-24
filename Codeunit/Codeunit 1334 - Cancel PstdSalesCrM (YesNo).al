codeunit 1334 "Cancel PstdSalesCrM (Yes/No)"
{
    // version NAVW110.0

    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Sales Cr.Memo Header";

    trigger OnRun()
    begin
        CancelCrMemo(Rec);
    end;

    var
        CancelPostedCrMemoQst: Label 'The posted sales credit memo will be canceled, and a sales invoice will be created and posted, which reverses the posted sales credit memo. Do you want to continue?';
        OpenPostedInvQst: Label 'The invoice was successfully created. Do you want to open the posted invoice?';

    local procedure CancelCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
        CancelledDocument: Record "Cancelled Document";
        CancelPostedSalesCrMemo: Codeunit "Cancel Posted Sales Cr. Memo";
    begin
        CancelPostedSalesCrMemo.TestCorrectCrMemoIsAllowed(SalesCrMemoHeader);
        if Confirm(CancelPostedCrMemoQst) then
          if CancelPostedSalesCrMemo.CancelPostedCrMemo(SalesCrMemoHeader) then
            if Confirm(OpenPostedInvQst) then begin
              CancelledDocument.FindSalesCancelledCrMemo(SalesCrMemoHeader."No.");
              SalesInvHeader.Get(CancelledDocument."Cancelled By Doc. No.");
              PAGE.Run(PAGE::"Posted Sales Invoice",SalesInvHeader);
              exit(true);
            end;

        exit(false);
    end;
}

