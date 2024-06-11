ScriptName Javas_PlanetDBTerminalScript Extends TerminalMenu Hidden


;-- Variables ---------------------------------------
String ScriptNameString = "Javas_PlanetDBTerminalScript"
;Javas_Testing oRef

;-- Properties --------------------------------------
Keyword Property TerminalKeyword Auto Const
ActorValue Property PlayerUnityTimesEntered Auto Const
;Actor Property PlayerRef Auto Const
;ReferenceAlias Property PlayerRef Auto Const
Quest Property myQuest Auto hidden
Keyword Property StoryManagerEventKeyword Auto Const mandatory
Keyword Property StoryManagerEventKeywordForSurveryLife Auto Const mandatory
Keyword Property StoryManagerEventKeywordCustomSurveyLife Auto Const mandatory
Quest Property TriggerQuest Auto Const
sq_parentscript Property SQ_Parent Auto Const mandatory
Int Property KeywordType_PlanetTrait = 44 Auto Const hidden
{ used to get PlanetTrait keyword types using GetKeywordTypeList native function }
Int Property KeywordType_PlanetFloraAbundance = 47 Auto Const hidden
{ used to get Flora Abundance keyword types using GetKeywordTypeList native function }
Int Property KeywordType_PlanetFaunaAbundance = 48 Auto Const hidden
{ used to get Flora Abundance keyword types using GetKeywordTypeList native function }
sq_parentscript:planettraitdata[] Property PlanetTraits Auto Const
sq_parentscript:planetabundancedata[] Property PlanetAbundanceKeywords Auto Const
MissionSurveyQuestScript Property SQ_MissionSurvey Auto Const mandatory
GlobalVariable Property MissionIntValue01 Auto Const
MissionParentScript Property MB_Parent_PDT Auto Const
MissionSurveyParentScript Property SQ_MissionSurveyParentScript Auto Const
Keyword Property FloraKeyword Auto Const mandatory
Keyword Property PlanetKeyword Auto Const mandatory

;-- Functions ---------------------------------------

;-- Events ------------------------------------------
Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef) 
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 1)
 
  ObjectReference oActorPlayer = Game.GetPlayer()

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ActorValue PlayerUnityTimesEntered", oActorPlayer.GetValue(PlayerUnityTimesEntered), 1)

  Form fPlanet = Game.GetPlayer().GetCurrentPlanet() as Form
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Form fPlanet", fPlanet, 1)

  Int iPlanetId = fPlanet.GetFormID()  ; Get the Decimal of the FormID for the current Planet
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Int iPlanetId", iPlanetId, 1)
  var test = Game.GetForm(iPlanetId)
  ;ObjectReference oTest = test.GetRef()
  ;Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oTest = ", oTest, 1)

  ObjectReference planetReference = Game.GetPlayer()
  planet planetObject = planetReference.GetCurrentPlanet()
  Location locationObjectFromActor = planetReference.GetCurrentLocation()
  Location locationObjectFromPlanet = akTerminalRef.GetCurrentPlanet().GetLocation()
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference planetReference", planetReference, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "planet planetObject", planetObject, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "location locationObjectFromActor", locationObjectFromActor, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "location locationObjectFromPlanet", locationObjectFromPlanet, 1)

  ;/
  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "Execute the story event with the Keyword " + StoryManagerEventKeyword as String + " to trriger the story event for GetAllPlanet Quest", 1)
  missiongetallplanetsscript getAllPlanetsQuest = None ; #DEBUG_LINE_NO:63
  missiongetallplanetsscript[] startedQuests = StoryManagerEventKeyword.SendStoryEventAndWait(planetObject.GetLocation(), None, None, 0, 0) as missiongetallplanetsscript[] ; #DEBUG_LINE_NO:64
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MissionGetAllPlanetsScript[] startedQuests", startedQuests.Length, 1)
  If startedQuests.Length > 0 
    getAllPlanetsQuest = startedQuests[0]
    Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "Call GetSystemTraitValue from the Quest -> MissionGetAllPlanets", 1)
    Int systemTraitValue = getAllPlanetsQuest.GetSystemTraitValue()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Int systemTraitValue", systemTraitValue, 1)
    getAllPlanetsQuest.Stop()
  EndIf

  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "Execute the story event with the Keyword " + StoryManagerEventKeywordForSurveryLife as String + " to see if trriger the story event for Survey Planet Quest", 1)
  MissionSurveyQuestScript[] startedQuests2 = StoryManagerEventKeywordForSurveryLife.SendStoryEventAndWait(planetObject.GetLocation(), None, None, 0, 0) as MissionSurveyQuestScript[]; #DEBUG_LINE_NO:64
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurveyQuestScript[] startedQuests2", startedQuests2.Length, 1)
  
  MissionSurveyQuestScript[] startedQuests3 = StoryManagerEventKeywordCustomSurveyLife.SendStoryEventAndWait(planetObject.GetLocation(), None, None, 0, 0) as MissionSurveyQuestScript[]; #DEBUG_LINE_NO:64
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurveyQuestScript[] startedQuests3", startedQuests2.Length, 1)
  
  MissionSurveyQuestScript myquest1 = new MissionSurveyQuestScript
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey myquest1", myquest1, 1)
  /;

  ;/
  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "Force to start MB_Parent quest", 1)
  ;MB_Parent_PDT.StartNoWait()
  ;MB_Parent_PDT.StartSurveyLifeQuest(planetObject.GetLocation())

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MissionParentScript MB_Parent_PDT", MB_Parent_PDT, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsActive", MB_Parent_PDT.IsActive(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsCompleted", MB_Parent_PDT.IsCompleted(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsQuestTimerPaused", MB_Parent_PDT.IsQuestTimerPaused(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsRunning", MB_Parent_PDT.IsRunning(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsStarting", MB_Parent_PDT.IsStarting(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsStopped", MB_Parent_PDT.IsStopped(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MB_Parent_PDT.IsStopping", MB_Parent_PDT.IsStopping(), 1)

  MissionSurveyQuestScript[] startedQuestsSurveyLife = StoryManagerEventKeywordCustomSurveyLife.SendStoryEventAndWait(locationObjectFromPlanet, None, None, 0, 0) as MissionSurveyQuestScript[]; #DEBUG_LINE_NO:64
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MissionSurveyQuestScript[] startedQuestsSurveyLife", startedQuestsSurveyLife.Length, 1)

  Keyword Keyword_PlanetType03GasGiant = Game.GetForm(0x00295ED2) as Keyword
  Keyword Keyword_PlanetType04HotGasGiant = Game.GetForm(0x00295ECD) as Keyword
  Keyword Keyword_PlanetType06IceGiant = Game.GetForm(0x00295ED1) as Keyword
  Keyword Keyword_LocTypeMajorOrbital = Game.GetForm(0x00070A54) as Keyword
  Keyword Keyword_LocTypeSettledPlanet = Game.GetForm(0x00062F2F) as Keyword
  Keyword Keyword_LocTypeTest = Game.GetForm(0x002235B6) as Keyword

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_PlanetType03GasGiant", Keyword_PlanetType03GasGiant, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_PlanetType04HotGasGiant", Keyword_PlanetType04HotGasGiant, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_PlanetType06IceGiant", Keyword_PlanetType06IceGiant, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_LocTypeMajorOrbital", Keyword_LocTypeMajorOrbital, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_LocTypeSettledPlanet", Keyword_LocTypeSettledPlanet, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword Keyword_LocTypeTest", Keyword_LocTypeTest, 1)

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "planetObject.HasKeyword(Keyword_PlanetType03GasGiant)", planetObject.HasKeyword(Keyword_PlanetType03GasGiant), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "planetObject.HasKeyword(Keyword_PlanetType04HotGasGiant)", planetObject.HasKeyword(Keyword_PlanetType04HotGasGiant), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "planetObject.HasKeyword(Keyword_PlanetType06IceGiant)", planetObject.HasKeyword(Keyword_PlanetType06IceGiant), 1)  
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "locationObjectFromPlanet.HasKeyword(Keyword_LocTypeMajorOrbital)", locationObjectFromPlanet.HasKeyword(Keyword_LocTypeMajorOrbital), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "locationObjectFromPlanet.HasKeyword(Keyword_LocTypeSettledPlanet)", locationObjectFromPlanet.HasKeyword(Keyword_LocTypeSettledPlanet), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "locationObjectFromPlanet.HasKeyword(Keyword_LocTypeTest)", locationObjectFromPlanet.HasKeyword(Keyword_LocTypeTest), 1)

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "MissionSurveyQuestScript SQ_MissionSurvey", SQ_MissionSurvey, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsActive", SQ_MissionSurvey.IsActive(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsCompleted", SQ_MissionSurvey.IsCompleted(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsQuestTimerPaused", SQ_MissionSurvey.IsQuestTimerPaused(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsRunning", SQ_MissionSurvey.IsRunning(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsStarting", SQ_MissionSurvey.IsStarting(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsStopped", SQ_MissionSurvey.IsStopped(), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "SQ_MissionSurvey.IsStopping", SQ_MissionSurvey.IsStopping(), 1)

  SQ_MissionSurveyParentScript.StartSurveyLifeQuest(locationObjectFromPlanet)

  /;

  Cell cPlayerParentCell = Game.GetPlayer().GetParentCell()
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Cell cPlayerParentCell", cPlayerParentCell, 1)
  ;Int iIndex = cPlayerParentCell.GetNumRefs(1)

  ObjectReference cellParentRef =  cPlayerParentCell.GetParentRef()
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference cellParentRef", cellParentRef, 1)

  Form ObjectBase = Game.GetForm(2741888)
  Cell ObjectCell = ObjectBase as Cell
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Form ObjectBase", ObjectBase, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Cell ObjectCell", ObjectCell, 1)


  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference akTerminalRef", akTerminalRef, 1)

  ObjectReference oSelf = akTerminalRef.GetLinkedRef(TerminalKeyword)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference oSelf", oSelf, 1)

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Keyword TerminalKeyword", TerminalKeyword, 1)

  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "akTerminalRef.GetLinkedRefChain(TerminalKeyword, 100)", 1)  
  ObjectReference[] linkedRefChain = akTerminalRef.GetLinkedRefChain(None, 100)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference[] linkedRefChain", linkedRefChain as String, 1)
  Int I = 0 
  While I < linkedRefChain.Length
      Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference[" + I as String + "] linkedRefChain", linkedRefChain[I], 1)
      I += 1
  EndWhile

  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "akTerminalRef.GetRefsLinkedToMe(TerminalKeyword, None)", 1)
    ObjectReference[] linkedRefChildren = akTerminalRef.GetRefsLinkedToMe(TerminalKeyword, None)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference[] linkedRefChildren", linkedRefChildren as String, 1)
  I = 0
  While I < linkedRefChildren.length
      Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference[" + I as String + "] linkedRefChildren", linkedRefChildren[I], 1)
      I += 1
  EndWhile


  Javas_Debug.WriteLogComment(ScriptNameString, "OnTerminalMenuEnter", "FindAllReferencesWithKeyword", 1)
  ObjectReference[] allFloraRef = Game.GetPlayer().FindAllReferencesWithKeyword(FloraKeyword, 512)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "ObjectReference[] allFloraRef", allFloraRef as String, 1)
  Javas_Debug.WriteLogObjectReferences(ScriptNameString, "OnTerminalMenuEnter", allFloraRef, true, 1)

  ;ObjectReference[] Function GetLinkedRefChain(Keyword apKeyword, Int iMaxExpectedLinkedRefs) Native
  ;ObjectReference[] Function GetRefsLinkedToMe(Keyword apLinkKeyword, Keyword apExcludeKeyword) Native
  ;ObjectReference Function GetLinkedRef(Keyword apKeyword) Native
  ;Function WriteLogObjectReferences(String CallingScript, String functionOreventName, ObjectReference[] oRef, bool bShowBaseObject, Int debugModeEnabled) Global
  
  SpaceShipReference akShip = Game.GetPlayer().GetCurrentShipRef()
  flora[] testcaca = akShip.GetBiomeFlora(0.0)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "flora[] testcaca", testcaca as String, 1)

  ObjectReference[] oPlanetRef0 = Game.GetPlayer().GetCurrentShipRef().FindAllReferencesWithKeyword(PlanetKeyword, 2048)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#FindAllReferencesWithKeyword#-ObjectReference[] oPlanetRef0", oPlanetRef0 as String, 1)
  Javas_Debug.WriteLogObjectReferences(ScriptNameString, "OnTerminalMenuEnter", oPlanetRef0, true, 1)

  ObjectReference[] oPlanetRef = Game.GetPlayer().FindAllReferencesWithKeyword(PlanetKeyword, 2048)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#FindAllReferencesWithKeyword#-ObjectReference[] oPlanetRef", oPlanetRef as String, 1)
  Javas_Debug.WriteLogObjectReferences(ScriptNameString, "OnTerminalMenuEnter", oPlanetRef, true, 1)

  ObjectReference[] oPlanetRef1 = Game.GetPlayer().GetLinkedRefChain(PlanetKeyword, 25)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#GetLinkedRefChain#-ObjectReference[] oPlanetRef1", oPlanetRef1 as String, 1)
  Javas_Debug.WriteLogObjectReferences(ScriptNameString, "OnTerminalMenuEnter", oPlanetRef1, true, 1)
  
  ObjectReference[] oPlanetRef2 = Game.GetPlayer().GetRefsLinkedToMe(PlanetKeyword, None)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#GetLinkedRefChain#-ObjectReference[] oPlanetRef2", oPlanetRef2 as String, 1)
  Javas_Debug.WriteLogObjectReferences(ScriptNameString, "OnTerminalMenuEnter", oPlanetRef2, true, 1)
  
  ObjectReference oPlanetRef3 = Game.GetPlayer().GetLinkedRef(PlanetKeyword)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#GetRefsLinkedToMe#-ObjectReference oPlanetRef3", oPlanetRef3, 1)

  ;ObjectReference Function FindClosestReferenceOfType(Form arBaseObject, Float afX, Float afY, Float afZ, Float afRadius) Global Native
  Form BaseToScanFor = Game.GetForm(0x0005E0B0)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Form BaseToScanFor", BaseToScanFor, 1)
  ObjectReference oPlanetRef4 = Game.FindClosestReferenceOfType(BaseToScanFor,0,0,0,100000.0)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#FindClosestReferenceOfType#-ObjectReference[] oPlanetRef4", oPlanetRef4 as String, 1)


  Location[] planetLocations = Game.GetPlayer().GetCurrentLocation().GetParentLocations(PlanetKeyword)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "#GetParentLocations#-Location[] planetLocations", planetLocations as String, 1)
  Javas_Debug.WriteLogLocationArray(ScriptNameString, "OnTerminalMenuEnter", planetLocations, 1)


  ;/
  ReferenceAlias Property PlanetReference Auto Const mandatory
  Keyword Property LocTypeMajorOrbital Auto Const mandatory
  Keyword Property LocTypeStarSystem Auto Const mandatory
  LocationAlias Property PlanetReferencePlanetLocation Auto Const mandatory
  { current planet matching PlanetReference }
  LocationAlias Property PlanetReferenceSystemLocation Auto Const mandatory
  { current system location matching PlanetReference }
  ReferenceAlias Property PlayerShip Auto Const mandatory
  { player current ship }
  LocationAlias[] Property SystemPlanets Auto Const
  { array of location aliases for all planets in current system - many will be empty }
/;

  sQ_ParentScript SQ_ParentFromGame = Game.GetForm(461100) as sQ_ParentScript
  var[] valuesToShow = new var[7]
  valuesToShow[0] = ("ReferenceAlias Property PlanetReference = " + SQ_ParentFromGame.PlanetReference as String) as Var
  valuesToShow[1] = ("Keyword Property LocTypeMajorOrbital = " + SQ_ParentFromGame.LocTypeMajorOrbital as String) as Var
  valuesToShow[2] = ("Keyword Property LocTypeStarSystem = " + SQ_ParentFromGame.LocTypeStarSystem as String) as Var
  valuesToShow[3] = ("LocationAlias Property PlanetReferencePlanetLocation = " + SQ_ParentFromGame.PlanetReferencePlanetLocation as String) as Var
  valuesToShow[4] = ("LocationAlias Property PlanetReferenceSystemLocation = " + SQ_ParentFromGame.PlanetReferenceSystemLocation as String) as Var
  valuesToShow[5] = ("ReferenceAlias Property PlayerShip = " + SQ_ParentFromGame.PlayerShip as String) as Var
  valuesToShow[6] = ("LocationAlias[] Property SystemPlanets = " + SQ_ParentFromGame.SystemPlanets as String) as Var
  Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnTerminalMenuEnter", valuesToShow, 1)

  Location theLocation = SQ_ParentFromGame.SystemPlanets[0].GetLocation()
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuEnter", "Location theLocation", theLocation, 1)

  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 1)
EndEvent



Event OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 1)

  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Int auiMenuItemID", auiMenuItemID, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "TerminalMenu akTerminalBase", akTerminalBase, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "ObjectReference akTerminalRef", akTerminalRef, 1)
  

  ; OPTION: PLANET INFORMATION
  If auiMenuItemID == 0    
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Entered on Option 1 [Planet Information] from menu.", 0)

    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Keyword StoryManagerEventKeyword: " + StoryManagerEventKeyword as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Game.GetPlayer().GetCurrentLocation(): " + Game.GetPlayer().GetCurrentLocation() as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Game.GetPlayer().GetCurrentPlanet(): " + Game.GetPlayer().GetCurrentPlanet() as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->TriggerQuest: " + TriggerQuest as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->SQ_Parent: " + SQ_Parent as String, 0)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->SQ_MissionSurvey: " + SQ_MissionSurvey as String, 0)
    
    ;ObjectReference targetRef = TargetMapMarker.GetRef()

    ;/
    planet playerCurrentPlanet = Game.GetPlayer().GetCurrentPlanet()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "planet playerCurrentPlanet", playerCurrentPlanet, 1)   

    ObjectReference planetReferenceFromSQ_Parent = SQ_Parent.PlanetReference.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "ObjectReference planetReferenceFromSQ_Parent = ", planetReferenceFromSQ_Parent, 1)

    planet planetFromSQ_Parent = planetReferenceFromSQ_Parent.GetCurrentPlanet()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "planet planetFromSQ_Parent = ", planetFromSQ_Parent, 1)

    ObjectReference planetReferenceFromSQ_CurrentPlanet = SQ_CurrentPlanet.PlanetReference.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "ObjectReference planetReferenceFromSQ_CurrentPlanet = ", planetReferenceFromSQ_CurrentPlanet, 1)

    planet planetFromSQ_CurrentPlanet = planetReferenceFromSQ_CurrentPlanet.GetCurrentPlanet()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "planet planetFromSQ_CurrentPlanet = ", planetFromSQ_CurrentPlanet, 1)

    location locationFromSQ_CurrentPlanet = planetReferenceFromSQ_CurrentPlanet.GetCurrentLocation()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "location locationFromSQ_CurrentPlanet = ", locationFromSQ_CurrentPlanet, 1)
    Bool locationExplored =  locationFromSQ_CurrentPlanet.IsExplored() 
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Bool locationExplored  = ", locationExplored, 1)
    locationFromSQ_CurrentPlanet.SetExplored(true)

    Flora[] allPlanetFlora = planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(0.0)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Flora[] allPlanetFlora = ", allPlanetFlora as String, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "allPlanetFlora.length = ", allPlanetFlora.length, 1)

    allPlanetFlora = planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(100.0)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Flora[] allPlanetFlora = ", allPlanetFlora as String, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "allPlanetFlora.length = ", allPlanetFlora.length, 1)

    Flora floraUnscanned = allPlanetFlora[0]    
    ObjectReference floraUnscannedRef = Game.GetPlayer().PlaceAtMe(planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(100.0)[0] as Form, 1, False, False, True, None, None, True)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Flora floraUnscanned = ", floraUnscanned as String, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "ObjectReference floraUnscannedRef = ", floraUnscannedRef as String, 1)
    


    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(100.0)[0] = ", planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(100.0)[0] as String, 1)

    ;planetReferenceFromSQ_CurrentPlanet.GetBiomeFlora(100.0)[0].SetScanned(true)
    ;floraUnscannedRef.Delete()

    ObjectReference PlanetReferenceUsingFormFromSQ_CurrentPlanet = SQ_CurrentPlanet.PlanetReferenceUsingForm.GetRef()
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "ObjectReference PlanetReferenceUsingFormFromSQ_CurrentPlanet = ", PlanetReferenceUsingFormFromSQ_CurrentPlanet, 1)

    Form planetUsingFormFromSQ_CurrentPlanet = PlanetReferenceUsingFormFromSQ_CurrentPlanet
    Planet planetUsingFormFromSQ_CurrentPlanet2 = planetUsingFormFromSQ_CurrentPlanet as Planet
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Form planetUsingFormFromSQ_CurrentPlanet = ", planetUsingFormFromSQ_CurrentPlanet, 1)
    Javas_Debug.WriteLog(ScriptNameString, "OnTerminalMenuItemRun", "Form planetUsingFormFromSQ_CurrentPlanet2 = ", planetUsingFormFromSQ_CurrentPlanet2, 1)
    /;

    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Call function CheckCompletePlanetSurvey from SQ_Parent and send the current planet.", 0)
    ;SQ_Parent.CheckCompletePlanetSurvey(Game.GetPlayer().GetCurrentPlanet(), True)
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Get Flora and Fauna Abundance.", 0)
    ;SQ_Parent.GetPlanetAbundanceValue(Game.GetPlayer().GetCurrentPlanet())
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Test call MissionSurveyQuest.", 0)
    ;SQ_MissionSurvey.UpdateSurveyPercentSpecial(MissionIntValue01)
    ;SQ_MissionSurvey.OnQuestStarted()

    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Call Story Manager to Trigger the Planet Survey Quest", 0)
    ;Quest[] myQuests = StoryManagerEventKeyword.SendStoryEventAndWait(None, None, None, 0, 0); None, legendaryBookRef, bookHuntMapRef as ObjectReference, LegendaryBookLocation, LegendaryBookProximity) as sQ_BookHuntQuestScript[] ; #DEBUG_LINE_NO:43
    ;Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->myQuests.Length: " + myQuests.Length as String, 0)
    
    ;If myQuests.Length > 0 ; #DEBUG_LINE_NO:44
    ;  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->myQuests[0]: " + myQuests[0] as String, 0)
    ;  myQuest = myQuests[0] ; #DEBUG_LINE_NO:45
    ;  Int failsafeCount = 0 ; #DEBUG_LINE_NO:46
    ;  While myQuest.IsStarting() && failsafeCount < 100 ; #DEBUG_LINE_NO:47
    ;    Utility.Wait(0.100000001) ; #DEBUG_LINE_NO:48
    ;    failsafeCount += 1 ; #DEBUG_LINE_NO:49
    ;  EndWhile
    ;  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->Call Story Manager is running ...", 0)
    ;Else
    ;  Debug.Trace("::Javas_PlanetDBTerminalScript::DEBUG::VERBOSE->No Quest had been found!", 0)
    ;EndIf
    
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

  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnTerminalMenuItemRun(Int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)", 1)
EndEvent


