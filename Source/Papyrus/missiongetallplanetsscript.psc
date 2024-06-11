ScriptName MissionGetAllPlanetsScript Extends Quest

;-- Variables ---------------------------------------
String ScriptNameString = "MissionGetAllPlanetsScript"

;-- Properties --------------------------------------
sq_parentscript Property SQ_Parent Auto Const mandatory
LocationAlias[] Property AllPlanets Auto Const mandatory
{ array of all planet location aliases }

;-- Events ---------------------------------------

Event OnQuestInit()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit", 1)

    var[] valuesToShow = new var[2]
    valuesToShow[0] = ("sq_parentscript SQ_Parent = " + SQ_Parent as String) as Var
    valuesToShow[1] = ("LocationAlias[] AllPlanets = " + AllPlanets as String) as Var
   
    Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnQuestInit", valuesToShow, 1)

    Int I = 0
    While I < AllPlanets.length
        Location thePlanet = AllPlanets[I].GetLocation()
        Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "LocationAlias[" + I as String + "] AllPlanets", AllPlanets[I] as String, 1)
        Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "Location thePlanet", thePlanet, 1)
        I += 1
    EndWhile
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit", 1)
EndEvent

;-- Functions ---------------------------------------

Int Function DebugGetPlanetCount()
  Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "DebugGetPlanetCount", 1)
  Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "AllPlanets.Length", AllPlanets.Length, 1)
  Int planetCount = 0 ; #DEBUG_LINE_NO:10
  Int I = 0 ; #DEBUG_LINE_NO:12
  While I < AllPlanets.Length ; #DEBUG_LINE_NO:13
    Location thePlanet = AllPlanets[I].GetLocation() ; #DEBUG_LINE_NO:14
    Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "Location thePlanet", thePlanet, 1)
    If thePlanet ; #DEBUG_LINE_NO:15
      planetCount += 1 ; #DEBUG_LINE_NO:16
    EndIf
    I += 1 ; #DEBUG_LINE_NO:18
  EndWhile
  Javas_Debug.WriteLog(ScriptNameString, "DebugGetPlanetCount", "Int planetCount", planetCount, 1)
  Debug.trace((Self as String + " DebugGetPlanetCount: ") + planetCount as String, 0) ; #DEBUG_LINE_NO:20
  Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "DebugGetPlanetCount", 1)
  Return planetCount ; #DEBUG_LINE_NO:21
EndFunction

Int Function GetSystemTraitValue()
  Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "GetSystemTraitValue", 1)
  Int totalTraitValue = 0 ; #DEBUG_LINE_NO:26
  Int I = 0 ; #DEBUG_LINE_NO:28
  Javas_Debug.WriteLog(ScriptNameString, "GetSystemTraitValue", "AllPlanets.Length", AllPlanets.Length, 1)
  While I < AllPlanets.Length ; #DEBUG_LINE_NO:29
    Location thePlanetLocation = AllPlanets[I].GetLocation() ; #DEBUG_LINE_NO:30
    Javas_Debug.WriteLog(ScriptNameString, "GetSystemTraitValue", "Location thePlanetLocation", thePlanetLocation, 1)
    If thePlanetLocation ; #DEBUG_LINE_NO:31
      planet thePlanet = thePlanetLocation.GetCurrentPlanet() ; #DEBUG_LINE_NO:32
      Javas_Debug.WriteLog(ScriptNameString, "GetSystemTraitValue", "planet thePlanet", thePlanet, 1)
      Int planetTraitValue = SQ_Parent.GetPlanetTraitValue(thePlanet) ; #DEBUG_LINE_NO:33
      Javas_Debug.WriteLog(ScriptNameString, "GetSystemTraitValue", "Int planetTraitValue", planetTraitValue, 1)
      totalTraitValue += planetTraitValue ; #DEBUG_LINE_NO:34
    EndIf
    I += 1 ; #DEBUG_LINE_NO:37
  EndWhile
  Javas_Debug.WriteLog(ScriptNameString, "GetSystemTraitValue", "Int totalTraitValue", totalTraitValue, 1)
  Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "GetSystemTraitValue", 1)
  Return totalTraitValue ; #DEBUG_LINE_NO:40
EndFunction
