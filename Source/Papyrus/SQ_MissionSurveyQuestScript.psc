ScriptName SQ_MissionSurveyQuestScript Extends MissionQuestScript conditional

;-- Variables ---------------------------------------
Float fCheckSurveyPollingTimeSeconds = 15.0 Const
Float fScanObjectTimeSeconds = 1.0 Const
Int iCheckSurveyProgressTimerID = 1 Const
Float lastSurveyPercentage = 0.0
planet targetPlanet
String ScriptNameString = "SQ_MissionSurveyQuestScript"

;-- Properties --------------------------------------
Group MissionTypeData
  sq_parentscript Property SQ_Parent Auto Const mandatory
  ReferenceAlias Property PlanetTarget Auto Const mandatory
  { target ref in planet orbit - used to get target Planet }
  Float Property RewardPlanetTraitMult = 1000.0 Auto Const
  { multiplier based on total trait value on planet for total reward }
  Float Property RewardPlanetAbundanceMult = 1000.0 Auto Const
  { multiplier based on total abundance value on planet for total reward }
  Int Property SurveyObjective = 10 Auto Const
  { objective for surveying }
  Int Property MissionAcceptTutorialID = 0 Auto Const
  { tutorial ID when accepting this mission - see SQ_Parent.TutorialMessages }
  Int Property MissionLandTutorialID = 1 Auto Const
  { tutorial ID when landing on the target planet - see SQ_Parent.TutorialMessages }
  GlobalVariable Property RewardXPAmountGlobalActual Auto Const mandatory
  { The actual amount of XP we're going to reward the player with - possibly adjusted by specific mission factors }
EndGroup


;-- Functions ---------------------------------------

Event OnQuestStarted()
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestStarted", 1)
  targetPlanet = PlanetTarget.GetRef().GetCurrentPlanet() ; #DEBUG_LINE_NO:37
  Javas_Debug.WriteLog(ScriptNameString, "OnQuestStarted", "planet targetPlanet", targetPlanet, 1)
  MissionIntValue01.SetValue(0.0) ; #DEBUG_LINE_NO:39
  Self.UpdateCurrentInstanceGlobal(MissionIntValue01) ; #DEBUG_LINE_NO:40
  Parent.OnQuestStarted() ; #DEBUG_LINE_NO:41
  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestStarted", 1)
EndEvent

Event Actor.OnPlayerScannedObject(Actor akSource, ObjectReference akScannedRef)
  Self.StartTimer(fScanObjectTimeSeconds, iCheckSurveyProgressTimerID) ; #DEBUG_LINE_NO:46
EndEvent

Event OnTimer(Int aiTimerID)
  If aiTimerID == iCheckSurveyProgressTimerID ; #DEBUG_LINE_NO:50
    Self.CheckSurveyProgress(True) ; #DEBUG_LINE_NO:51
  EndIf
EndEvent

Function CheckSurveyProgress(Bool restartTimer)
  planet currentPlayerPlanet = Game.GetPlayer().GetCurrentPlanet() ; #DEBUG_LINE_NO:56
  spaceshipreference playershipRef = PlayerShip.GetShipRef() ; #DEBUG_LINE_NO:58
  planet currentShipPlanet = playershipRef.GetCurrentPlanet() ; #DEBUG_LINE_NO:59
  If currentShipPlanet == targetPlanet || currentPlayerPlanet == targetPlanet ; #DEBUG_LINE_NO:63
    Self.UpdateSurveyPercent() ; #DEBUG_LINE_NO:64
    If restartTimer && PlayerCompletedQuest == False ; #DEBUG_LINE_NO:65
      Self.StartTimer(fCheckSurveyPollingTimeSeconds, iCheckSurveyProgressTimerID) ; #DEBUG_LINE_NO:66
    EndIf
  EndIf
EndFunction

Event Actor.OnPlayerPlanetSurveyComplete(Actor akSource, planet akPlanet)
  spaceshipreference playershipRef = PlayerShip.GetShipRef() ; #DEBUG_LINE_NO:73
  planet currentShipPlanet = playershipRef.GetCurrentPlanet() ; #DEBUG_LINE_NO:74
  If currentShipPlanet == targetPlanet ; #DEBUG_LINE_NO:78
    Self.MissionComplete() ; #DEBUG_LINE_NO:79
  EndIf
EndEvent

Int Function GetActualReward()
  Float reward = RewardAmountGlobal.GetValue() ; #DEBUG_LINE_NO:85
  Int planetTraitValue = SQ_Parent.GetPlanetTraitValue(targetPlanet) ; #DEBUG_LINE_NO:87
  Float planetAbundanceValue = SQ_Parent.GetPlanetAbundanceValue(targetPlanet) ; #DEBUG_LINE_NO:88
  Int planetRewardValue = planetTraitValue + planetAbundanceValue as Int ; #DEBUG_LINE_NO:90
  sq_parentscript:planetsurveyslatedata theData = SQ_Parent.GetSurveySlateData(planetRewardValue, 1.0) ; #DEBUG_LINE_NO:92
  Int XPReward = MissionParent.MissionBoardSurveyXPRewardBase.GetValueInt() ; #DEBUG_LINE_NO:93
  If theData ; #DEBUG_LINE_NO:94
    XPReward += theData.RewardXP.GetValueInt() ; #DEBUG_LINE_NO:95
  EndIf
  RewardXPAmountGlobalActual.SetValueInt(XPReward) ; #DEBUG_LINE_NO:97
  reward = reward + (planetTraitValue as Float * RewardPlanetTraitMult) + planetAbundanceValue * RewardPlanetAbundanceMult ; #DEBUG_LINE_NO:99
  Return reward as Int ; #DEBUG_LINE_NO:101
EndFunction

Function MissionAccepted(Bool bAccepted)
  Parent.MissionAccepted(bAccepted) ; #DEBUG_LINE_NO:106
  If bAccepted ; #DEBUG_LINE_NO:107
    SQ_Parent.ShowTutorialMessage(MissionAcceptTutorialID) ; #DEBUG_LINE_NO:108
    Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerPlanetSurveyComplete") ; #DEBUG_LINE_NO:110
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipScan") ; #DEBUG_LINE_NO:111
    Self.UpdateSurveyPercent() ; #DEBUG_LINE_NO:113
  EndIf
EndFunction

Function HandlePlayerShipLanding()
  If PlayerAcceptedQuest ; #DEBUG_LINE_NO:119
    planet currentShipPlanet = PlayerShip.GetShipRef().GetCurrentPlanet() ; #DEBUG_LINE_NO:121
    If currentShipPlanet == targetPlanet ; #DEBUG_LINE_NO:124
      SQ_Parent.ShowTutorialMessage(MissionLandTutorialID) ; #DEBUG_LINE_NO:125
      Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerScannedObject") ; #DEBUG_LINE_NO:126
      Self.StartTimer(fCheckSurveyPollingTimeSeconds, iCheckSurveyProgressTimerID) ; #DEBUG_LINE_NO:128
    EndIf
  EndIf
EndFunction

Function HandlePlayerShipTakeOff()
  Self.UnregisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerScannedObject") ; #DEBUG_LINE_NO:136
  Self.CancelTimer(iCheckSurveyProgressTimerID) ; #DEBUG_LINE_NO:137
EndFunction

Event ReferenceAlias.OnShipScan(ReferenceAlias akSource, Location aPlanet, ObjectReference[] aMarkersArray)
  planet currentShipPlanet = PlayerShip.GetShipRef().GetCurrentPlanet() ; #DEBUG_LINE_NO:141
  If currentShipPlanet == targetPlanet ; #DEBUG_LINE_NO:145
    Self.CheckSurveyProgress(False) ; #DEBUG_LINE_NO:146
  EndIf
EndEvent

Function UpdateSurveyPercent()
  Float currentSurveyPercentage = targetPlanet.GetSurveyPercent() ; #DEBUG_LINE_NO:151
  If currentSurveyPercentage > lastSurveyPercentage ; #DEBUG_LINE_NO:153
    Float modValue = (currentSurveyPercentage - lastSurveyPercentage) * 100.0 ; #DEBUG_LINE_NO:154
    lastSurveyPercentage = currentSurveyPercentage ; #DEBUG_LINE_NO:155
    Self.ModObjectiveGlobal(modValue, MissionIntValue01, SurveyObjective, 100.0, True, True, True, False) ; #DEBUG_LINE_NO:157
  EndIf
EndFunction
