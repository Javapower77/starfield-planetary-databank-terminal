ScriptName pdt_StartupQuestScript Extends Quest

;-- Variables ---------------------------------------
String ScriptNameString = "pdt_StartupQuestScript"

;-- Properties ---------------------------------------
ReferenceAlias Property HomeShip Auto Const mandatory
ReferenceAlias Property PlayerShip Auto Const mandatory

;-- Events ------------------------------------------
Event OnQuestInit()
    ScriptNameString = Util.TruncateString(ScriptNameString, 40)
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit()", 1, 0)

    spaceshipreference myShip = HomeShip.GetShipRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "spaceshipreference myShip", myShip as String, 1, 1)

    spaceshipreference myShip2 = PlayerShip.GetShipRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "spaceshipreference myShip2", myShip2 as String, 1, 1)

    ObjectReference oHomeShip = HomeShip.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oHomeShip", oHomeShip as String, 1, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oHomeShip:GetBaseObject", oHomeShip.GetBaseObject() as String, 1, 1)

    ObjectReference oPlayerShip = PlayerShip.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oPlayerShip", oPlayerShip as String, 1, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oPlayerShip:GetBaseObject", oPlayerShip.GetBaseObject() as String, 1, 1)

   

    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit()", 1, 0)
EndEvent

ObjectReference Function GetShipReference()
    return PlayerShip.GetRef()
EndFunction

spaceshipreference Function GetSpaceShipReference()
    return PlayerShip.GetShipRef()
EndFunction