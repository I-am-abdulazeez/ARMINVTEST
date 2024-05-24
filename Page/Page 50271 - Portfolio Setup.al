page 50271 "Portfolio Setup"
{
    // version MFD-1.0

    PageType = List;
    SourceTable = Portfolio;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    Visible = false;
                }
                field("Portfolio Code";"Portfolio Code")
                {
                }
                field("Instrument Id";"Instrument Id")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Import Portfolio")
            {
                Promoted = true;
                PromotedIsBig = true;
                RunObject = XMLport "Import Portfolio";
            }
        }
    }
}

