page 50224 "Rejected Account Liens"
{
    CardPageID = "Lien Card";
    PageType = List;
    SourceTable = "Account Liens";
    SourceTableView = WHERE(status=CONST(Rejected));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lien No";"Lien No")
                {
                }
                field(Description;Description)
                {
                }
                field("Account No";"Account No")
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field(status;status)
                {
                }
                field(Amount;Amount)
                {
                }
                field(Comment;Comment)
                {
                }
            }
        }
    }

    actions
    {
    }
}
