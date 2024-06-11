ScriptName MissionQuestScript Extends Quest conditional

;-- Variables ---------------------------------------
String ScriptNameString = "MissionQuestScript"

;-- Guards ------------------------------------------
;*** WARNING: Guard declaration syntax is EXPERIMENTAL, subject to change
Guard MissionStateChangeGuard

;-- Properties --------------------------------------
Group MissionBoardAliases
  LocationAlias Property TargetSystemLocation Auto Const
  LocationAlias Property TargetPlanetLocation Auto Const
  LocationAlias Property TargetLocation Auto Const
  ReferenceAlias Property PrimaryRef Auto Const mandatory
  ReferenceAlias Property PlayerShip Auto Const mandatory
EndGroup

missionparentscript Property MissionParent Auto Const mandatory
{ mission parent quest }
Int Property AcceptStage = 10 Auto Const
{ The stage to set when mission is accepted }
Int Property ReadyStage = 5 Auto Const
{ the stage to set when the mission is ready to display on the mission board UI }
Int Property CompleteStage = 100 Auto Const
{ The stage to set when mission is completed }
Int Property FailStage = 200 Auto Const
{ The stage to set when mission has failed (e.g. time expired) }
Bool Property ShutdownOnFailure = True Auto Const
{ should the mission shutdown if it fails? (usually it won't - each mission type handles this differently) }
Bool Property ShutdownOnCompletion = True Auto Const
{ should the mission shutdown on completion? (usually it will) }
Int Property MissionType = 0 Auto Const
{ 0 = Bounty
 1 = Cargo
 2 = Passenger
 3 = Survey Planet (Constellation)
 4 = Survey Trait (Constellation)
 5 = Supply
 6 = Smuggle
 7 = Piracy
 8 = Steal
 9 = Bounty in Space
 10 = Freestar Bounty (Smuggler)
 11 = Freestar Bounty in Space (Pirate)
 12 = Freestar Bounty (Outlaw)
 13 = Freestar Rescue
 14 = Ryujin Hack 
 15 = Ryujin Plant Evidence
 16 = Ryujin Sabotage
 17 = Survey Planet for Life (LIST)
 18 = Hunt creatures }
GlobalVariable Property RewardAmountGlobal Auto Const mandatory
{ The base amount of Credits we're going to reward the player with }
GlobalVariable Property RewardAmountGlobalActual Auto Const mandatory
{ The actual amount of Credits we're going to reward the player with - possibly adjusted by specific mission factors }
GlobalVariable Property MissionIntValue01 Auto Const
{ OPTIONAL - for mission types with integer values
	NOTE: need to make custom Globals for each quest }
GlobalVariable Property MissionIntValue02 Auto Const
{ OPTIONAL - for mission types with integer values
	NOTE: need to make custom Globals for each quest }
GlobalVariable Property MissionTimeHours Auto Const
{ base mission quest timer 
	0 = unlimited time }
GlobalVariable Property MissionTimeHoursActual Auto Const
{ modified base mission quest timer - time for this mission based on mission data }
GlobalVariable Property MissionTimeRemainingDays Auto Const
{ only used if MissionTimeHoursActual is filled in - how long does player have in full days }
GlobalVariable Property MissionTimeRemainingHours Auto Const
{ only used if MissionTimeHoursActual is filled in - the "remainder" of MissionTimeHoursActual after MissionTimeRemainingDays is taken out }
LocationAlias Property PlayerStarSystemLocation Auto Const mandatory
{ The Star System the player is currently in when he sees the bounty }
ActorValue Property MissionBoardAvailableAV Auto Const
{ optional - if supplied, will be incremented +1 when a quest is available at a location; -1 when quest shuts down or is accepted }
Location Property MissionSourceLocation Auto hidden
{ location supplied by the script event, if any }
Bool Property PlayerAcceptedQuest Auto conditional
Bool Property PlayerCompletedQuest Auto conditional
Bool Property PlayerFailedQuest Auto conditional

;-- Functions ---------------------------------------

Function HandlePlayerHomeShipChange()
  ; Empty function
EndFunction

Function HandlePlayerLocationChange(Location akOldLoc, Location akNewLoc)
  ; Empty function
EndFunction

Function HandlePlayerShipDocking(spaceshipreference akParent)
  ; Empty function
EndFunction

Function HandlePlayerShipLanding()
  ; Empty function
EndFunction

Function HandlePlayerShipTakeOff()
  ; Empty function
EndFunction

Function HandlePlayerShipUndocking()
  ; Empty function
EndFunction

Function TestGetQuestTimeRemaining()
  ; Empty function
EndFunction

Event OnQuestStarted()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestStarted", 1)

    var[] valuesToShow = new var[28]
    valuesToShow[0] = ("Self = " + Self as String) as Var
    valuesToShow[1] = ("Parent = " + Parent as String) as Var
    valuesToShow[2] = ("LocationAlias TargetSystemLocation = " + TargetSystemLocation as String) as Var
    valuesToShow[3] = ("LocationAlias TargetPlanetLocation = " + TargetPlanetLocation as String) as Var
    valuesToShow[4] = ("LocationAlias TargetLocation = " + TargetLocation as String) as Var
    valuesToShow[5] = ("ReferenceAlias PrimaryRef = " + PrimaryRef as String) as Var
    valuesToShow[6] = ("ReferenceAlias PlayerShip = " + PlayerShip as String) as Var
    valuesToShow[7] = ("missionparentscript MissionParent = " + MissionParent as String) as Var
    valuesToShow[8] = ("Int AcceptStage = " + AcceptStage as String) as Var
    valuesToShow[9] = ("Int ReadyStage = " + ReadyStage as String) as Var
    valuesToShow[10] = ("Int CompleteStage = " + CompleteStage as String) as Var
    valuesToShow[11] = ("Int FailStage = " + FailStage as String) as Var
    valuesToShow[12] = ("Bool ShutdownOnFailure = " + ShutdownOnFailure as String) as Var
    valuesToShow[13] = ("Bool ShutdownOnCompletion = " + ShutdownOnCompletion as String) as Var
    valuesToShow[14] = ("GlobalVariable RewardAmountGlobal = " + RewardAmountGlobal as String) as Var
    valuesToShow[15] = ("GlobalVariable RewardAmountGlobalActual = " + RewardAmountGlobalActual as String) as Var
    valuesToShow[16] = ("GlobalVariable MissionIntValue01 = " + MissionIntValue01 as String) as Var
    valuesToShow[17] = ("GlobalVariable MissionIntValue02 = " + MissionIntValue02 as String) as Var
    valuesToShow[18] = ("GlobalVariable MissionTimeHours = " + MissionTimeHours as String) as Var
    valuesToShow[19] = ("GlobalVariable MissionTimeHoursActual = " + MissionTimeHoursActual as String) as Var
    valuesToShow[20] = ("GlobalVariable MissionTimeRemainingDays = " + MissionTimeRemainingDays as String) as Var
    valuesToShow[21] = ("GlobalVariable MissionTimeRemainingHours = " + MissionTimeRemainingHours as String) as Var
    valuesToShow[22] = ("LocationAlias PlayerStarSystemLocation = " + PlayerStarSystemLocation as String) as Var
    valuesToShow[23] = ("ActorValue MissionBoardAvailableAV = " + MissionBoardAvailableAV as String) as Var
    valuesToShow[24] = ("Location MissionSourceLocation = " + MissionSourceLocation as String) as Var
    valuesToShow[25] = ("Bool PlayerAcceptedQuest = " + PlayerAcceptedQuest as String) as Var
    valuesToShow[26] = ("Bool PlayerCompletedQuest = " + PlayerCompletedQuest as String) as Var
    valuesToShow[27] = ("Bool PlayerFailedQuest = " + PlayerFailedQuest as String) as Var
    Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnQuestInit", valuesToShow, 1)

    Actor PlayerREF = Game.GetPlayer() ; #DEBUG_LINE_NO:102
    Self.RegisterForRemoteEvent(PlayerREF as ScriptObject, "OnLocationChange") ; #DEBUG_LINE_NO:105
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipLanding") ; #DEBUG_LINE_NO:107
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipTakeOff") ; #DEBUG_LINE_NO:108
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipDock") ; #DEBUG_LINE_NO:111
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipUndock") ; #DEBUG_LINE_NO:112
    Self.RegisterForRemoteEvent(PlayerREF as ScriptObject, "OnHomeShipSet") ; #DEBUG_LINE_NO:115

    RewardAmountGlobalActual.SetValue(Self.GetActualReward() as Float) ; #DEBUG_LINE_NO:118
    Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Update Current Instance Global with = " + RewardAmountGlobalActual as String, 1)
    Self.UpdateCurrentInstanceGlobal(RewardAmountGlobalActual) ; #DEBUG_LINE_NO:119
    
    Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "RewardAmountGlobalActual.GetValue()", RewardAmountGlobalActual.GetValue() as String, 1)
    If RewardAmountGlobalActual.GetValue() == 0.0 ; #DEBUG_LINE_NO:120
    EndIf

    Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Execute SetActualMissionTime", 1)
    Self.SetActualMissionTime() ; #DEBUG_LINE_NO:125
    Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Execute SetMissionTimeVariables", 1)
    Self.SetMissionTimeVariables() ; #DEBUG_LINE_NO:126
    Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Set the stage at = " + ReadyStage as String, 1)
    Self.SetStage(ReadyStage) ; #DEBUG_LINE_NO:130

    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestStarted", 1)
EndEvent

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, Int aiValue1, Int aiValue2)
  MissionSourceLocation = akLocation ; #DEBUG_LINE_NO:134
  If MissionSourceLocation as Bool && MissionBoardAvailableAV as Bool ; #DEBUG_LINE_NO:135
    MissionSourceLocation.ModValue(MissionBoardAvailableAV, 1.0) ; #DEBUG_LINE_NO:136
  EndIf
EndEvent

Event OnQuestRejected()
  Self.HandleOnQuestRejected() ; #DEBUG_LINE_NO:142
EndEvent

Function HandleOnQuestRejected()
  Self.MissionFailed() ; #DEBUG_LINE_NO:147
EndFunction

Event OnMissionAccepted()
  Self.HandleOnMissionAccepted() ; #DEBUG_LINE_NO:152
EndEvent

Function HandleOnMissionAccepted()
  If MissionParent.MissionBoardAcceptMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) == 0 ; #DEBUG_LINE_NO:157
    Self.MissionAccepted(True) ; #DEBUG_LINE_NO:158
  Else
    Self.MissionAccepted(False) ; #DEBUG_LINE_NO:160
  EndIf
EndFunction

Function MissionAccepted(Bool bAccepted)
  If bAccepted ; #DEBUG_LINE_NO:166
    PlayerAcceptedQuest = True ; #DEBUG_LINE_NO:168
    If MissionBoardAvailableAV as Bool && MissionSourceLocation as Bool ; #DEBUG_LINE_NO:171
      MissionSourceLocation.ModValue(MissionBoardAvailableAV, -1.0) ; #DEBUG_LINE_NO:172
    EndIf
    Self.SetStage(AcceptStage) ; #DEBUG_LINE_NO:176
    MissionParent.SendMissionAcceptedEvent(Self) ; #DEBUG_LINE_NO:179
    wwiseevent.PlayMenuSound("UITerminalMissionBoardMissionAcceptYes") ; #DEBUG_LINE_NO:182
  Else
    wwiseevent.PlayMenuSound("UITerminalMissionBoardMissionAcceptNo") ; #DEBUG_LINE_NO:185
  EndIf
EndFunction

Function MissionComplete()
  Guard MissionStateChangeGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:193
    If PlayerAcceptedQuest && PlayerFailedQuest == False && PlayerCompletedQuest == False ; #DEBUG_LINE_NO:194
      Actor PlayerREF = Game.GetPlayer() ; #DEBUG_LINE_NO:195
      PlayerCompletedQuest = True ; #DEBUG_LINE_NO:197
      MissionParent.HandleMissionCompleted(Self) ; #DEBUG_LINE_NO:198
      If Utility.IsGameMenuPaused() == False ; #DEBUG_LINE_NO:199
        Utility.Wait(1.0) ; #DEBUG_LINE_NO:200
      EndIf
      Self.CompleteAllObjectives() ; #DEBUG_LINE_NO:202
      Self.StopQuestTimer() ; #DEBUG_LINE_NO:203
      Self.SetStage(CompleteStage) ; #DEBUG_LINE_NO:205
    EndIf
    If ShutdownOnCompletion ; #DEBUG_LINE_NO:208
      Self.MissionShutdown() ; #DEBUG_LINE_NO:209
    EndIf
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Function MissionFailed()
  Guard MissionStateChangeGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:216
    If PlayerAcceptedQuest && PlayerCompletedQuest == False ; #DEBUG_LINE_NO:217
      PlayerFailedQuest = True ; #DEBUG_LINE_NO:218
      MissionParent.HandleMissionFailed(Self) ; #DEBUG_LINE_NO:219
      Self.FailAllObjectives() ; #DEBUG_LINE_NO:220
      Self.SetStage(FailStage) ; #DEBUG_LINE_NO:221
      Self.StopQuestTimer() ; #DEBUG_LINE_NO:222
      If ShutdownOnFailure ; #DEBUG_LINE_NO:224
        Self.MissionShutdown() ; #DEBUG_LINE_NO:225
      EndIf
    EndIf
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Int Function GetActualReward()
  ObjectReference targetRef = PrimaryRef.GetRef() ; #DEBUG_LINE_NO:232
  Float reward = RewardAmountGlobal.GetValue() ; #DEBUG_LINE_NO:233
  Float mult = 1.0 ; #DEBUG_LINE_NO:234
  If targetRef ; #DEBUG_LINE_NO:235
    mult += targetRef.GetValue(MissionParent.MissionRewardMultiplier) ; #DEBUG_LINE_NO:236
    If mult <= 0.0 ; #DEBUG_LINE_NO:237
      mult = 1.0 ; #DEBUG_LINE_NO:238
    EndIf
  EndIf
  reward *= mult ; #DEBUG_LINE_NO:241
  Return reward as Int ; #DEBUG_LINE_NO:243
EndFunction

Function SetActualMissionTime()
  If MissionTimeHours as Bool && MissionTimeHoursActual as Bool ; #DEBUG_LINE_NO:248
    MissionTimeHoursActual.SetValue(MissionTimeHours.GetValue()) ; #DEBUG_LINE_NO:249
  EndIf
EndFunction

Function SetMissionTimeVariables()
  If ((MissionTimeHoursActual as Bool && MissionTimeHoursActual.GetValue() > 0.0) && MissionTimeRemainingDays as Bool) && MissionTimeRemainingHours as Bool ; #DEBUG_LINE_NO:255
    Float missionHours = MissionTimeHoursActual.GetValue() ; #DEBUG_LINE_NO:257
    Int missionDays = Math.Floor(missionHours / 24.0) ; #DEBUG_LINE_NO:259
    Float missionHoursRemainder = missionHours - (missionDays as Float * 24.0) ; #DEBUG_LINE_NO:260
    MissionTimeRemainingDays.SetValue(missionDays as Float) ; #DEBUG_LINE_NO:261
    MissionTimeRemainingHours.SetValue(missionHoursRemainder) ; #DEBUG_LINE_NO:262
    Self.UpdateCurrentInstanceGlobal(MissionTimeRemainingDays) ; #DEBUG_LINE_NO:263
    Self.UpdateCurrentInstanceGlobal(MissionTimeRemainingHours) ; #DEBUG_LINE_NO:264
  EndIf
EndFunction

Function MissionShutdown()
  If PlayerAcceptedQuest == False ; #DEBUG_LINE_NO:271
    If MissionBoardAvailableAV as Bool && MissionSourceLocation as Bool ; #DEBUG_LINE_NO:273
      MissionSourceLocation.ModValue(MissionBoardAvailableAV, -1.0) ; #DEBUG_LINE_NO:274
    EndIf
  EndIf
  Self.Stop() ; #DEBUG_LINE_NO:277
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
  Self.HandlePlayerLocationChange(akOldLoc, akNewLoc) ; #DEBUG_LINE_NO:281
EndEvent

Event Actor.OnHomeShipSet(Actor akSender, spaceshipreference akShip, spaceshipreference akPrevious)
  Self.HandlePlayerHomeShipChange() ; #DEBUG_LINE_NO:285
EndEvent

Event ReferenceAlias.OnShipLanding(ReferenceAlias akSender, Bool abComplete)
  If akSender == PlayerShip && abComplete == True ; #DEBUG_LINE_NO:290
    Self.HandlePlayerShipLanding() ; #DEBUG_LINE_NO:291
  EndIf
EndEvent

Event ReferenceAlias.OnShipTakeOff(ReferenceAlias akSender, Bool abComplete)
  If akSender == PlayerShip && abComplete == False ; #DEBUG_LINE_NO:297
    Self.HandlePlayerShipTakeOff() ; #DEBUG_LINE_NO:298
  EndIf
EndEvent

Event ReferenceAlias.OnShipDock(ReferenceAlias akSender, Bool abComplete, spaceshipreference akDocking, spaceshipreference akParent)
  If akSender == PlayerShip && abComplete == True ; #DEBUG_LINE_NO:304
    Self.HandlePlayerShipDocking(akParent) ; #DEBUG_LINE_NO:305
  EndIf
EndEvent

Event ReferenceAlias.OnShipUndock(ReferenceAlias akSender, Bool abComplete, spaceshipreference akUndocking, spaceshipreference akParent)
  If akSender == PlayerShip && abComplete == True ; #DEBUG_LINE_NO:311
    Self.HandlePlayerShipUndocking() ; #DEBUG_LINE_NO:312
  EndIf
EndEvent
