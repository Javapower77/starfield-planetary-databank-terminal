ScriptName RQScript Extends Quest
{ Parent script that can be used directly or extended by other Random Quest scripts as required. }

;-- Variables ---------------------------------------
Int DialogueAV_LastHello = -1
rescript REScriptIns
Form previouslyRandomlySpawnedForm
planet questPlanet

;-- Properties --------------------------------------
Group Autofill
  sq_groups_questscript Property SQ_Groups Auto Const mandatory
  GlobalVariable Property RQ_Debug_SummonShipOnStart Auto Const mandatory
  ActorValue Property RQ_AV_PrimaryObjectiveKnown Auto Const mandatory
  ActorValue Property RQ_AV_PrimaryObjectiveFail Auto Const mandatory
  ActorValue Property RQ_AV_PrimaryObjectiveSuccess Auto Const mandatory
  ActorValue Property RQ_AV_Hello Auto Const mandatory
  ActorValue Property RQ_AV_SecondaryObjectiveKnown Auto Const mandatory
  ActorValue Property RQ_AV_SecondaryObjectiveFail Auto Const mandatory
  ActorValue Property RQ_AV_SecondaryObjectiveSuccess Auto Const mandatory
  ActorValue Property RQ_AV_EnemyGroup Auto Const mandatory
  ActorValue Property RQ_AV_Dungeon_LocTheme Auto Const mandatory
  rq_parentscript Property RQ_Parent Auto Const mandatory
  GlobalVariable Property RQ_Hello_NoneValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Calm_PreAcceptValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Calm_PostAcceptValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Calm_SuccessValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Calm_FailureValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Stressed_PreAcceptValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Stressed_PostAcceptValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Stressed_SuccessValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_Stressed_FailureValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_AboardShipValue Auto Const mandatory
  GlobalVariable Property RQ_Hello_DepartingShipValue Auto Const mandatory
EndGroup

Group Dialogue_Variable_Handling
{ Calls to "SetDialogueAV_xxx()" functions will set AVs on DialogueAliases so we can conditionalize dialogue "imported" via "Use Dialogue Subtype" }
  Alias[] Property DialogueAliases Auto Const mandatory
  { Aliases in here will have actorvalues set on them via calls to "SetDialogueAV()" usually in quest stages. }
  ReferenceAlias Property RepresentativeEnemyAlias Auto Const
  { An alias holding a representative of the "enemy group" of the quest (ex: the Boss of a dungeon)
	This will be used to set the RQ_AV_EnemyGroup on DialogueAliases }
  LocationAlias Property DungeonLocationAlias Auto Const
  { An alias holding the dungeon location for the quest, if any. This is used to set the RQ_AV_Dungeon_LocTheme on DialogueAliases }
  GlobalVariable Property DialogueAV_Initial_Hello Auto Const mandatory
  { The initial Hello state for Actors in this RQ. }
  LocationAlias[] Property OwnedLocations Auto Const
  { An array holding any locations that should get ownership passed along by the starting quest (for settlement RQs) }
EndGroup

Group Quest_Giver_Handling
  ReferenceAlias Property Alias_ForcedPrimary Auto Const mandatory
  { An alias that represents the first NPC in a group spoken to at the outset of a quest. Filled by the Greeting scene. }
  ReferenceAlias Property Alias_QuestGiver Auto Const mandatory
  { An alias that represents the Quest Giver. Assigned at runtime when the quest is initialized, and when ForcedPrimary (the first NPC the player decides to speak to) is assigned.
	  Used to refer back to this NPC after the Greeting Scene. }
  RefCollectionAlias Property RefCollectionToPromoteQuestGiverFromOnSpawn Auto Const
  { if not none, when the SpawnEvent comes from the DefaultGroupSpawnQuestEvent, the first actor in this RefCollection will be promoted to the Alias_QuestGiver and Alias_ForcedPrimary alias }
EndGroup

Group Locks_And_Keys
  Alias[] Property ObjectsToLock Auto Const
  Alias[] Property ObjectsToPutKeysIn Auto Const
  { will randonly put keys to ObjectsToLock in containers of ObjectsToPutKeysIn }
  RefCollectionAlias Property PlacedKeys Auto Const
  { will hold refs to keys that were created and placed }
EndGroup

Group Shutdown
  Alias[] Property ShutdownAliases Auto Const mandatory
  { Aliases that will be considered when determining shutdown logic }
  Int Property ShutdownStageRequired_Stage = 100 Auto Const
  { Prior to this stage being set, quest will shutdown when player leaves the planet.
	  After this stage is set, quest won't shutdown until ShutdownAllowed_Stage is set. }
  Int Property ShutdownAllowed_Stage Auto Const mandatory
  { Automated system (defined by ShutdownOn_ property below) will shutdown the quest only if this stage has been set. }
  Bool Property ShutdownAllowed_UnloadedOrDeadAlisaes = True Auto Const
  { If true (default), automated system (defined by ShutdownOn_ property) will shutdown the quest only if refs in ShutdownAliases have no 3d or are dead. }
  Bool Property ShutdownOn_LocationChange = True Auto Const
  { if true (default), will attempt to shut down when player changes locations }
  Bool Property AlsoCallShutDownOnREScript = True Auto Const
  { if true (default), when shutting down, will cast self as REScript and call the Shutdown() function on it }
EndGroup


;-- Functions ---------------------------------------

Function OnAliasChangedSpecific(ReferenceAlias akSender, ObjectReference akObject, Bool abRemove)
  ; Empty function
EndFunction

Function OnQuestGiverSet(ObjectReference akQuestGiver)
  ; Empty function
EndFunction

Function QuestStartedSpecific()
  ; Empty function
EndFunction

Event OnQuestStarted()
  REScriptIns = (Self as Quest) as rescript ; #DEBUG_LINE_NO:110
  defaultgroupspawnquestscript DefaultGroupSpawnQuestScriptIns = (Self as Quest) as defaultgroupspawnquestscript ; #DEBUG_LINE_NO:113
  If DefaultGroupSpawnQuestScriptIns ; #DEBUG_LINE_NO:114
    Self.RegisterForCustomEvent(DefaultGroupSpawnQuestScriptIns as ScriptObject, "defaultgroupspawnquestscript_SpawnGroupDoneEvent") ; #DEBUG_LINE_NO:116
  Else
    Self.InitializeNPCs() ; #DEBUG_LINE_NO:119
  EndIf
  If ShutdownOn_LocationChange ; #DEBUG_LINE_NO:122
    Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnLocationChange") ; #DEBUG_LINE_NO:123
    questPlanet = Game.GetPlayer().GetCurrentPlanet() ; #DEBUG_LINE_NO:124
  EndIf
  Self.LockObjectsAndPlaceKeys() ; #DEBUG_LINE_NO:127
  If RepresentativeEnemyAlias ; #DEBUG_LINE_NO:128
    Self.SetDialogueAV_EnemyGroup() ; #DEBUG_LINE_NO:129
  EndIf
  Self.RegisterForRemoteEvent(Alias_ForcedPrimary as ScriptObject, "OnAliasChanged") ; #DEBUG_LINE_NO:134
  If RepresentativeEnemyAlias ; #DEBUG_LINE_NO:135
    Self.RegisterForRemoteEvent(RepresentativeEnemyAlias as ScriptObject, "OnAliasChanged") ; #DEBUG_LINE_NO:136
  EndIf
  Int I = 0 ; #DEBUG_LINE_NO:139
  While I < DialogueAliases.Length ; #DEBUG_LINE_NO:140
    ReferenceAlias currentRefAlias = DialogueAliases[I] as ReferenceAlias ; #DEBUG_LINE_NO:141
    RefCollectionAlias currentRefColAlias = DialogueAliases[I] as RefCollectionAlias ; #DEBUG_LINE_NO:142
    If currentRefAlias ; #DEBUG_LINE_NO:144
      Self.RegisterForRemoteEvent(currentRefAlias as ScriptObject, "OnAliasChanged") ; #DEBUG_LINE_NO:145
    ElseIf currentRefColAlias
      Self.RegisterForRemoteEvent(currentRefColAlias as ScriptObject, "OnAliasChanged") ; #DEBUG_LINE_NO:147
    EndIf
    I += 1 ; #DEBUG_LINE_NO:150
  EndWhile
  Self.QuestStartedSpecific() ; #DEBUG_LINE_NO:153
EndEvent

Function SetLocationOwnership(Faction owningFaction)
  If owningFaction as Bool && OwnedLocations.Length > 0 ; #DEBUG_LINE_NO:161
    Int I = 0 ; #DEBUG_LINE_NO:162
    While I < OwnedLocations.Length ; #DEBUG_LINE_NO:163
      Location ownedLocation = OwnedLocations[I].GetLocation() ; #DEBUG_LINE_NO:164
      If ownedLocation ; #DEBUG_LINE_NO:165
        ownedLocation.SetFactionOwner(owningFaction) ; #DEBUG_LINE_NO:166
      EndIf
      I += 1 ; #DEBUG_LINE_NO:168
    EndWhile
  EndIf
EndFunction

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, Int aiValue1, Int aiValue2)
  If RQ_Debug_SummonShipOnStart.GetValue() == 1.0 ; #DEBUG_LINE_NO:176
    (Game.GetPlayer() as debugplayersummonshipscript).DebugSummonShip() ; #DEBUG_LINE_NO:178
  EndIf
EndEvent

Event DefaultGroupSpawnQuestScript.SpawnGroupDoneEvent(defaultgroupspawnquestscript akSender, Var[] akArgs)
  defaultgroupspawnquestscript:spawngroupdoneeventargs spawnArgs = akArgs[0] as defaultgroupspawnquestscript:spawngroupdoneeventargs ; #DEBUG_LINE_NO:184
  Int spawnGroupID = spawnArgs.SpawnGroupNumber ; #DEBUG_LINE_NO:185
  sq_groupscript spawnedGroup = spawnArgs.spawnedGroup ; #DEBUG_LINE_NO:186
  Self.InitializeNPCs() ; #DEBUG_LINE_NO:189
  defaultgroupspawnquestscript DefaultGroupSpawnQuestScriptIns = (Self as Quest) as defaultgroupspawnquestscript ; #DEBUG_LINE_NO:192
  Faction owningFaction = DefaultGroupSpawnQuestScriptIns.GetGroupOwnershipFaction(spawnGroupID) ; #DEBUG_LINE_NO:193
  If owningFaction ; #DEBUG_LINE_NO:194
    Self.SetLocationOwnership(owningFaction) ; #DEBUG_LINE_NO:195
  EndIf
EndEvent

Event ReferenceAlias.OnAliasChanged(ReferenceAlias akSender, ObjectReference akObject, Bool abRemove)
  If abRemove == False ; #DEBUG_LINE_NO:201
    If akSender == RepresentativeEnemyAlias || DialogueAliases.find(akSender as Alias, 0) >= 0 ; #DEBUG_LINE_NO:202
      Self.SetDialogueAV_EnemyGroup() ; #DEBUG_LINE_NO:203
    EndIf
    If akSender == Alias_ForcedPrimary ; #DEBUG_LINE_NO:206
      Alias_QuestGiver.ForceRefTo(akObject) ; #DEBUG_LINE_NO:207
      Self.OnQuestGiverSet(akObject) ; #DEBUG_LINE_NO:208
    EndIf
    Self.SetDialogueAV_InitialHello() ; #DEBUG_LINE_NO:211
  EndIf
  Self.OnAliasChangedSpecific(akSender, akObject, abRemove) ; #DEBUG_LINE_NO:213
EndEvent

Function InitializeNPCs()
  If RefCollectionToPromoteQuestGiverFromOnSpawn ; #DEBUG_LINE_NO:221
    If Alias_QuestGiver.GetActorRef() == None ; #DEBUG_LINE_NO:222
      ObjectReference initialQuestGiverRef = RefCollectionToPromoteQuestGiverFromOnSpawn.GetAt(0) ; #DEBUG_LINE_NO:224
      Alias_QuestGiver.ForceRefTo(initialQuestGiverRef) ; #DEBUG_LINE_NO:227
    EndIf
  EndIf
EndFunction

Event RefCollectionAlias.OnAliasChanged(RefCollectionAlias akSender, ObjectReference akObject, Bool abRemove)
  If abRemove == False ; #DEBUG_LINE_NO:238
    Self.SetDialogueAV_EnemyGroup() ; #DEBUG_LINE_NO:239
  EndIf
  Self.SetDialogueAV_InitialHello() ; #DEBUG_LINE_NO:242
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
  If akSender == Game.GetPlayer() ; #DEBUG_LINE_NO:247
    Self.CheckForShutdown(akNewLoc) ; #DEBUG_LINE_NO:248
  EndIf
EndEvent

Function CheckForShutdown(Location akNewLoc)
  If Self.GetStageDone(ShutdownAllowed_Stage) && Self.ShutDownCheckAliases() ; #DEBUG_LINE_NO:254
    Self.Shutdown() ; #DEBUG_LINE_NO:255
  ElseIf (ShutdownStageRequired_Stage > -1 && Self.GetStageDone(ShutdownStageRequired_Stage) == False && questPlanet as Bool) && akNewLoc as Bool ; #DEBUG_LINE_NO:256
    If Game.GetPlayer().GetCurrentPlanet() != questPlanet ; #DEBUG_LINE_NO:258
      Self.Shutdown() ; #DEBUG_LINE_NO:260
    EndIf
  EndIf
EndFunction

Function LockObjectsAndPlaceKeys()
  ObjectReference[] refsToLock = commonarrayfunctions.GetReferencesFromAliasArray(ObjectsToLock) ; #DEBUG_LINE_NO:271
  ObjectReference[] refsToPutKeysIn = commonarrayfunctions.GetReferencesFromAliasArray(ObjectsToPutKeysIn) ; #DEBUG_LINE_NO:272
  Int I = 0 ; #DEBUG_LINE_NO:277
  While I < refsToLock.Length ; #DEBUG_LINE_NO:278
    ObjectReference currentRefToLock = refsToLock[I] ; #DEBUG_LINE_NO:279
    Key keyToPlace = currentRefToLock.GetKey() ; #DEBUG_LINE_NO:284
    If keyToPlace ; #DEBUG_LINE_NO:290
      Int iRandom = Utility.RandomInt(0, refsToPutKeysIn.Length - 1) ; #DEBUG_LINE_NO:292
      ObjectReference randomRef = refsToPutKeysIn[iRandom] ; #DEBUG_LINE_NO:293
      ObjectReference keyRef = randomRef.PlaceAtMe(keyToPlace as Form, 1, False, True, True, None, None, True) ; #DEBUG_LINE_NO:295
      randomRef.AddItem(keyRef as Form, 1, False) ; #DEBUG_LINE_NO:296
      PlacedKeys.addREf(keyRef) ; #DEBUG_LINE_NO:297
      keyRef.Enable(False) ; #DEBUG_LINE_NO:298
    EndIf
    I += 1 ; #DEBUG_LINE_NO:303
  EndWhile
EndFunction

Function DebugMoveToKey(Int KeysIndex)
  Game.GetPlayer().MoveTo(PlacedKeys.GetAt(KeysIndex), 0.0, 0.0, 0.0, True, False) ; #DEBUG_LINE_NO:310
EndFunction

Function SetDialogueAV(ActorValue AV, Int value)
  Int I = 0 ; #DEBUG_LINE_NO:315
  While I < DialogueAliases.Length ; #DEBUG_LINE_NO:316
    ReferenceAlias refAlias = DialogueAliases[I] as ReferenceAlias ; #DEBUG_LINE_NO:317
    RefCollectionAlias refColAlias = DialogueAliases[I] as RefCollectionAlias ; #DEBUG_LINE_NO:318
    If refAlias ; #DEBUG_LINE_NO:320
      refAlias.TryToSetValue(AV, value as Float) ; #DEBUG_LINE_NO:322
    ElseIf refColAlias
      refColAlias.SetValue(AV, value as Float) ; #DEBUG_LINE_NO:326
    EndIf
    I += 1 ; #DEBUG_LINE_NO:330
  EndWhile
EndFunction

Function SetDialogueAV_Hello(Int value)
  DialogueAV_LastHello = value ; #DEBUG_LINE_NO:336
  Self.SetDialogueAV(RQ_AV_Hello, value) ; #DEBUG_LINE_NO:337
EndFunction

Function SetDialogueAV_PrimaryObjectiveKnown()
  Self.SetDialogueAV(RQ_AV_PrimaryObjectiveKnown, 1) ; #DEBUG_LINE_NO:342
EndFunction

Function SetDialogueAV_PrimaryObjectiveFail()
  Self.SetDialogueAV(RQ_AV_PrimaryObjectiveFail, 1) ; #DEBUG_LINE_NO:346
EndFunction

Function SetDialogueAV_PrimaryObjectiveSuccess()
  Self.SetDialogueAV(RQ_AV_PrimaryObjectiveSuccess, 1) ; #DEBUG_LINE_NO:350
EndFunction

Function SetDialogueAV_SecondaryObjectiveKnown()
  Self.SetDialogueAV(RQ_AV_SecondaryObjectiveKnown, 1) ; #DEBUG_LINE_NO:354
EndFunction

Function SetDialogueAV_SecondaryObjectiveFail()
  Self.SetDialogueAV(RQ_AV_SecondaryObjectiveFail, 1) ; #DEBUG_LINE_NO:358
EndFunction

Function SetDialogueAV_SecondaryObjectiveSuccess()
  Self.SetDialogueAV(RQ_AV_SecondaryObjectiveSuccess, 1) ; #DEBUG_LINE_NO:362
EndFunction

Function SetDialogueAV_InitialHello()
  If DialogueAV_LastHello == -1 ; #DEBUG_LINE_NO:366
    Self.SetDialogueAV_Hello(DialogueAV_Initial_Hello.GetValueInt()) ; #DEBUG_LINE_NO:367
  Else
    Self.SetDialogueAV_Hello(DialogueAV_LastHello) ; #DEBUG_LINE_NO:369
  EndIf
EndFunction

Function SetDialogueAV_Hello_None()
  Self.SetDialogueAV_Hello(RQ_Hello_NoneValue.GetValueInt()) ; #DEBUG_LINE_NO:374
EndFunction

Function SetDialogueAV_Hello_Calm_PreAccept()
  Self.SetDialogueAV_Hello(RQ_Hello_Calm_PreAcceptValue.GetValueInt()) ; #DEBUG_LINE_NO:378
EndFunction

Function SetDialogueAV_Hello_Calm_PostAccept()
  Self.SetDialogueAV_Hello(RQ_Hello_Calm_PostAcceptValue.GetValueInt()) ; #DEBUG_LINE_NO:382
EndFunction

Function SetDialogueAV_Hello_Calm_Success()
  Self.SetDialogueAV_Hello(RQ_Hello_Calm_SuccessValue.GetValueInt()) ; #DEBUG_LINE_NO:386
EndFunction

Function SetDialogueAV_Hello_Calm_Failure()
  Self.SetDialogueAV_Hello(RQ_Hello_Calm_FailureValue.GetValueInt()) ; #DEBUG_LINE_NO:390
EndFunction

Function SetDialogueAV_Hello_Stressed_PreAccept()
  Self.SetDialogueAV_Hello(RQ_Hello_Stressed_PreAcceptValue.GetValueInt()) ; #DEBUG_LINE_NO:394
EndFunction

Function SetDialogueAV_Hello_Stressed_PostAccept()
  Self.SetDialogueAV_Hello(RQ_Hello_Stressed_PostAcceptValue.GetValueInt()) ; #DEBUG_LINE_NO:398
EndFunction

Function SetDialogueAV_Hello_Stressed_Success()
  Self.SetDialogueAV_Hello(RQ_Hello_Stressed_SuccessValue.GetValueInt()) ; #DEBUG_LINE_NO:402
EndFunction

Function SetDialogueAV_Hello_Stressed_Failure()
  Self.SetDialogueAV_Hello(RQ_Hello_Stressed_FailureValue.GetValueInt()) ; #DEBUG_LINE_NO:406
EndFunction

Function SetDialogueAV_Hello_AboardShip()
  Self.SetDialogueAV_Hello(RQ_Hello_AboardShipValue.GetValueInt()) ; #DEBUG_LINE_NO:410
EndFunction

Function SetDialogueAV_Hello_DepartingShip()
  Self.SetDialogueAV_Hello(RQ_Hello_DepartingShipValue.GetValueInt()) ; #DEBUG_LINE_NO:414
EndFunction

Function SetDialogueAV_EnemyGroup()
  If RepresentativeEnemyAlias ; #DEBUG_LINE_NO:418
    Actor enemyActor = RepresentativeEnemyAlias.GetActorReference() ; #DEBUG_LINE_NO:419
    If enemyActor ; #DEBUG_LINE_NO:422
      Self.SetDialogueAV(RQ_AV_EnemyGroup, SQ_Groups.GetGroupFactionIDValueByActor(enemyActor, False)) ; #DEBUG_LINE_NO:423
    EndIf
  EndIf
EndFunction

Bool Function ShutDownCheckAliases()
  Bool returnVal = True ; #DEBUG_LINE_NO:430
  If ShutdownAllowed_UnloadedOrDeadAlisaes ; #DEBUG_LINE_NO:432
    ReferenceAlias[] refAliasArray = commonarrayfunctions.GetReferenceAliasesFromAliasArray(ShutdownAliases) ; #DEBUG_LINE_NO:433
    RefCollectionAlias[] refColAliasArray = commonarrayfunctions.GetRefCollectionAliasesFromAliasArray(ShutdownAliases) ; #DEBUG_LINE_NO:434
    Int count = commonarrayfunctions.GetCountLoadedAndAliveStateFromAliasArray(refAliasArray, True, True) ; #DEBUG_LINE_NO:436
    If count == 0 ; #DEBUG_LINE_NO:438
      Int I = 0 ; #DEBUG_LINE_NO:439
      While count == 0 && I < refColAliasArray.Length ; #DEBUG_LINE_NO:440
        count += refColAliasArray[I].GetCountAliveAnd3DLoaded() ; #DEBUG_LINE_NO:441
        I += 1 ; #DEBUG_LINE_NO:442
      EndWhile
    EndIf
    If count > 0 ; #DEBUG_LINE_NO:448
      returnVal = False ; #DEBUG_LINE_NO:449
    EndIf
  EndIf
  Return returnVal ; #DEBUG_LINE_NO:455
EndFunction

Function Shutdown()
  If AlsoCallShutDownOnREScript && REScriptIns as Bool ; #DEBUG_LINE_NO:459
    REScriptIns.Shutdown() ; #DEBUG_LINE_NO:461
  EndIf
  Self.Stop() ; #DEBUG_LINE_NO:464
EndFunction

Bool Function Trace(ScriptObject CallingObject, String asTextToPrint, Int aiSeverity, String MainLogName, String SubLogName, Bool bShowNormalTrace, Bool bShowWarning, Bool bPrefixTraceWithLogNames)
  Return Debug.TraceLog(CallingObject, asTextToPrint, MainLogName, SubLogName, aiSeverity, bShowNormalTrace, bShowWarning, bPrefixTraceWithLogNames, True) ; #DEBUG_LINE_NO:472
EndFunction

; Fixup hacks for debug-only function: warning
Bool Function warning(ScriptObject CallingObject, String asTextToPrint, Int aiSeverity, String MainLogName, String SubLogName, Bool bShowNormalTrace, Bool bShowWarning, Bool bPrefixTraceWithLogNames)
  Return false ; #DEBUG_LINE_NO:476
EndFunction
