page 50136 "Imported Statement Lines"
{
    PageType = ListPart;
    SourceTable = "Subscription Recon Lines";

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
                    Style = Favorable;
                    StyleExpr = match;
                }
                field("Debit Amount";"Debit Amount")
                {
                }
                field("Credit Amount";"Credit Amount")
                {
                }
                field(Channel;Channel)
                {
                }
                field(Reconciled;Reconciled)
                {
                    Editable = false;
                }
                field("Manual Reference";"Manual Reference")
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

