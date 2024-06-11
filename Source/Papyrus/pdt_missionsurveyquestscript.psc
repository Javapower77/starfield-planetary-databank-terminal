ScriptName pdt_MissionSurveyQuestScript Extends MissionQuestScript conditional

;-- Variables ---------------------------------------
Float fCheckSurveyPollingTimeSeconds = 15.0 Const
Float fScanObjectTimeSeconds = 1.0 Const
Int iCheckSurveyProgressTimerID = 1 Const
Float lastSurveyPercentage = 0.0
planet targetPlanet
String ScriptNameString = "pdt_MissionSurveyQuestScript"

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
Event OnQuestInit()
          ;/ DEBUG /;   Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit", 1)  
  LogScriptInputValues("OnQuestInit()")
          ;/ DEBUG /;   Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit", 1)
EndEvent

Event OnQuestStarted()
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestStarted", 1)
    LogScriptInputValues("OnQuestStarted()")
    targetPlanet = PlanetTarget.GetRef().GetCurrentPlanet()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnQuestStarted", "planet targetPlanet", targetPlanet, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Set MissionIntValue01 to 1", 1)
    MissionIntValue01.SetValue(0.0)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Call -> Self.UpdateCurrentInstanceGlobal(MissionIntValue01)", 1)
    Self.UpdateCurrentInstanceGlobal(MissionIntValue01)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "Call -> Parent.OnQuestStarted()", 1)
    Parent.OnQuestStarted()
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestStarted", 1)
  EndEvent

Event Actor.OnPlayerScannedObject(Actor akSource, ObjectReference akScannedRef)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "Actor.OnPlayerScannedObject(Actor akSource, ObjectReference akScannedRef)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerScannedObject", "Actor akSource", akSource, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerScannedObject", "ObjectReference akScannedRef", akScannedRef + " | Base: " + akScannedRef.GetBaseObject(), 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "Actor.OnPlayerScannedObject", "Start the Timer -> Self.StartTimer(" + fScanObjectTimeSeconds as String + ", " + iCheckSurveyProgressTimerID as String + ")", 1)
  Self.StartTimer(fScanObjectTimeSeconds, iCheckSurveyProgressTimerID)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "Actor.OnPlayerScannedObject(Actor akSource, ObjectReference akScannedRef)", 1)
EndEvent

Event OnTimer(Int aiTimerID)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnTimer(Int aiTimerID)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnTimer", "Int aiTimerID", aiTimerID, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnTimer", "Int iCheckSurveyProgressTimerID", iCheckSurveyProgressTimerID, 1)
  If aiTimerID == iCheckSurveyProgressTimerID 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnQuestStarted", "aiTimerID is equal to iCheckSurveyProgressTimerID so then Call Function Self.CheckSurveyProgress(True)", 1)
    Self.CheckSurveyProgress(True)
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnTimer(Int aiTimerID)", 1)
EndEvent

Function CheckSurveyProgress(Bool restartTimer)
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "CheckSurveyProgress(Bool restartTimer)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "CheckSurveyProgress", "Bool restartTimer", restartTimer, 1)
  planet currentPlayerPlanet = Game.GetPlayer().GetCurrentPlanet() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "CheckSurveyProgress", "planet currentPlayerPlanet", currentPlayerPlanet, 1)
  spaceshipreference playershipRef = PlayerShip.GetShipRef()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "CheckSurveyProgress", "spaceshipreference playershipRef", playershipRef, 1)
  planet currentShipPlanet = playershipRef.GetCurrentPlanet() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "CheckSurveyProgress", "planet currentShipPlanet", currentShipPlanet, 1)
  If currentShipPlanet == targetPlanet || currentPlayerPlanet == targetPlanet 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "CheckSurveyProgress", "This two conditions are true: currentShipPlanet=targetPlanet and currentPlayerPlanet=targetPlanet, so then call the function Self.UpdateSurveyPercent() ", 1)
    Self.UpdateSurveyPercent() ; 
    If restartTimer && PlayerCompletedQuest == False 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "CheckSurveyProgress", "This two conditions are true: restartTimer is True and PlayerCompletedQuest is False, so then start the timer elf.StartTimer(" + fCheckSurveyPollingTimeSeconds as String + ", " + iCheckSurveyProgressTimerID as String + ")", 1)
      Self.StartTimer(fCheckSurveyPollingTimeSeconds, iCheckSurveyProgressTimerID) 
    EndIf
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "CheckSurveyProgress(Bool restartTimer)", 1)
EndFunction

Event Actor.OnPlayerPlanetSurveyComplete(Actor akSource, planet akPlanet)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "Actor.OnPlayerPlanetSurveyComplete(Actor akSource, planet akPlanet)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerPlanetSurveyComplete", "Actor akSource", akSource, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerPlanetSurveyComplete", "planet akPlanet", akPlanet, 1)
  spaceshipreference playershipRef = PlayerShip.GetShipRef() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerPlanetSurveyComplete", "spaceshipreference playershipRef", playershipRef, 1)
  planet currentShipPlanet = playershipRef.GetCurrentPlanet() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "Actor.OnPlayerPlanetSurveyComplete", "planet currentShipPlanet", currentShipPlanet, 1)
  If currentShipPlanet == targetPlanet 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "Actor.OnPlayerPlanetSurveyComplete", "This condition is true currentShipPlanet=targetPlanet, so then Finish the mission -> Self.MissionComplete()", 1)
    Self.MissionComplete()
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "Actor.OnPlayerPlanetSurveyComplete(Actor akSource, planet akPlanet)", 1)
EndEvent

Int Function GetActualReward()
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "GetActualReward()", 1)
  Float reward = RewardAmountGlobal.GetValue()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Float reward", reward, 1)
  Int planetTraitValue = SQ_Parent.GetPlanetTraitValue(targetPlanet)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Int planetTraitValue", planetTraitValue, 1)
  Float planetAbundanceValue = SQ_Parent.GetPlanetAbundanceValue(targetPlanet)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Float planetAbundanceValue", planetAbundanceValue, 1)
  Int planetRewardValue = planetTraitValue + planetAbundanceValue as Int
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Int planetRewardValue", planetRewardValue, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "GetActualReward", "Get the Survey Slate Date from SQ_Parent quest", 1)
  sq_parentscript:planetsurveyslatedata theData = SQ_Parent.GetSurveySlateData(planetRewardValue, 1.0) 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "sq_parentscript:planetsurveyslatedata theData", theData, 1)
  Int XPReward = MissionParent.MissionBoardSurveyXPRewardBase.GetValueInt()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Int XPReward", XPReward, 1)
  If theData 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "GetActualReward", "If theData has value then increment the XP Reward", 1)
    XPReward += theData.RewardXP.GetValueInt() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Int XPReward", XPReward, 1)
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "GetActualReward", "Set the RewardXPAmountGlobalActual to the value of XPReward -> RewardXPAmountGlobalActual.SetValueInt(" + XPReward as String + ")", 1)
  RewardXPAmountGlobalActual.SetValueInt(XPReward)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "GetActualReward", "Calcute the new reward as -> reward[=" + reward as String + "] + (planetTraitValue[=" + planetTraitValue as String + "] * RewardPlanetTraitMult[=" + RewardPlanetTraitMult as String + "]) + planetAbundanceValue[=" + planetAbundanceValue as String + "] * RewardPlanetAbundanceMult[=" + RewardPlanetAbundanceMult as String + "]", 1)
  reward = reward + (planetTraitValue as Float * RewardPlanetTraitMult) + planetAbundanceValue * RewardPlanetAbundanceMult
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "GetActualReward", "Float reward", reward, 1)
  Return reward as Int
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "GetActualReward()", 1)
EndFunction

Function MissionAccepted(Bool bAccepted)
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "MissionAccepted(Bool bAccepted)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "MissionAccepted", "Bool bAccepted", bAccepted, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "Call the Parent->MissionAccepted function and send the value of bAccpeted", 1)
  Parent.MissionAccepted(bAccepted)
  If bAccepted
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "bAccepted is True", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "Show Tutorial Message on SQ_Parent quest -> SQ_Parent.ShowTutorialMessage(" + MissionAcceptTutorialID as String + ")", 1)    
    SQ_Parent.ShowTutorialMessage(MissionAcceptTutorialID)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "Self Register for Remote Event -> Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, 'OnPlayerPlanetSurveyComplete')", 1)
    Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerPlanetSurveyComplete")
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "Self Register for Remote Event -> Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, 'OnShipScan')", 1)
    Self.RegisterForRemoteEvent(PlayerShip as ScriptObject, "OnShipScan")
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "MissionAccepted", "Call the self function to Update the Survey Percent", 1)
    Self.UpdateSurveyPercent()
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "MissionAccepted(Bool bAccepted)", 1)
EndFunction

Function HandlePlayerShipLanding()
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "HandlePlayerShipLanding()", 1)
  If PlayerAcceptedQuest
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipLanding", "PlayerAcceptedQuest is True", 1)
    planet currentShipPlanet = PlayerShip.GetShipRef().GetCurrentPlanet()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "HandlePlayerShipLanding", "planet currentShipPlanet", currentShipPlanet, 1)
    If currentShipPlanet == targetPlanet
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipLanding", "The values of currentShipPlanet and targetPlanet are True", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipLanding", "Show Tutorial Message on SQ_Parent quest -> SQ_Parent.ShowTutorialMessage(" + MissionAcceptTutorialID as String + ")", 1)    
      SQ_Parent.ShowTutorialMessage(MissionLandTutorialID)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipLanding", "Self Register for Remote Event -> Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, 'OnPlayerScannedObject')", 1)
      Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerScannedObject")
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipLanding", "Start the timer Self.StartTimer(" + fCheckSurveyPollingTimeSeconds as String + ", " + iCheckSurveyProgressTimerID as String + ")", 1)
      Self.StartTimer(fCheckSurveyPollingTimeSeconds, iCheckSurveyProgressTimerID)
    EndIf
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "HandlePlayerShipLanding()", 1)
EndFunction

Function HandlePlayerShipTakeOff()
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "HandlePlayerShipTakeOff()", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipTakeOff", "Self Unregister for Remote Event -> Self.UnregisterForRemoteEvent(Game.GetPlayer() as ScriptObject, 'OnPlayerScannedObject')", 1)
  Self.UnregisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerScannedObject")
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "HandlePlayerShipTakeOff", "Cancel the Timer -> Self.CancelTimer(" + iCheckSurveyProgressTimerID as String + ")", 1)
  Self.CancelTimer(iCheckSurveyProgressTimerID)
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "HandlePlayerShipTakeOff()", 1)
EndFunction

Event ReferenceAlias.OnShipScan(ReferenceAlias akSource, Location aPlanet, ObjectReference[] aMarkersArray)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "ReferenceAlias.OnShipScan(ReferenceAlias akSource, Location aPlanet, ObjectReference[] aMarkersArray)", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "ReferenceAlias.OnShipScan", "ReferenceAlias akSource", akSource, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "ReferenceAlias.OnShipScan", "Location aPlanet", aPlanet, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogObjectReferences(ScriptNameString, "ReferenceAlias.OnShipScan", aMarkersArray, true, 1)
  planet currentShipPlanet = PlayerShip.GetShipRef().GetCurrentPlanet()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "ReferenceAlias.OnShipScan", "planet currentShipPlanet", currentShipPlanet, 1)
  If currentShipPlanet == targetPlanet 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "ReferenceAlias.OnShipScan", "The condition currentShipPlanet=targetPlanet is True, so then call the self funcion Check Survey Progress with false -> Self.CheckSurveyProgress(False)", 1)
    Self.CheckSurveyProgress(False) 
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "ReferenceAlias.OnShipScan(ReferenceAlias akSource, Location aPlanet, ObjectReference[] aMarkersArray)", 1)
EndEvent

Function UpdateSurveyPercent()
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "UpdateSurveyPercent()", 1)
  Float currentSurveyPercentage = targetPlanet.GetSurveyPercent()
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "UpdateSurveyPercent", "Float currentSurveyPercentage", currentSurveyPercentage, 1)
  If currentSurveyPercentage > lastSurveyPercentage 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "UpdateSurveyPercent", "The condition currentSurveyPercentage > lastSurveyPercentage is True [" + currentSurveyPercentage as String + " > " + lastSurveyPercentage as String + "]", 1)
    Float modValue = (currentSurveyPercentage - lastSurveyPercentage) * 100.0 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "UpdateSurveyPercent", "Calculate the modValue as (currentSurveyPercentage[=" + currentSurveyPercentage as String + " - lastSurveyPercentage[=" + lastSurveyPercentage as String + "] * 100 )", 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "UpdateSurveyPercent", "Float modValue", modValue, 1)
    lastSurveyPercentage = currentSurveyPercentage ; #DEBUG_LINE_NO:155
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "UpdateSurveyPercent", "Float lastSurveyPercentage", lastSurveyPercentage, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "UpdateSurveyPercent", "Set the Mod Objective Global -> Self.ModObjectiveGlobal(modValue[=" + modValue as String +"], MissionIntValue01[=" + MissionIntValue01 as String + "], SurveyObjective[=" + SurveyObjective as String + "], 100.0, True, True, True, False)", 1)
    Self.ModObjectiveGlobal(modValue, MissionIntValue01, SurveyObjective, 100.0, True, True, True, False) ; #DEBUG_LINE_NO:157
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "UpdateSurveyPercent()", 1)
EndFunction

;-- Helper Functions -------------------------------------------
Function LogScriptInputValues(String sNameOfFunctionOrEvent)
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit", 1)
  var[] valuesToShow = new var[8]
  valuesToShow[0] = ("sq_parentscript SQ_Parent = " + SQ_Parent as String) as Var
  valuesToShow[1] = ("ReferenceAlias PlanetTarget = " + PlanetTarget as String) as Var
  valuesToShow[2] = ("Float Property RewardPlanetAbundanceMult = " + RewardPlanetAbundanceMult as String) as Var
  valuesToShow[3] = ("Float Property RewardPlanetTraitMult = " + RewardPlanetTraitMult as String) as Var
  valuesToShow[4] = ("Int Property SurveyObjective = " + SurveyObjective as String) as Var
  valuesToShow[5] = ("Int Property MissionAcceptTutorialID = " + MissionAcceptTutorialID as String) as Var
  valuesToShow[6] = ("Int Property MissionLandTutorialID = " + MissionLandTutorialID as String) as Var
  valuesToShow[7] = ("GlobalVariable RewardXPAmountGlobalActual = " + RewardXPAmountGlobalActual as String) as Var
  Javas_Debug.WriteLogAllVariables(ScriptNameString, sNameOfFunctionOrEvent, valuesToShow, 1)
EndFunction