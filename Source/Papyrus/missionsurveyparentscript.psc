ScriptName MissionSurveyParentScript Extends MissionParentScript

;-- Variables ---------------------------------------
String ScriptNameString = "MissionSurveyParentScript"

;-- Events --------------------------------------
Event OnQuestInit()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit", 1)
    
    Keyword Keyword_MissionBoardTypeSurvey = Game.GetForm(0x001E266E) as Keyword
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit", "Keyword Keyword_MissionBoardTypeSurvey", Keyword_MissionBoardTypeSurvey, 1)

    ;Game.ShowMissionBoardMenu(Keyword_MissionBoardTypeSurvey, 6)

    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit", 1)
EndEvent

Event OnQuestStarted()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestStarted", 1)

    Keyword Keyword_MissionBoardTypeSurvey = Game.GetForm(0x001E266E) as Keyword
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit", "Keyword Keyword_MissionBoardTypeSurvey", Keyword_MissionBoardTypeSurvey, 1)

    ;Game.ShowMissionBoardMenu(Keyword_MissionBoardTypeSurvey, 6)

    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestStarted", 1)
EndEvent

;-- Functions --------------------------------------
Function StartSurveyLifeQuest(Location akLoc)
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "StartSurveyLifeQuest(Location akLoc)", 1)
    Javas_Debug.WriteLog(ScriptNameString, "StartSurveyLifeQuest", "Location akLoc", akLoc, 1)
    Javas_Debug.WriteLog(ScriptNameString, "StartSurveyLifeQuest", "Parent", Parent, 1)
    
    Keyword Keyword_MissionBoardTypeSurvey = Game.GetForm(0x001E266E) as Keyword
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit", "Keyword Keyword_MissionBoardTypeSurvey", Keyword_MissionBoardTypeSurvey, 1)
    Game.ShowMissionBoardMenu(Keyword_MissionBoardTypeSurvey, 6)

    Int I = 0
    While I < Parent.MissionTypes.Length
        Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit", "missionparentscript:missiontype[] MissionTypes[" + I as String + "]", Parent.MissionTypes[I].missionTypeKeyword, 1)
        I += 1
    EndWhile

    I = 0
    While I < surveyQuests.length
        Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit", "missionsurveyquestscript[] surveyQuests[" + I as String + "]", surveyQuests[I], 1)
        I += 0
    EndWhile
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "StartSurveyLifeQuest(Location akLoc)", 1)
EndFunction