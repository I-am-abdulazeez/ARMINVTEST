xmlport 50092 "Import Redemption Bank Status"
{
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement("<bankredemptionstatus>")
        {
            XmlName = 'BankRedemptionStatus';
            tableelement("Posted Redemption";"Posted Redemption")
            {
                AutoSave = false;
                AutoUpdate = true;
                XmlName = 'Redemption';
                fieldelement(TransactionNo;"Posted Redemption"."Recon No")
                {
                    FieldValidate = no;
                }
                fieldelement(BankResponseStatus;"Posted Redemption"."Bank Response Status")
                {
                }
                fieldelement(BankResponseComment;"Posted Redemption"."Bank Response Comment")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInsertRecord()
                begin
                    //MESSAGE("Posted Redemption"."Recon No");
                    postedred.Reset;
                    postedred.SetRange(postedred."Recon No","Posted Redemption"."Recon No");
                    if postedred.FindFirst then begin
                     // MESSAGE(postedred."Recon No");
                      if "Posted Redemption"."Bank Response Status" = "Posted Redemption"."Bank Response Status"::Successful then begin
                        postedred."Bank Response Status" := postedred."Bank Response Status"::Successful;
                        postedred."Processed By Bank":=true;
                        postedred.Modify;
                      end;
                      if "Posted Redemption"."Bank Response Status" ="Posted Redemption"."Bank Response Status"::Failed then begin
                        postedred."Bank Response Status" := postedred."Bank Response Status"::Failed;
                        postedred."Bank Response Comment" := "Posted Redemption"."Bank Response Comment";
                        postedred."Processed By Bank" := true;
                      postedred.Modify;

                    //Email Notification
                      NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Redemption',postedred.No,
                          postedred."Client Name",postedred."Client ID",'Failed at bank',postedred."Fund Code",postedred."Account No",
                      'Redemption',postedred."Total Amount Payable",3);
                      end;
                    end
                    else
                      Error('Transaction No %1 does not exist.',"Posted Redemption".No);
                end;

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                    ClientID: Code[40];
                begin
                end;

                trigger OnBeforeModifyRecord()
                begin
                    /*IF "Posted Redemption" ."Bank Response Status"= "Posted Redemption"."Bank Response Status"::Successful THEN
                      BEGIN
                        "Posted Redemption"."Processed By Bank":=TRUE;
                        "Posted Redemption".MODIFY;
                    END;*/
                    ////MESSAGE("Posted Redemption"."Recon No");

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

    var
        postedred: Record "Posted Redemption";
        AMT: Decimal;
        NotificationFunctions: Codeunit "Notification Functions";
}

