xmlport 50100 "Import Unit Transfer"
{
    // version IntegraData

    Format = VariableText;

    schema
    {
        textelement(FundTransfer)
        {
            tableelement("Fund Transfer Lines";"Fund Transfer Lines")
            {
                XmlName = 'FundTransfer';
                fieldelement(FromAccount;"Fund Transfer Lines"."From Account No")
                {
                    FieldValidate = yes;
                }
                fieldelement(ToAccount;"Fund Transfer Lines"."To Account No")
                {
                    FieldValidate = yes;
                }
                fieldelement(ValueDate;"Fund Transfer Lines"."Value Date")
                {
                    FieldValidate = no;
                }
                fieldelement(TransferAmount;"Fund Transfer Lines".Amount)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                    ClientID: Code[40];
                begin
                    //
                    // IF type = 0 THEN
                    //  "Fund Transfer Lines".Type := "Fund Transfer Lines".Type::"Same Fund"
                    // ELSE
                    //  "Fund Transfer Lines".Type := "Fund Transfer Lines".Type::"Across Funds";
                    "Fund Transfer Lines".Type := type;
                    "Fund Transfer Lines"."Transfer Type" := tansferType;
                    "Fund Transfer Lines"."Header No" := BatchNo;
                    "Fund Transfer Lines"."Data Source" := 'IMPORTED';
                    "Fund Transfer Lines"."Transaction Date" := TransactionDate;
                    "Fund Transfer Lines"."Created By" := UserId;
                    "Fund Transfer Lines"."Creation Date" := Today;
                    "Fund Transfer Lines"."Fund Transfer Status" := "Fund Transfer Lines"."Fund Transfer Status"::Received;
                    "Fund Transfer Lines"."Document Link" := documentLink;
                end;

                trigger OnBeforeModifyRecord()
                begin
                    window.Update(1,"Fund Transfer Lines"."From Account No");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading #1#####');
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        client: Record Client;
        window: Dialog;
        "entryNo.": Integer;
        FHeader: Record "Fund Transfer Header";
        BatchNo: Code[10];
        TransactionDate: Date;
        type: Option;
        tansferType: Option;
        documentLink: Text[150];

    procedure GetHeader(var Header: Record "Fund Transfer Header")
    begin
        FHeader.Copy(Header);
        BatchNo := Header.No;
        TransactionDate := Header."Transaction Date";
        type := Header.Type;
        tansferType := Header."Transfer Type";
        documentLink := Header."Document Link";
    end;
}

