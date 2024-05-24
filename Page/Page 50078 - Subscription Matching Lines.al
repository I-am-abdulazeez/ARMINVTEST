page 50078 "Subscription Matching Lines"
{
    PageType = ListPart;
    SourceTable = "Subscription Matching Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No";"Line No")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field("Value Date";"Value Date")
                {
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field(Reference;Reference)
                {
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field(Narration;Narration)
                {
                    MultiLine = true;
                    RowSpan = 2;
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field("Bank code";"Bank code")
                {
                }
                field("Credit Amount";"Credit Amount")
                {
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field("Payment Mode";"Payment Mode")
                {
                }
                field(Channel;Channel)
                {
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field(Matched;Matched)
                {
                    Style = Unfavorable;
                    StyleExpr = reject;
                }
                field("Non Client Transaction";"Non Client Transaction")
                {
                }
                field("Account No";"Account No")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field(Posted;Posted)
                {
                }
                field("Date Posted";"Date Posted")
                {
                }
                field("Time Posted";"Time Posted")
                {
                }
                field("Posted By";"Posted By")
                {
                }
                field(Select;Select)
                {
                }
                field("Fund Sub Account";"Fund Sub Account")
                {
                }
                field("Selected By";"Selected By")
                {
                }
                field(Rejected;Rejected)
                {
                }
                field("Rejection Comments";"Rejection Comments")
                {
                }
                field("Rejected by";"Rejected by")
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
        Updatestyle
    end;

    trigger OnOpenPage()
    begin
        Updatestyle
    end;

    var
        reject: Boolean;

    local procedure Updatestyle()
    begin
        if Rejected then
          reject:=true
        else
          reject:=false;
    end;
}

