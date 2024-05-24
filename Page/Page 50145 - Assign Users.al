page 50145 "Assign Users"
{
    DeleteAllowed = true;
    PageType = Worksheet;
    SourceTable = "Assign users Matching";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assigned to User";"Assigned to User")
                {
                }
                field("Reassign to User";"Reassign to User")
                {
                }
                field(Assigned;Assigned)
                {
                    Editable = false;
                }
                field("Lines Assigned";"Lines Assigned")
                {
                }
                field(Reassigned;Reassigned)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Assign)
            {
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SubscriptionMatchingLines: Record "Subscription Matching Lines";
                    AssignusersMatching: Record "Assign users Matching";
                    Users: array [50] of Code[50];
                    i: Integer;
                    noperuser: Integer;
                    n: Integer;
                begin
                    noofusers:=0;
                    Totalno:=0;
                    AssignusersMatching.Reset;
                    AssignusersMatching.SetRange("Matching Header","Matching Header");
                    if AssignusersMatching.FindSet then begin

                         repeat
                        AssignusersMatching.TestField("Assigned to User");
                        noofusers:=noofusers+1;
                        Users[noofusers]:=AssignusersMatching."Assigned to User";
                        AssignusersMatching.Assigned:=true;
                        AssignusersMatching.Modify;
                        until AssignusersMatching.Next=0;
                      end else Error('There is no user to assign');

                    SubscriptionMatchingLines.Reset;
                    SubscriptionMatchingLines.SetRange("Header No","Matching Header");
                    SubscriptionMatchingLines.SetRange(Posted,false);
                    SubscriptionMatchingLines.SetRange(Matched,false);
                    SubscriptionMatchingLines.SetRange("Non Client Transaction",false);
                    SubscriptionMatchingLines.SetFilter("Assigned User",'=%1','');
                    if SubscriptionMatchingLines.FindSet then begin
                      Totalno:=SubscriptionMatchingLines.Count;
                      noperuser:=Round(Totalno/noofusers,1,'=');
                      i:=1;
                      n:=0;
                      repeat

                        SubscriptionMatchingLines."Assigned User":=Users[i];
                        SubscriptionMatchingLines."Assigned By":=UserId;
                        SubscriptionMatchingLines."Date Time Assigned":=CurrentDateTime;
                        SubscriptionMatchingLines.Modify;
                        n:=n+1;
                        if n=noperuser then begin
                          n:=0;
                          i:=i+1;
                        end;

                      until SubscriptionMatchingLines.Next=0

                    end;
                    Message('Assigning complete');
                end;
            }
            action(ReAssign)
            {
                Image = Route;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SubscriptionMatchingLines: Record "Subscription Matching Lines";
                    AssignusersMatching: Record "Assign users Matching";
                    Users: array [50] of Code[50];
                    i: Integer;
                    noperuser: Integer;
                    n: Integer;
                begin
                    TestField("Reassign to User");
                    noofusers:=0;
                    Totalno:=0;
                    AssignusersMatching.Reset;
                    AssignusersMatching.SetRange("Matching Header","Matching Header");
                    AssignusersMatching.SetRange("Assigned to User","Reassign to User");
                    if not AssignusersMatching.FindFirst then begin
                      AssignusersMatching.Init;
                      AssignusersMatching."Matching Header":="Matching Header";
                      AssignusersMatching."Assigned to User":="Reassign to User";
                      AssignusersMatching.Insert;
                    end;

                    SubscriptionMatchingLines.Reset;
                    SubscriptionMatchingLines.SetRange("Header No","Matching Header");
                    SubscriptionMatchingLines.SetRange(Posted,false);
                    //SubscriptionMatchingLines.SETRANGE(Matched,FALSE);
                    //SubscriptionMatchingLines.SETRANGE("Non Client Transaction",FALSE);
                    SubscriptionMatchingLines.SetFilter("Assigned User",'=%1',"Assigned to User");
                    if SubscriptionMatchingLines.FindSet then begin
                       repeat

                        SubscriptionMatchingLines."Assigned User":="Reassign to User";
                        SubscriptionMatchingLines."Assigned By":=UserId;
                        SubscriptionMatchingLines."Date Time Assigned":=CurrentDateTime;
                        SubscriptionMatchingLines.Modify;

                      until SubscriptionMatchingLines.Next=0

                    end;
                    Message('ReAssigning complete');
                end;
            }
        }
    }

    var
        TotalNoOflines: Integer;
        NoofLinesAssigned: Integer;
        Criteria: Option Equally,"Manual Input per person";
        Totalno: Integer;
        noofusers: Integer;
}

