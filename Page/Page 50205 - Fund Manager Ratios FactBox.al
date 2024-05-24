page 50205 "Fund Manager Ratios FactBox"
{
    // version THL-LOAN-1.0.0

    PageType = CardPart;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            group("Fund Manager Contributions")
            {
                Caption = 'Fund Manager Contributions';
                field(ARMAmount;ARMAmount)
                {
                    Caption = 'ARM:';
                }
                field(IBTCAmount;IBTCAmount)
                {
                    Caption = 'IBTC:';
                }
                field(Veticamount;Veticamount)
                {
                    Caption = 'VETIVA:';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        i: Integer;
    begin
        /*FundManagers.RESET;
        IF FundManagers.FIND('-') THEN
        REPEAT
          i:=i+1;
          FMName[i]:=FundManagers.Name;
            FundMgrRatios.RESET;
            FundMgrRatios.SETRANGE(Product,"Loan Product Type");
            FundMgrRatios.SETRANGE("Fund Manager",FundManagers.Code);
            FundMgrRatios.SETFILTER(From,'<=%1',"Application Date");
            FundMgrRatios.SETFILTER("To",'>=%1',"Application Date");
            IF FundMgrRatios.FINDLAST THEN
            FMPercentage[i]:=FundMgrRatios.Percentage;
        UNTIL FundManagers.NEXT=0;
        
        FOR i:=1 TO 10 DO
        BEGIN
        CLEAR(FMName[i]);
        CLEAR(FMPercentage[i]);
        CLEAR(FMAmount[i]);
        END;
        
        FOR i:=1 TO 3 DO
          BEGIN
          FundMgrRatios.RESET;
          FundMgrRatios.SETRANGE("Fund Manager Name",FMName[i]);
          FundMgrRatios.SETFILTER(From,'>=%1',"Application Date");
          FundMgrRatios.SETFILTER("To",'<=%1',"Application Date");
          IF FundMgrRatios.FIND('-') THEN
           FMAmount[i]:=ROUND(FMPercentage[i]/100*"Approved Amount",0.01)
          ELSE BEGIN
          FundMgrRatios.RESET;
          FundMgrRatios.SETRANGE("Fund Manager Name",FMName[i]);
          FundMgrRatios.SETFILTER(From,'>=%1',"Application Date");
          FundMgrRatios.SETFILTER("To",'=%1',0D);
          IF FundMgrRatios.FIND('-') THEN
           FMAmount[i]:=ROUND(FMPercentage[i]/100*"Approved Amount",0.01);
          END;
        END;*/
        
        //ARM
        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'ARM');
        FundMgrRatios.SetFilter(From,'<%1',"Application Date");
        if FundMgrRatios.FindLast then
        ARMAmount:=Round(FundMgrRatios.Percentage/100*"Approved Amount");
        
        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'IBTC');
        FundMgrRatios.SetFilter(From,'<%1',"Application Date");
        if FundMgrRatios.FindLast then
        IBTCAmount:=Round(FundMgrRatios.Percentage/100*"Approved Amount");
        
        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'VETIVA');
        FundMgrRatios.SetFilter(From,'<%1',"Application Date");
        if FundMgrRatios.FindLast then
        Veticamount:=Round(FundMgrRatios.Percentage/100*"Approved Amount");

    end;

    var
        FundMgrRatios: Record "Product Fund Manager Ratio";
        FundManagers: Record "Fund Managers";
        FMPercentage: array [10] of Decimal;
        FMAmount: array [10] of Decimal;
        FMName: array [10] of Text;
        ARMAmount: Decimal;
        IBTCAmount: Decimal;
        Veticamount: Decimal;
}

