ScriptName pdt_missionboardactivatorscript Extends ObjectReference

;-- Variables ---------------------------------------
String ScriptNameString = "pdt_missionboardactivatorscript"

;-- Properties --------------------------------------
Keyword Property MissionBoardFilterKeyword Auto Const
{ optional - keyword to pass in to filter mission quests }
GlobalVariable Property pdt_mt_planet_init Auto Mandatory
Message Property pdt_signupmessage Auto Const mandatory
Keyword Property pdt_mt_planet_keyword Auto Const
GlobalVariable Property pdt_mt_planet_countcompleted Auto Const Mandatory
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
Bool Property NeverResetOnLoad = True Auto Const
{ used by "local" activators since we don't want to reset missions on load when the player may not be in the location }
Bool Property AlwaysResetOnLoad = True Auto Const
{ if true, will reset with override onLoad. Use carefully, normally we don't want this behavior }
FormList Property pdt_MBQuests Auto Const Mandatory
;-- Functions ---------------------------------------
Event OnInit()
  ScriptNameString = Util.TruncateString(ScriptNameString, 40)
            ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnInit", 1)
  LogScriptInputValues("OnInit")
            ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnInit", 1)
EndEvent

Event OnLoad()
  ScriptNameString = Util.TruncateString(ScriptNameString, 40)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnLoad", 1)
  LogScriptInputValues("OnLoad")
  If NeverResetOnLoad == False
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnLoad", "NeverResetOnLoad is False, so then Call Self.ResetMissions", 1)
    Self.ResetMissions()
  EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnLoad", 1)
EndEvent

Function ResetMissions()
  ScriptNameString = Util.TruncateString(ScriptNameString, 40)
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "ResetMissions", 1, 1)
  Location myResetLocation = Self.GetCurrentLocation() 
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "ResetMissions", "Location myResetLocation", myResetLocation, 1, 2)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "ResetMissions", "AlwaysResetOnLoad", AlwaysResetOnLoad, 1, 2)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "ResetMissions", "Call MB_Parent.ResetMissions", 1, 2)
  MB_Parent.ResetMissions(False, False, myResetLocation, True)
          ;/ DEBUG /;     Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "ResetMissions", 1, 1)
EndFunction

Event OnWorkshopObjectPlaced(ObjectReference akReference)
  ScriptNameString = Util.TruncateString(ScriptNameString, 40)
        ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnWorkshopObjectPlaced(ObjectReference akReference)", 1)
        ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnWorkshopObjectPlaced", "ObjectReference akReference", akReference + " | Base: " + akReference.GetBaseObject(), 1)
        ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnLoad", "Call Self.ResetMissions", 1)
  Self.ResetMissions()
        ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnWorkshopObjectPlaced(ObjectReference akReference)", 1)
EndEvent

;-- State -------------------------------------------
State busy
  Event OnActivate(ObjectReference akActionRef)
    ScriptNameString = Util.TruncateString(ScriptNameString, 40)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN:STATE BUSY", "OnActivate(ObjectReference akActionRef)", 1)
    ; Empty function
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT:STATE BUSY", "OnActivate(ObjectReference akActionRef)", 1)
  EndEvent
EndState

;-- State -------------------------------------------
Auto State default
  Event OnActivate(ObjectReference akActionRef)
    ScriptNameString = Util.TruncateString(ScriptNameString, 40)
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "IN:STATE AUTO DEFAULT", "OnActivate(ObjectReference akActionRef)", 1, 0)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "ObjectReference akActionRef", akActionRef + " | Base: " + akActionRef.GetBaseObject(), 1, 1)
    
    Int[] palabra = Utility.SplitStringChars("AaBbCcDd1234 !#$%")
    int xx=0
    while xx<palabra.length
      Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "ascii:", palabra[xx], 1, 1)
      xx+=1
    EndWhile
    
    
          ; Check is the new keyword has been added to MB_Parent.
    If pdt_mt_planet_init.GetValueInt() == 0      
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "The value of pdt_mt_planet_init is 1, so then create the new mission type", 1, 1)
      MissionParentScript:MissionType planettype = new MissionParentScript:MissionType
      planettype.missionTypeKeyword = pdt_mt_planet_keyword
      planettype.MissionCompletedCount = pdt_mt_planet_countcompleted
      planettype.RandomStoryEventOrder = False
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Add the new planetary mission to the Mission Types in MB_Parent -> MB_Parent.MissionTypes.Add(planettype)", 1, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "MissionParentScript:MissionType planettype", planettype, 1, 1)
      MB_Parent.MissionTypes.Add(planettype)

      Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Force to add the mission to the missionQuest of the MB_Parent Quest", 1, 1)
      Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "pdt_MBQuests.GetSize()", pdt_MBQuests.GetSize() as String, 1, 1)    
      pdt_MissionSurveyQuestScript mission = pdt_MBQuests.GetAt(0) as pdt_MissionSurveyQuestScript
      Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "mission", mission as String, 1, 1)
      MB_Parent.missionQuests.Add(mission)

          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Show Sign Up Message", 1, 1)
      pdt_signupmessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
          ;/ DEBUG /;     Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "MB_Parent.MissionTypes.Add", MB_Parent.MissionTypes.Length, 1, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Set to 1 the value of pdt_mt_planet_init", 1, 1)
      pdt_mt_planet_init.SetValueInt(1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Call Self.ResetMissions", 1, 1)
      Self.ResetMissions()
    EndIf

    If akActionRef == Game.GetPlayer() as ObjectReference
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "The condition akActionRef=Game.GetPlayer() as ObjectReference is True, so then Go to State Busy", 1, 1)
      Self.GotoState("busy") 
      If AccessConditions == None || AccessConditions.IsTrue(Game.GetPlayer() as ObjectReference, Self as ObjectReference)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "The condition AccessConditions is None and AccessConditions.IsTrue(Game.GetPlayer() as ObjectReference, Self as ObjectReference) is True, so then Update the Missions", 1, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Call MB_Parent.UpdateMissions", 1, 1)
        MB_Parent.UpdateMissions() 
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Open the Mission Board Menu -> Game.ShowMissionBoardMenu", 1, 1)
        Game.ShowMissionBoardMenu(MissionBoardFilterKeyword, FactionID) 
      ElseIf AccessFailureMessage
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "The condition AccessFailureMessege is True, then show a failure message", 1, 1)
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Show Message -> AccessFailureMessage.Show", 1, 1)
        AccessFailureMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) 
      EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogComment(ScriptNameString, "OnActivate", "Go to State Default -> Self.GotoState('default')", 1, 1)
      Self.GotoState("default") 
    EndIf
          ;/ DEBUG /;     Javas_Debug.WriteLogEvent(ScriptNameString, "OUT:STATE AUTO DEFAULT", "OnActivate(ObjectReference akActionRef)", 1, 0)
  EndEvent
EndState

;-- Helper Functions -------------------------------------------
Function LogScriptInputValues(String sNameOfFunctionOrEvent)
  ScriptNameString = Util.TruncateString(ScriptNameString, 40)
  var[] valuesToShow = new var[12]
  valuesToShow[0] = ("Keyword Property MissionBoardFilterKeyword ===> " + MissionBoardFilterKeyword as String) as Var
  valuesToShow[1] = ("GlobalVariable Property pdt_mt_planet_init ===> " + pdt_mt_planet_init as String) as Var
  valuesToShow[2] = ("Message Property pdt_signupmessage ===> " + pdt_signupmessage as String) as Var
  valuesToShow[3] = ("Keyword Property pdt_mt_planet_keyword ===> " + pdt_mt_planet_keyword as String) as Var
  valuesToShow[4] = ("GlobalVariable Property pdt_mt_planet_countcompleted ===> " + pdt_mt_planet_countcompleted as String) as Var
  valuesToShow[5] = ("conditionform Property AccessConditions ===> " + AccessConditions as String) as Var
  valuesToShow[6] = ("Message Property AccessFailureMessage ===> " + AccessFailureMessage as String) as Var
  valuesToShow[7] = ("missionparentscript Property MB_Parent ===> " + MB_Parent as String) as Var
  valuesToShow[8] = ("Location Property OverrideLocation ===> " + OverrideLocation as String) as Var
  valuesToShow[9] = ("Int Property FactionID ===> " + FactionID as String) as Var
  valuesToShow[10] = ("Bool Property NeverResetOnLoad ===> " + NeverResetOnLoad as String) as Var
  valuesToShow[11] = ("Bool Property AlwaysResetOnLoad ===> " + AlwaysResetOnLoad as String) as Var  
  Javas_Debug.WriteLogAllVariables(ScriptNameString, sNameOfFunctionOrEvent, valuesToShow, 1)
EndFunction