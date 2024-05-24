page 50188 "Fund Prices Upload"
{
    PageType = List;
    SourceTable = "Fund Prices";
    SourceTableView = WHERE(Activated=CONST(false),
                            "Send for activation"=CONST(false));

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
                }
                field("Value Date";"Value Date")
                {
                }
                field("Mid Price";"Mid Price")
                {
                }
                field("Bid Price";"Bid Price")
                {
                }
                field("Offer Price";"Offer Price")
                {
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
            action("Send Price for Activation")
            {
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundAdministration.SendPriceforActivation;
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
                    FundPrices.SetRange("Send for activation",false);
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
                    FundPrices.SetRange("Send for activation",false);
                    if  FundPrices.FindFirst then begin
                      repeat
                        FundPrices.Validate(Select,false);

                        FundPrices.Modify;
                      until FundPrices.Next=0;
                    end
                end;
            }
            action("Import Prices")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ImportPrices);
                    ImportPrices.Run
                end;
            }
        }
    }

    var
        FundAdministration: Codeunit "Fund Administration";
        ImportPrices: XMLport "Import Price";
        FundPrices: Record "Fund Prices";
}

