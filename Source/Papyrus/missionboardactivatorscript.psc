ScriptName MissionBoardActivatorScript Extends ObjectReference

;-- Variables ---------------------------------------
String ScriptNameString = "MissionBoardActivatorScript"

;-- Properties --------------------------------------
Keyword Property MissionBoardFilterKeyword Auto Const
{ optional - keyword to pass in to filter mission quests }
conditionform Property AccessConditions Auto Const
{ optional - if included, this condition must be true to open the menu }
Message Property AccessFailureMessage Auto Const
{ optional - if included, message will be displayed if the AccessConditions are false }
missionparentscript Property MB_Parent Auto Const mandatory
{ mission parent quest }
Location Property OverrideLocation Auto Const
{ optional - if provided, the missions will populate using this location rather than the mission board's location }
Int Property FactionID = -1 Auto Const
{ optional - pass in one of the following factionIDs if you want a "themed" mission board UI:
    United Colonies = 1
    Ryujin Industries = 2
    House Varuun = 3
    Freestar = 4
    Crimson Fleet = 5
    Constellation = 6 }
Bool Property NeverResetOnLoad = False Auto Const
{ used by "local" activators since we don't want to reset missions on load when the player may not be in the location }
Bool Property AlwaysResetOnLoad = False Auto Const
{ if true, will reset with override onLoad. Use carefully, normally we don't want this behavior }
missionsurveyquestscript Property SQ_SurveyQuest Auto Const

;-- Functions ---------------------------------------

Event OnLoad()
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnLoad()", 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnLoad", "Bool NeverResetOnLoad", NeverResetOnLoad, 1)
  
  var[] valuesToShow = new var[9]
  valuesToShow[0] = ("Keyword MissionBoardFilterKeyword = " + MissionBoardFilterKeyword as String) as Var
  valuesToShow[1] = ("conditionform AccessConditions = " + AccessConditions as String) as Var
  valuesToShow[2] = ("Message AccessFailureMessage = " + AccessFailureMessage as String) as Var
  valuesToShow[3] = ("missionparentscript MB_Parent = " + MB_Parent as String) as Var
  valuesToShow[4] = ("Location OverrideLocation = " +  OverrideLocation as String) as Var
  valuesToShow[5] = ("Int FactionID = " + FactionID as String) as Var
  valuesToShow[6] = ("Bool NeverResetOnLoad = " + NeverResetOnLoad as String) as Var
  valuesToShow[7] = ("Bool AlwaysResetOnLoad = " + AlwaysResetOnLoad as String) as Var
  Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnLoad", valuesToShow, 1)

  If NeverResetOnLoad == False ; #DEBUG_LINE_NO:61
    Self.ResetMissions() ; #DEBUG_LINE_NO:62
  EndIf
  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnLoad()", 1)
EndEvent

Function ResetMissions()
  Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "ResetMissions()", 1)
  Location myResetLocation = None ; #DEBUG_LINE_NO:69
  If OverrideLocation ; #DEBUG_LINE_NO:71
    myResetLocation = OverrideLocation ; #DEBUG_LINE_NO:72
  Else
    If Self.GetWorkshop() ; #DEBUG_LINE_NO:74
      myResetLocation = Self.GetCurrentLocation() ; #DEBUG_LINE_NO:76
    Else
      Location[] settlementLocations = Self.GetCurrentLocation().GetParentLocations(MB_Parent.LocTypeSettlement) ; #DEBUG_LINE_NO:78
      If settlementLocations.Length > 0 ; #DEBUG_LINE_NO:79
        myResetLocation = settlementLocations[0] ; #DEBUG_LINE_NO:80
      EndIf
    EndIf
    If myResetLocation == None ; #DEBUG_LINE_NO:83
      myResetLocation = Self.GetCurrentLocation() ; #DEBUG_LINE_NO:84
    EndIf
  EndIf
  If myResetLocation ; #DEBUG_LINE_NO:88
    MB_Parent.ResetMissions(False, False, myResetLocation, AlwaysResetOnLoad) ; #DEBUG_LINE_NO:89
  EndIf
  Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "ResetMissions()", 1)
EndFunction

Event OnWorkshopObjectPlaced(ObjectReference akReference)
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnWorkshopObjectPlaced(ObjectReference akReference)", 1)
  Self.ResetMissions() ; #DEBUG_LINE_NO:95
  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnWorkshopObjectPlaced(ObjectReference akReference)", 1)
EndEvent

;-- State -------------------------------------------
State busy

  Event OnActivate(ObjectReference akActionRef)
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnActivate(ObjectReference akActionRef) [State::Busy]", 1)
    ; Empty function
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnActivate(ObjectReference akActionRef) [State::Busy]", 1)
  EndEvent
EndState

;-- State -------------------------------------------
Auto State default

  Event OnActivate(ObjectReference akActionRef)
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnActivate(ObjectReference akActionRef) [State::Default]", 1)
    If akActionRef == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:36
      Self.GotoState("busy") ; #DEBUG_LINE_NO:37
      If AccessConditions == None || AccessConditions.IsTrue(Game.GetPlayer() as ObjectReference, Self as ObjectReference) ; #DEBUG_LINE_NO:39
        MB_Parent.UpdateMissions() ; #DEBUG_LINE_NO:42
        Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Show Mission Board Menu", "", 1)
        Game.ShowMissionBoardMenu(MissionBoardFilterKeyword, FactionID) ; #DEBUG_LINE_NO:44
      ElseIf AccessFailureMessage
        AccessFailureMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:46
      EndIf
      Self.GotoState("default") ; #DEBUG_LINE_NO:48
    EndIf
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnActivate(ObjectReference akActionRef) [State::Default]", 1)
  EndEvent
EndState
