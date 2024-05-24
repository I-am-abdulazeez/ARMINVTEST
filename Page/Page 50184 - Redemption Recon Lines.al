page 50184 "Redemption Recon Lines"
{
    PageType = ListPart;
    SourceTable = "Redemption Recon Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Date";"Transaction Date")
                {
                    Style = Favorable;
                    StyleExpr = match;
                }
                field("Value Date";"Value Date")
                {
                    Style = Favorable;
                    StyleExpr = match;
                }
                field(Reference;Reference)
                {
                    Style = Favorable;
                    StyleExpr = match;
                }
                field(Narration;Narration)
                {
                }
                field("Debit Amount";"Debit Amount")
                {
                }
                field("Credit Amount";"Credit Amount")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Bank Fee";"Bank Fee")
                {
                }
                field("Total Amount";"Total Amount")
                {
                }
                field("Manual Reference";"Manual Reference")
                {
                }
                field(Reconciled;Reconciled)
                {
                }
                field("Line No";"Line No")
                {
                }
                field("Reconciled Line No";"Reconciled Line No")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        updatestyle
    end;

    trigger OnModifyRecord(): Boolean
    begin
        updatestyle
    end;

    trigger OnOpenPage()
    begin
        updatestyle
    end;

    var
        match: Boolean;

    local procedure updatestyle()
    begin
        if Reconciled then
          match:=true
        else
          match:= false;
    end;
}

