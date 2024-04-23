ScriptName Javas_PlanetDBTerminalScript Extends TerminalMenu Hidden


;-- Variables ---------------------------------------



;-- Properties --------------------------------------
ActorValue Property PlayerUnityTimesEntered Auto Const
Actor Property PlayerRef Auto Const
SQ_MissionSurveyQuestScript Property myQuest Auto hidden
Keyword Property StoryManagerEventKeyword Auto Const mandatory

;-- Functions ---------------------------------------

;-- Events ------------------------------------------
Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->IN:EVENT: OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef) ", 0)
  
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->OUT:EVENT: OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef) ", 0)
EndEvent

Event OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->IN:EVENT: OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 0)

  ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->XX: " + XX as String, 0)
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Int auiMenuItemID:" + auiMenuItemID as String, 0)
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->TerminalMenu akTerminalBase: " + akTerminalBase as String, 0)
  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->ObjectReference akTerminalRef: " + akTerminalRef as String, 0)

  ; OPTION: PLANET INFORMATION
  If auiMenuItemID == 0
    Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Entered on Option 1 [Planet Information] from menu.", 0)

    Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Call Story Manager to Trigger the Planet Survey Quest", 0)
    SQ_MissionSurveyQuestScript[] myQuests = StoryManagerEventKeyword.SendStoryEventAndWait(None, legendaryBookRef, bookHuntMapRef as ObjectReference, LegendaryBookLocation, LegendaryBookProximity) as sQ_BookHuntQuestScript[] ; #DEBUG_LINE_NO:43
    Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->myQuests.Length: " + myQuests.Length as String, 0)
    
    If myQuests.Length > 0 ; #DEBUG_LINE_NO:44
      Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->myQuests[0]: " + myQuests[0] as String, 0)
      myQuest = myQuests[0] ; #DEBUG_LINE_NO:45
      Int failsafeCount = 0 ; #DEBUG_LINE_NO:46
      While myQuest.IsStarting() && failsafeCount < 100 ; #DEBUG_LINE_NO:47
        Utility.Wait(0.100000001) ; #DEBUG_LINE_NO:48
        failsafeCount += 1 ; #DEBUG_LINE_NO:49
      EndWhile
      Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Call Story Manager is running ...", 0)
    Else
      Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->No Quest had been found!", 0)
    EndIf
    
    ;MissionSurveyQuestScript MissionSurveyQuestFromSF = Game.GetFormFromFile(0x00182C46, "starfield.esm") as missionsurveyquestscript
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->MissionSurveyQuestScript MissionSurveyQuestFromSF: " + MissionSurveyQuestFromSF as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Quest MissionSurveyQuestFromSF: " + MissionSurveyQuestFromSF as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Quest MissionSurveyQuestFromSF.SQ_Parent: " + MissionSurveyQuestFromSF.SQ_Parent as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Quest MissionSurveyQuestFromSF.PlanetTarget: " + MissionSurveyQuestFromSF.PlanetTarget as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Quest MissionSurveyQuestFromSF.MissionIntValue01: " + MissionSurveyQuestFromSF.MissionIntValue01 as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Planet MissionSurveyQuestFromSF.PlanetTarget.GetRef().GetCurrentPlanet() : " + (MissionSurveyQuestFromSF.PlanetTarget).GetRef().GetCurrentPlanet() as String, 0)



    ;Self.RegisterForRemoteEvent(MissionSurveyQuestFromSF as ScriptObject, "OnInit")

    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Survey to 100%", 0)
    ;MissionSurveyQuestFromSF.Start()
    ;MissionSurveyQuestFromSF.SetStage(100)
    ;MissionSurveyQuestFromSF.ModObjectiveGlobal(100.0, MissionSurveyQuestFromSF.MissionIntValue01, 10, 100.0, True, True, True, False) 
  EndIf

  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->OUT:EVENT: OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 0)
EndEvent