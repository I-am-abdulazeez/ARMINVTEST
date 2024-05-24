page 50138 "Agent Commissions"
{
    PageType = List;
    SourceTable = "Commision structure";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Description;Description)
                {
                }
                field("Calculation Type";"Calculation Type")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Fee %";"Fee %")
                {
                }
                field("Agent Fee %";"Agent Fee %")
                {
                }
                field("ARM Fee %";"ARM Fee %")
                {
                }
                field("ARM Ratio";"ARM Fees %")
                {
                }
                field("IC Ratio";"IC Fees %")
                {
                }
                field("Max Comm %";"Max Comm %")
                {
                }
                field("Max Due to AE %";"Max Due to AE %")
                {
                }
                field("Amount Per New Client";"Amount Per New Client")
                {
                }
                field("Amount Per DDM";"Amount Per DDM")
                {
                }
            }
        }
    }

    actions
    {
    }
}

