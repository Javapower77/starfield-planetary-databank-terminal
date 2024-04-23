ScriptName Fragments:Terminals:TERM_RecruitmentTerminal_Me_002D1D2C Extends TerminalMenu hidden

;-- Variables ---------------------------------------
ObjectReference HiredRef

;-- Properties --------------------------------------
Int Property iCost Auto
MiscObject Property Credits Auto
ActorBase Property Employee01 Auto
ActorBase Property Employee02 Auto
ActorBase Property Employee03 Auto
ActorBase Property Employee04 Auto
ActorValue Property ActiveEmployees Auto
GlobalVariable Property Recruitment_CurrentRecruits Auto
GlobalVariable Property Recruitment_CanRecruit Auto
GlobalVariable Property Recruitment_MaxRecruits Auto
GlobalVariable Property EmployeeGlobal Auto
GlobalVariable Property EmployeeGlobal02 Auto
GlobalVariable Property EmployeeGlobal03 Auto
GlobalVariable Property EmployeeGlobal04 Auto

;-- Functions ---------------------------------------

Function Fragment_TerminalMenu_01(ObjectReference akTerminalRef)
  ObjectReference myWorkshop = akTerminalRef.GetWorkshop() ; #DEBUG_LINE_NO:24
  If myWorkshop as Bool ; #DEBUG_LINE_NO:25
    HiredRef = Game.GetPlayer().PlaceActorAtMe(Employee01, 1, None, False, False, False, None, True) as ObjectReference ; #DEBUG_LINE_NO:26
    Game.GetPlayer().RemoveItem(Credits as Form, iCost, False, None) ; #DEBUG_LINE_NO:27
    akTerminalRef.SetValue(ActiveEmployees, akTerminalRef.GetValue(ActiveEmployees) + 1.0) ; #DEBUG_LINE_NO:28
    Recruitment_CurrentRecruits.SetValue(akTerminalRef.GetValue(ActiveEmployees)) ; #DEBUG_LINE_NO:29
    EmployeeGlobal.SetValue(EmployeeGlobal.GetValue() - 1.0) ; #DEBUG_LINE_NO:30
    myWorkshop.AssignCrew(HiredRef as Actor) ; #DEBUG_LINE_NO:31
    If Recruitment_CurrentRecruits.GetValue() < Recruitment_MaxRecruits.GetValue() ; #DEBUG_LINE_NO:32
      Recruitment_CanRecruit.SetValue(1.0) ; #DEBUG_LINE_NO:33
    Else
      Recruitment_CanRecruit.SetValue(0.0) ; #DEBUG_LINE_NO:35
    EndIf
  EndIf
EndFunction

Function Fragment_TerminalMenu_02(ObjectReference akTerminalRef)
  ObjectReference myWorkshop = akTerminalRef.GetWorkshop() ; #DEBUG_LINE_NO:42
  If myWorkshop as Bool ; #DEBUG_LINE_NO:43
    HiredRef = Game.GetPlayer().PlaceActorAtMe(Employee02, 1, None, False, False, False, None, True) as ObjectReference ; #DEBUG_LINE_NO:44
    Game.GetPlayer().RemoveItem(Credits as Form, iCost * 2, False, None) ; #DEBUG_LINE_NO:45
    akTerminalRef.SetValue(ActiveEmployees, akTerminalRef.GetValue(ActiveEmployees) + 1.0) ; #DEBUG_LINE_NO:46
    Recruitment_CurrentRecruits.SetValue(akTerminalRef.GetValue(ActiveEmployees)) ; #DEBUG_LINE_NO:47
    EmployeeGlobal02.SetValue(EmployeeGlobal02.GetValue() - 1.0) ; #DEBUG_LINE_NO:48
    myWorkshop.AssignCrew(HiredRef as Actor) ; #DEBUG_LINE_NO:49
    If Recruitment_CurrentRecruits.GetValue() < Recruitment_MaxRecruits.GetValue() ; #DEBUG_LINE_NO:50
      Recruitment_CanRecruit.SetValue(1.0) ; #DEBUG_LINE_NO:51
    Else
      Recruitment_CanRecruit.SetValue(0.0) ; #DEBUG_LINE_NO:53
    EndIf
  EndIf
EndFunction

Function Fragment_TerminalMenu_03(ObjectReference akTerminalRef)
  ObjectReference myWorkshop = akTerminalRef.GetWorkshop() ; #DEBUG_LINE_NO:59
  If myWorkshop as Bool ; #DEBUG_LINE_NO:60
    HiredRef = Game.GetPlayer().PlaceActorAtMe(Employee03, 1, None, False, False, False, None, True) as ObjectReference ; #DEBUG_LINE_NO:61
    Game.GetPlayer().RemoveItem(Credits as Form, iCost * 3, False, None) ; #DEBUG_LINE_NO:62
    akTerminalRef.SetValue(ActiveEmployees, akTerminalRef.GetValue(ActiveEmployees) + 1.0) ; #DEBUG_LINE_NO:63
    Recruitment_CurrentRecruits.SetValue(akTerminalRef.GetValue(ActiveEmployees)) ; #DEBUG_LINE_NO:64
    EmployeeGlobal03.SetValue(EmployeeGlobal03.GetValue() - 1.0) ; #DEBUG_LINE_NO:65
    myWorkshop.AssignCrew(HiredRef as Actor) ; #DEBUG_LINE_NO:66
    If Recruitment_CurrentRecruits.GetValue() < Recruitment_MaxRecruits.GetValue() ; #DEBUG_LINE_NO:67
      Recruitment_CanRecruit.SetValue(1.0) ; #DEBUG_LINE_NO:68
    Else
      Recruitment_CanRecruit.SetValue(0.0) ; #DEBUG_LINE_NO:70
    EndIf
  EndIf
EndFunction

Function Fragment_TerminalMenu_04(ObjectReference akTerminalRef)
  ObjectReference myWorkshop = akTerminalRef.GetWorkshop() ; #DEBUG_LINE_NO:77
  If myWorkshop as Bool ; #DEBUG_LINE_NO:78
    HiredRef = Game.GetPlayer().PlaceActorAtMe(Employee04, 1, None, False, False, False, None, True) as ObjectReference ; #DEBUG_LINE_NO:79
    Game.GetPlayer().RemoveItem(Credits as Form, iCost * 4, False, None) ; #DEBUG_LINE_NO:80
    akTerminalRef.SetValue(ActiveEmployees, akTerminalRef.GetValue(ActiveEmployees) + 1.0) ; #DEBUG_LINE_NO:81
    Recruitment_CurrentRecruits.SetValue(akTerminalRef.GetValue(ActiveEmployees)) ; #DEBUG_LINE_NO:82
    EmployeeGlobal04.SetValue(EmployeeGlobal04.GetValue() - 1.0) ; #DEBUG_LINE_NO:83
    myWorkshop.AssignCrew(HiredRef as Actor) ; #DEBUG_LINE_NO:84
    If Recruitment_CurrentRecruits.GetValue() < Recruitment_MaxRecruits.GetValue() ; #DEBUG_LINE_NO:85
      Recruitment_CanRecruit.SetValue(1.0) ; #DEBUG_LINE_NO:86
    Else
      Recruitment_CanRecruit.SetValue(0.0) ; #DEBUG_LINE_NO:88
    EndIf
  EndIf
EndFunction
