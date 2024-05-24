xmlport 50022 "Import subscription"
{
    // version IntegraData

    Format = VariableText;

    schema
    {
        textelement(Redemptions)
        {
            tableelement(Subscription;Subscription)
            {
                XmlName = 'Redemption';
                fieldelement(Vdate;Subscription."Value Date")
                {
                    FieldValidate = yes;
                }
                fieldelement(Tdate;Subscription."Transaction Date")
                {
                    FieldValidate = yes;
                }
                fieldelement(ClientID;Subscription."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(FundCode;Subscription."Fund Code")
                {
                    FieldValidate = yes;
                }
                fieldelement(Amount;Subscription.Amount)
                {
                    FieldValidate = yes;
                }
                fieldelement(Narration;Subscription.Remarks)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                    ClientID: Code[40];
                begin
                    ClientID:='';
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Old Account Number",Subscription ."Client ID");
                    ClientAccount.SetRange("Fund No",Subscription."Fund Code");
                    if ClientAccount.FindFirst then  begin

                      Subscription."Account No":=ClientAccount."Account No";
                      Subscription."Client ID":=ClientAccount."Client ID";

                    end else begin

                      ClientAccount.Reset;
                      ClientAccount.SetRange("Old MembershipID",Subscription."Client ID");
                      ClientAccount.SetRange("Fund No",Subscription."Fund Code");
                      if ClientAccount.FindFirst then
                        Subscription."Account No":=ClientAccount."Account No"
                      else begin
                      ClientAccount.Reset;
                      ClientAccount.SetRange("Client ID",Subscription."Client ID");
                      ClientAccount.SetRange("Fund No",Subscription."Fund Code");
                      if ClientAccount.FindFirst then
                        Subscription."Account No":=ClientAccount."Account No"
                      else begin
                        ClientAccount.Reset;
                        ClientAccount.SetRange("Old Account Number",Subscription."Client ID");
                        //ClientAccount.SETRANGE("Fund No",Subscription."Fund Code");
                        if ClientAccount.FindFirst then begin
                          ClientID:=ClientAccount."Client ID";
                          ClientAccount.Reset;
                          ClientAccount.SetRange("Client ID",ClientID);
                          ClientAccount.SetRange("Fund No",Subscription."Fund Code");
                         if ClientAccount.FindFirst then begin
                          Subscription."Account No":=ClientAccount."Account No";
                           Subscription."Client ID":=ClientID;

                        end  else begin
                          if  StrPos(Subscription."Client ID",'PDY')=1 then begin
                            ClientID:=DelStr(Subscription."Client ID",1,3);
                            Subscription."Account No":=ClientAdministration.NewPaydayACC(ClientID,Subscription."Fund Code",Subscription."Client ID");
                            Subscription."Client ID":=ClientID;
                          end else
                          Subscription."Account No":=ClientAdministration.NewAccountReturnACC(ClientID,Subscription."Fund Code");
                        //Subscription."Account No":=Subscription."Client ID";
                        end
                         end else begin
                         ///ne
                            ClientAccount.Reset;
                            ClientAccount.SetRange("Client ID",Subscription."Client ID");

                              if ClientAccount.FindFirst then begin
                              ClientID:=ClientAccount."Client ID";
                              ClientAccount.Reset;
                              ClientAccount.SetRange("Client ID",ClientID);
                              ClientAccount.SetRange("Fund No",Subscription."Fund Code");
                               if ClientAccount.FindFirst then begin
                                  Subscription."Account No":=ClientAccount."Account No";
                                  Subscription."Client ID":=ClientID;

                              end  else begin
                                if  StrPos(Subscription."Client ID",'PDY')=1 then begin
                                  ClientID:=DelStr(Subscription."Client ID",1,3);
                                  Subscription."Account No":=ClientAdministration.NewPaydayACC(ClientID,Subscription."Fund Code",Subscription."Client ID");
                                  Subscription."Client ID":=ClientID;
                                end else
                                Subscription."Account No":=ClientAdministration.NewAccountReturnACC(Subscription."Client ID",Subscription."Fund Code");
                              //Subscription."Account No":=Subscription."Client ID";
                              end
                             end else begin
                    //start of new account
                                client.Reset;
                                client.SetRange("Membership ID",Subscription."Client ID");
                              if client.FindFirst then begin
                                  ClientID:=ClientAccount."Client ID";
                                  if  StrPos(Subscription."Client ID",'PDY')=1 then begin
                                      ClientID:=DelStr(Subscription."Client ID",1,3);
                                      Subscription."Account No":=ClientAdministration.NewPaydayACC(ClientID,Subscription."Fund Code",Subscription."Client ID");
                                      Subscription."Client ID":=ClientID;
                                    end else
                                    Subscription."Account No":=ClientAdministration.NewAccountReturnACC(Subscription."Client ID",Subscription."Fund Code");
                                  //Subscription."Account No":=Subscription."Client ID";

                             end else
                                Error('Client %1 does not exist ',Subscription."Client ID");

                    //end




                              end
                        end
                      end
                    end;
                    end;
                    if Subscription."Account No"='' then
                      Error('Account does not exist for %1',Subscription."Client ID");
                    Subscription."Subscription Status":=Subscription."Subscription Status"::Confirmed;
                    Subscription.Validate("Account No");
                    Subscription.Validate("Client ID");
                end;

                trigger OnBeforeModifyRecord()
                begin
                    window.Update(1,Subscription."Account No");
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
}

