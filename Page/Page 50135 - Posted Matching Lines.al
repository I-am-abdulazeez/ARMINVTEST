page 50135 "Posted Matching Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Subscription Matching Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Account No";"Account No")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field(Matched;Matched)
                {
                }
                field("Non Client Transaction";"Non Client Transaction")
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
                field("Date Posted";"Date Posted")
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

