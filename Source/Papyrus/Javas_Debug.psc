ScriptName Javas_Debug Extends ScriptObject

;-- Functions ---------------------------------------

Function WriteLog(String CallingScript, String functionOreventName, String Object, Var value, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
    If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
        Return  ; #DEBUG_LINE_NO:17
    EndIf
    String sUserLogFile = Common(CallingScript) 
    String sSpaceIdentation = FillIdentation(iNumberOfSpaceIdent)   
    Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::" + sSpaceIdentation + " {" + functionOreventName + "} " + Object + " ===> " + value as String, 0)
EndFunction

Function WriteLogEvent(String CallingScript, String direction, String eventName, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  WriteLogFunctionOrEvent(CallingScript, "EVENT", direction, eventName, iNumberOfSpaceIdent, debugModeEnabled)
EndFunction

Function WriteLogFunction(String CallingScript, String direction, String functionName, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  WriteLogFunctionOrEvent(CallingScript, "FUNCTION", direction, functionName, iNumberOfSpaceIdent, debugModeEnabled)
EndFunction

Function WriteLogFunctionOrEvent(String CallingScript, String sFunctionOrEvent, String direction, String functionName, Int iNumberOfSpaceIdent, Int debugModeEnabled) Global
  If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
    Return  ; #DEBUG_LINE_NO:17
  EndIf
  String sUserLogFile = Common(CallingScript)     
  String sSpaceIdentation = FillIdentation(iNumberOfSpaceIdent)  
  If direction == "IN"
    Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::" + sSpaceIdentation, 0)
  EndIf
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::" + sSpaceIdentation + "+-" + sFunctionOrEvent + "::" + direction + ":: " + functionName, 0) ; #DEBUG_LINE_NO:29
EndFunction


Function WriteLogAllVariables(String CallingScript, String functionOreventName, var[] aValues, Int debugModeEnabled) Global
  If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
    Return  ; #DEBUG_LINE_NO:17
  EndIf
  String sUserLogFile = Common(CallingScript)  
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::[[--------------------------------------------------------------------------------]]", 0)
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::[[ Properties values for the current Script: " + CallingScript + ".psc", 0)
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::[[--------------------------------------------------------------------------------]]", 0)
  Int I = 0
  While I < aValues.length
    Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::\t" + aValues[I] as String, 0)
    I += 1
  EndWhile
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::[[--------------------------------------------------------------------------------]]", 0)
EndFunction

Function WriteLogText(String CallingScript, String functionOreventName, String sText, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  If debugModeEnabled == 0 
    Return  
  EndIf
  String sUserLogFile = Common(CallingScript) 
  String sSpaceIdentation = FillIdentation(iNumberOfSpaceIdent)         
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::" + sSpaceIdentation + " {" + functionOreventName + "} " + sText, 0)
EndFunction

Function WriteLogComment(String CallingScript, String functionOreventName, String sComment, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  If debugModeEnabled == 0 
    Return  
  EndIf
  String sUserLogFile = Common(CallingScript) 
  String sSpaceIdentation = FillIdentation(iNumberOfSpaceIdent)         
  Debug.TraceUser(sUserLogFile, "::" + CallingScript + "::DEBUG::" + sSpaceIdentation + " {" + functionOreventName + "} ######## " + sComment + " ########", 0) ; #DEBUG_LINE_NO:29
EndFunction

Function WriteLogLocationArray(String CallingScript, String functionOreventName, Location[] oRef, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  ;test
EndFunction
 
Function WriteLogObjectReferences(String CallingScript, String functionOreventName, ObjectReference[] oColl, bool bShowBaseObject, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
    Return  ; #DEBUG_LINE_NO:17
  EndIf
  
  String sEmpty = ""
  WriteLogComment(CallingScript, functionOreventName, "BELLOW IS ALL VALUES INSIDE {ObjectReference[]} OBJECT", 1, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "+  Number of objects inside the ObjectReference[] object", oColl.Length, 1, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "|=====================================================", sEmpty, 1, iNumberOfSpaceIdent) 
  Int I = 0
  String sShowInfo = ""
  While I < oColl.length
      If bShowBaseObject
        sShowInfo = "|  ooo> ObjectReference[" + I as String + "] Value / GetBaseObject Value"
        WriteLog(CallingScript, functionOreventName, sShowInfo, oColl[I] + " / " + oColl[I].GetBaseObject(), 1, iNumberOfSpaceIdent)
      Else
        sShowInfo = "|  ooo> ObjectReference[" + I as String + "] Value"
        WriteLog(CallingScript, functionOreventName, sShowInfo, oColl[I], 1, iNumberOfSpaceIdent)
      EndIf      
      I += 1
  EndWhile
  WriteLog(CallingScript, functionOreventName, "+=====================================================", sEmpty, 1, iNumberOfSpaceIdent) 
EndFunction

Function WriteLogFloraArray(String CallingScript, String functionOreventName, Flora[] oColl, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
    Return  ; #DEBUG_LINE_NO:17
  EndIf

  String sEmpty = ""
  WriteLogComment(CallingScript, functionOreventName, "BELLOW IS ALL VALUES INSIDE {Flora[]} OBJECT", 1, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "+  Number of objects inside the Flora[] object", oColl.Length, 1, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "|=====================================================", sEmpty, 1, iNumberOfSpaceIdent)   
  Int I = 0
  String sShowInfo = ""
  While I < oColl.length
    sShowInfo = "|  ooo> Flora[" + I as String + "] Value"
    WriteLog(CallingScript, functionOreventName, sShowInfo, oColl[I], 1, iNumberOfSpaceIdent)    
    I += 1
  EndWhile
  WriteLog(CallingScript, functionOreventName, "+=====================================================", sEmpty, 1, iNumberOfSpaceIdent)   
EndFunction



Function WriteLogFormList(String CallingScript, String functionOreventName, FormList oColl, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  ; Common and Repeatable in all the functions
  If debugModeEnabled == 0
    Return
  EndIf

  Form[] allKeywords = oColl.GetArray(true)
  String sEmpty = ""
  WriteLogComment(CallingScript, functionOreventName, "BELLOW IS ALL VALUES INSIDE [FormList] OBJECT", debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "+  Number of objects inside the FormList object", oColl.GetSize(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName, "| ====================================================", sEmpty, debugModeEnabled, iNumberOfSpaceIdent)   
  Int I = 0
  String sShowInfo = ""
  While I < allKeywords.length
    sShowInfo = "|  ooo> FormList[" + I as String + "] Value"
    WriteLog(CallingScript, functionOreventName, sShowInfo, allKeywords[I], debugModeEnabled, iNumberOfSpaceIdent)    
    I += 1
  EndWhile
  WriteLog(CallingScript, functionOreventName, "+ ====================================================", sEmpty, 1, iNumberOfSpaceIdent)   
EndFunction

Function WriteLogDebugObjectReference(String CallingScript, String functionOreventName, ObjectReference oRef, Int debugModeEnabled, Int iNumberOfSpaceIdent = 0) Global
  If debugModeEnabled == 0 ; #DEBUG_LINE_NO:16
    Return  ; #DEBUG_LINE_NO:17
  EndIf  
  ObjectReference oPlayerRef = Game.GetPlayer()
  WriteLogText(CallingScript, functionOreventName, "[[--------------------------------------------------------------------------------]]", debugModeEnabled, iNumberOfSpaceIdent)
  WriteLogText(CallingScript, functionOreventName, "[[ Showing values for the Object Reference                                        ]]" + oRef as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLogText(CallingScript, functionOreventName, "[[--------------------------------------------------------------------------------]]", debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetActorOwner()", oRef.GetActorOwner(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetActorRefOwner()", oRef.GetActorRefOwner(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetAllCrewMembers()", oRef.GetAllCrewMembers() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetAllRefsInTrigger()", oRef.GetAllRefsInTrigger() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetAngleX()", oRef.GetAngleX(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetAngleY()", oRef.GetAngleY(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetAngleZ() ", oRef.GetAngleZ() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetBaseObject()", oRef.GetBaseObject(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetBiomeActors(100.0)", oRef.GetBiomeActors(100.0) as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetBiomeFlora(100.0)", oRef.GetBiomeFlora(100.0) as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetContainer()", oRef.GetContainer(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetCurrentDestructionStage()", oRef.GetCurrentDestructionStage(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetCurrentLocation()", oRef.GetCurrentLocation(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetCurrentPlanet() ", oRef.GetCurrentPlanet() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetCurrentScene()", oRef.GetCurrentScene(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetDebugTextColor()", oRef.GetDebugTextColor() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetDebugTextSize()", oRef.GetDebugTextSize(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetDebugTextString()", oRef.GetDebugTextString(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetDestructibleOutpostObjects()", oRef.GetDestructibleOutpostObjects() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetEditorLocation()", oRef.GetEditorLocation(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetFactionOwner()", oRef.GetFactionOwner(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetGravityScale()", oRef.GetGravityScale(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetHeight()", oRef.GetHeight(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetInventoryValue() ", oRef.GetInventoryValue() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetItemHealthPercent()", oRef.GetItemHealthPercent(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetKey()", oRef.GetKey(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetLength()", oRef.GetLength(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetLocRefTypes() ", oRef.GetLocRefTypes() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetLockLevel()", oRef.GetLockLevel(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetMass()", oRef.GetMass(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetOpenState()", oRef.GetOpenState(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetParentCell() ", oRef.GetParentCell() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetPercentageKnown()", oRef.GetPercentageKnown(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetPositionX()", oRef.GetPositionX(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetPositionY() ", oRef.GetPositionY() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetPositionZ() ", oRef.GetPositionZ() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetRadioFrequency()", oRef.GetRadioFrequency(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetRadioVolume()", oRef.GetRadioVolume(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetScale()", oRef.GetScale(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetSpacePosition() ", oRef.GetSpacePosition() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetSpaceTransform()", oRef.GetSpaceTransform() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetSpaceshipAutopilotAI() ", oRef.GetSpaceshipAutopilotAI() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetTeleportCell()", oRef.GetTeleportCell(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetTransitionCell() ", oRef.GetTransitionCell() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetTransmitterDistance()", oRef.GetTransmitterDistance(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetTriggerObjectCount()", oRef.GetTriggerObjectCount(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetValueResources() ", oRef.GetValueResources() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetVoiceType()", oRef.GetVoiceType(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWeight()", oRef.GetWeight(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWeightInContainer()", oRef.GetWeightInContainer(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWidth()", oRef.GetWidth(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWorkshop()", oRef.GetWorkshop(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWorkshopOwnedObjects(Actor Game.GetPlayer())", oRef.GetWorkshopOwnedObjects(Game.GetPlayer()) as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetWorldSpace()", oRef.GetWorldSpace(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  HasActorRefOwner()", oRef.HasActorRefOwner(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  HasCrew()", oRef.HasCrew(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  Is3DLoaded() ", oRef.Is3DLoaded() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsActivationBlocked()", oRef.IsActivationBlocked(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsConveyorBeltOn()", oRef.IsConveyorBeltOn(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsCreated()", oRef.IsCreated(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsDebugTextBillboard()", oRef.IsDebugTextBillboard(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsDeleted() ", oRef.IsDeleted() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsDestroyed()", oRef.IsDestroyed(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsDisabled()", oRef.IsDisabled(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsDoorInaccessible()", oRef.IsDoorInaccessible(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsFanMotorOn()", oRef.IsFanMotorOn(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsFurnitureInUse(true)", oRef.IsFurnitureInUse(true), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsIgnoringFriendlyHits()", oRef.IsIgnoringFriendlyHits(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsInDialogueWithPlayer()", oRef.IsInDialogueWithPlayer(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsInSpace()", oRef.IsInSpace(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsLockBroken() ", oRef.IsLockBroken() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsLocked()", oRef.IsLocked(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsMapMarkerVisible()", oRef.IsMapMarkerVisible(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsPowered()", oRef.IsPowered(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsQuestItem()", oRef.IsQuestItem(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsRadioOn() ", oRef.IsRadioOn() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsScanned()", oRef.IsScanned(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsTeleportAreaLoaded() ", oRef.IsTeleportAreaLoaded() , debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsInInterior()", oRef.IsInInterior(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetDayLength()", oRef.GetDayLength(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetSelfAsActor()", oRef.GetSelfAsActor(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  GetSingleRefArray()", oRef.GetSingleRefArray() as String, debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  HasOwner()", oRef.HasOwner(), debugModeEnabled, iNumberOfSpaceIdent)
  WriteLog(CallingScript, functionOreventName,"[[  IsEnabled()", oRef.IsEnabled(), debugModeEnabled, iNumberOfSpaceIdent)        
  WriteLogText(CallingScript, functionOreventName, "[[--------------------------------------------------------------------------------]]", debugModeEnabled, iNumberOfSpaceIdent)
EndFunction

; -- HELPERS
String Function Common(String CallingScript) Global
  String sUserLogFile = ""
  If Javas_Config.IsDebugLogAllInUniqueUserLogFile()
    sUserLogFile = Javas_Config.GetModName()
  Else
    sUserLogFile = CallingScript
  EndIf  
  If Debug.OpenUserLog(sUserLogFile)
    Debug.TraceUser(sUserLogFile, "\n\n[[--------------------------------------------------------------------------------]]\n" + CallingScript + " LOG\n[[--------------------------------------------------------------------------------]]\n\n", 0)
  EndIf   
  Return sUserLogFile
EndFunction

String Function FillIdentation(Int iNumberOfSpaceIdent) Global
  String sSpaceIdentation = ""
  Int I = 0
  While I < iNumberOfSpaceIdent
    sSpaceIdentation = sSpaceIdentation + "|"
    I += 1
  EndWhile 
  return sSpaceIdentation
EndFunction

