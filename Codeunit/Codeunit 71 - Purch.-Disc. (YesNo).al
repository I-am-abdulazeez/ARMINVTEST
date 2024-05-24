codeunit 71 "Purch.-Disc. (Yes/No)"
{
    // version NAVW113.02

    TableNo = "Purchase Line";

    trigger OnRun()
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if ConfirmManagement.ConfirmProcess(Text000,true) then
          CODEUNIT.Run(CODEUNIT::"Purch.-Calc.Discount",Rec);
    end;

    var
        Text000: Label 'Do you want to calculate the invoice discount?';
}

