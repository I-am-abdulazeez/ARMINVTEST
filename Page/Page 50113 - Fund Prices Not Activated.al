page 50113 "Fund Prices Not Activated"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = List;
    SourceTable = "Fund Prices";
    SourceTableView = WHERE(Activated=CONST(false),
                            "Send for activation"=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field("Fund No.";"Fund No.")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Mid Price";"Mid Price")
                {
                    Editable = false;
                }
                field("Bid Price";"Bid Price")
                {
                    Editable = false;
                }
                field("Offer Price";"Offer Price")
                {
                    Editable = false;
                }
                field("Bid Price Factor";"Bid Price Factor")
                {
                }
                field("Offer Price Factor";"Offer Price Factor")
                {
                }
                field(Comments;Comments)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Activate)
            {
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundAdministration.ActivatePrices;
                end;
            }
            action("Select All")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundPrices.Reset;
                    FundPrices.SetRange(Activated,false);
                    FundPrices.SetRange("Send for activation",true);
                    if  FundPrices.FindFirst then begin
                      repeat
                        FundPrices.Validate(Select,true);

                        FundPrices.Modify;
                      until FundPrices.Next=0;
                    end
                end;
            }
            action("Un Select All")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundPrices.Reset;
                    FundPrices.SetRange(Select,true);
                    FundPrices.SetRange(Activated,false);
                    FundPrices.SetRange("Send for activation",true);
                    if  FundPrices.FindFirst then begin
                      repeat
                        FundPrices.Validate(Select,false);
                        FundPrices."Selected By":='';
                        FundPrices.Modify;
                      until FundPrices.Next=0;
                    end
                end;
            }
            action(Reject)
            {
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundAdministration.Reject;
                end;
            }
        }
    }

    var
        FundAdministration: Codeunit "Fund Administration";
        FundPrices: Record "Fund Prices";
}

