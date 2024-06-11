ScriptName SQ_CurrentPlanetScript Extends Quest
 

;-- Properties --------------------------------------
ReferenceAlias Property PlanetTarget Auto Const mandatory

;-- Variables ---------------------------------------
String ScriptNameString = "SQ_CurrentPlanetScript"

;-- Events ------------------------------------------
Event OnQuestInit()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit()", 1)

    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "ReferenceAlias Property PlanetTarget", PlanetTarget, 1)
    
    ObjectReference oPlanetRef = PlanetTarget.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "ObjectReference oPlanetRef", oPlanetRef, 1)

    sQ_ParentScript SQ_ParentFromGame = Game.GetForm(461100) as sQ_ParentScript
    var[] valuesToShow = new var[7]
    valuesToShow[0] = ("ReferenceAlias Property PlanetReference ===> " + SQ_ParentFromGame.PlanetReference as String) as Var
    valuesToShow[1] = ("Keyword Property LocTypeMajorOrbital ===> " + SQ_ParentFromGame.LocTypeMajorOrbital as String) as Var
    valuesToShow[2] = ("Keyword Property LocTypeStarSystem ===> " + SQ_ParentFromGame.LocTypeStarSystem as String) as Var
    valuesToShow[3] = ("LocationAlias Property PlanetReferencePlanetLocation ===> " + SQ_ParentFromGame.PlanetReferencePlanetLocation as String) as Var
    valuesToShow[4] = ("LocationAlias Property PlanetReferenceSystemLocation ===> " + SQ_ParentFromGame.PlanetReferenceSystemLocation as String) as Var
    valuesToShow[5] = ("ReferenceAlias Property PlayerShip ===> " + SQ_ParentFromGame.PlayerShip as String) as Var
    valuesToShow[6] = ("LocationAlias[] Property SystemPlanets ===> " + SQ_ParentFromGame.SystemPlanets as String) as Var
    Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnTerminalMenuEnter", valuesToShow, 1)

    ObjectReference oPlanetReference = SQ_ParentFromGame.PlanetReference.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oPlanetReference", oPlanetReference + "|" + oPlanetReference.GetBaseObject(), 1)
    
    Location lPlanetReferencePlanetLocation = SQ_ParentFromGame.PlanetReferencePlanetLocation.GetLocation()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Location lPlanetReferencePlanetLocation", lPlanetReferencePlanetLocation, 1)

    Location lPlanetReferenceSystemLocation = SQ_ParentFromGame.PlanetReferenceSystemLocation.GetLocation()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Location lPlanetReferencePlanetLocation", lPlanetReferencePlanetLocation, 1)

    ObjectReference lPlayerShip = SQ_ParentFromGame.PlayerShip.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference lPlayerShip", lPlayerShip + "|" + lPlayerShip.GetBaseObject(), 1)

    Location theLocation = SQ_ParentFromGame.SystemPlanets[0].GetLocation()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Location theLocation", theLocation, 1)

    Flora[] allPlanetFlora = oPlanetReference.GetBiomeFlora(0.0)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Flora[] allPlanetFlora = ", allPlanetFlora as String, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "allPlanetFlora.length = ", allPlanetFlora.length, 1)

    allPlanetFlora = oPlanetReference.GetBiomeFlora(100.0)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Flora[] allPlanetFlora = ", allPlanetFlora as String, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "allPlanetFlora.length = ", allPlanetFlora.length, 1)

    

    ;/
    ObjectReference oActorPlayer = Game.GetPlayer()
   
    Form fPlanet = Game.GetPlayer().GetCurrentPlanet() as Form
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "Form fPlanet", fPlanet, 1)
    Form fLocation = Game.GetPlayer().GetCurrentLocation() as Form
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "Form fLocation", fLocation, 1)
    ;ObjectReference oPlanet = fPlanet as ObjectReference
    ;Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "ObjectReference oPlanet = ", oPlanet, 1)
    PlanetReferenceUsingForm.ForceRefTo(fPlanet as ObjectReference)
    
    Int iPlanetId = fPlanet.GetFormID()  ; Get the Decimal of the FormID for the current Planet
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "Int iPlanetId", iPlanetId, 1)

    var test = Game.GetForm(iPlanetId) as ObjectReference
    ;ObjectReference oTest = test.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "var test", test, 1)

    ObjectReference oPlanet = Game.GetForm(iPlanetId) as ObjectReference
    ;RefCollectionAlias refCollPlanet = Game.GetFormFromFile(2070, "Javas_PlanetTerminal.esm") as RefCollectionAlias
    Planet pPlanet = Game.GetForm(iPlanetId) as Planet
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "ObjectReference oPlanet", oPlanet, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "Planet pPlanet", pPlanet, 1)
    PlanetReferenceUsingForm.ForceRefTo(oPlanet)

    Javas_Debug.WriteLog(ScriptNameString, "OnQuestInit()", "ObjectReference oActorPlayer", oActorPlayer, 1)
    PlanetReference.ForceRefTo(oActorPlayer)
    /;
    Self.Stop()
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit()", 1)
EndEvent

Event OnQuestStarted()
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnQuestInit()", 1)
    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnQuestInit()", 1)
EndEvent

