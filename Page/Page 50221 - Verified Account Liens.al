page 50221 "Verified Account Liens"
{
    CardPageID = "Lien Card";
    PageType = List;
    SourceTable = "Account Liens";
    SourceTableView = WHERE(status=CONST(Verified));

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
            }
        }
    }

    actions
    {
    }
}

