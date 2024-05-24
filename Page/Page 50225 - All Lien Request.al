page 50225 "All Lien Request"
{
    CardPageID = "Lien Card";
    PageType = List;
    SourceTable = "Account Liens";

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

