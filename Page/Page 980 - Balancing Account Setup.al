page 980 "Balancing Account Setup"
{
    // version NAVW110.0

    Caption = 'Balancing Account Setup';
    DataCaptionExpression = PageCaption;
    PageType = StandardDialog;
    SourceTable = "Payment Registration Setup";

    layout
    {
        area(content)
        {
            group(Control4)
            {
                InstructionalText = 'Select the balance account that you want to register payments for.';
                ShowCaption = false;
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balancing Account';
                    ToolTip = 'Specifies the account number that is used as the balancing account for payments.';
                }
                field("Use this Account as Def.";"Use this Account as Def.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Use this Account as Default';
                    ToolTip = 'Specifies if the Date Received and the Amount Received fields are automatically filled when you select the Payment Made check box.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Get(UserId);
        PageCaption := '';
    end;

    var
        PageCaption: Text[10];
}

