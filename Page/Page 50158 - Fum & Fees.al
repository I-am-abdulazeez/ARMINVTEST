page 50158 "Fum & Fees"
{
    PageType = List;
    SourceTable = "FUM & Fees";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agent Code";"Agent Code")
                {
                }
                field("Agent Name";"Agent Name")
                {
                }
                field(Date;Date)
                {
                }
                field(FUM;FUM)
                {
                }
                field(Fees;Fees)
                {
                }
            }
        }
    }

    actions
    {
    }
}

