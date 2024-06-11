ScriptName rq_scancreaturesscript Extends RQScript

;-- Structs -----------------------------------------
Struct herdSize
  Keyword herdSizeKeyword
  Int extraSpawnCount
  Float rewardMult
EndStruct


;-- Variables ---------------------------------------
ActorBase ScanTargetBase
Int iDebugNextTarget

;-- Properties --------------------------------------
Group Scan_Properties
  Int Property ObjectiveToDisplayForScanning = 100 Auto Const
  { Objective for scanning }
  Int Property StageToSetIfScannedDead = 150 Auto Const
  { Stage to set when scanning a target that is dead) }
  Int Property SpawnStage = 200 Auto Const
  { Spawn some targets at this stage to ensure some exist (the stage when player is given the objective) }
  Int Property StageToSetOnCompletelyScanned = 300 Auto Const
  { Stage to set when scanning target base object's GetPercentageKnown() >= 1 }
  GlobalVariable Property PercentageScannedTextDisplay Auto Const mandatory
  { Quest instance global to use to display percentage in quest objective }
  GlobalVariable Property CreditsRewardRadiantQuestLarge Auto Const mandatory
  { base value for quest reward }
  GlobalVariable Property RQ_ScanQuestReward Auto Const mandatory
  { actual value for quest reward - modified by herd size (solitary creatures are much harder to find) }
  ReferenceAlias Property Alias_CenterMarker Auto Const mandatory
  { The center marker of the area to spawn predators and prey }
  RefCollectionAlias Property ScanTargets Auto Const mandatory
  { Ref Collection that will hold targets; currently spawned }
  ReferenceAlias Property SpawnAt Auto Const mandatory
  { Where to spawn Targets at }
  Int Property SpawnAmountMinBase = 1 Auto Const
  Int Property SpawnAmountMaxBase = 3 Auto Const
  rq_scancreaturesscript:herdsize[] Property HerdSizeSpawnCount Auto Const
  { array matching herd size keyword with extra spawn count }
EndGroup


;-- Functions ---------------------------------------

Function QuestStartedSpecific()
  RQ_ScanQuestReward.SetValue(CreditsRewardRadiantQuestLarge.GetValueInt() as Float) ; #DEBUG_LINE_NO:54
  If Self.InitializeScanTarget() ; #DEBUG_LINE_NO:56
    Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnPlayerScannedObject") ; #DEBUG_LINE_NO:57
    Self.RegisterForRemoteEvent(Game.GetPlayer() as ScriptObject, "OnKill") ; #DEBUG_LINE_NO:58
  Else
    Self.Shutdown() ; #DEBUG_LINE_NO:61
  EndIf
EndFunction

Event OnStageSet(Int auiStageID, Int auiItemID)
  If auiStageID == SpawnStage ; #DEBUG_LINE_NO:68
    Self.SpawnTargetRefs() ; #DEBUG_LINE_NO:71
  EndIf
EndEvent

Event Actor.OnPlayerScannedObject(Actor akSender, ObjectReference akScannedRef)
  Self.TryToUpdatePercentKnown(akScannedRef) ; #DEBUG_LINE_NO:76
EndEvent

Event Actor.OnKill(Actor akSender, ObjectReference akVictim)
  Self.TryToUpdatePercentKnown(akVictim) ; #DEBUG_LINE_NO:81
EndEvent

Function TryToUpdatePercentKnown(ObjectReference akTargetReference)
  Actor actorRef = akTargetReference as Actor ; #DEBUG_LINE_NO:86
  If actorRef ; #DEBUG_LINE_NO:87
    ActorBase scannedActorBase = actorRef.GetMatchingPlanetActorBase() ; #DEBUG_LINE_NO:88
    If scannedActorBase == ScanTargetBase ; #DEBUG_LINE_NO:92
      Self.UpdatePercentKnown(actorRef as ObjectReference, True) ; #DEBUG_LINE_NO:93
    EndIf
  EndIf
EndFunction

Bool Function InitializeScanTarget()
  Bool initialized = False ; #DEBUG_LINE_NO:100
  ObjectReference spawnAtRef = SpawnAt.GetReference() ; #DEBUG_LINE_NO:103
  ActorBase[] allowedBases = spawnAtRef.GetBiomeActors(0.5) ; #DEBUG_LINE_NO:104
  If allowedBases.Length == 0 ; #DEBUG_LINE_NO:108
    
  Else
    Int iRandom = Utility.RandomInt(0, allowedBases.Length - 1) ; #DEBUG_LINE_NO:111
    ScanTargetBase = allowedBases[iRandom] ; #DEBUG_LINE_NO:112
    ObjectReference spawnedRef = spawnAtRef.PlaceAtMe(ScanTargetBase as Form, 1, False, False, True, None, ScanTargets as Alias, True) ; #DEBUG_LINE_NO:117
    Float percentageKnown = spawnedRef.GetPercentageKnown() ; #DEBUG_LINE_NO:121
    Self.UpdatePercentKnown(spawnedRef, False) ; #DEBUG_LINE_NO:123
    initialized = True ; #DEBUG_LINE_NO:125
  EndIf
  Return initialized ; #DEBUG_LINE_NO:127
EndFunction

Function UpdatePercentKnown(ObjectReference scannedRef, Bool removeRefFromTargetsCollection)
  Float percentageKnown = scannedRef.GetPercentageKnown() ; #DEBUG_LINE_NO:131
  Int precentAsInt = (percentageKnown * 100.0) as Int ; #DEBUG_LINE_NO:136
  PercentageScannedTextDisplay.SetValue(precentAsInt as Float) ; #DEBUG_LINE_NO:138
  Self.UpdateCurrentInstanceGlobal(PercentageScannedTextDisplay) ; #DEBUG_LINE_NO:139
  Actor scannedActorRef = scannedRef as Actor ; #DEBUG_LINE_NO:141
  If scannedActorRef as Bool && scannedActorRef.IsDead() ; #DEBUG_LINE_NO:142
    Self.SetStage(StageToSetIfScannedDead) ; #DEBUG_LINE_NO:143
  EndIf
  If percentageKnown >= 1.0 ; #DEBUG_LINE_NO:146
    Self.SetStage(StageToSetOnCompletelyScanned) ; #DEBUG_LINE_NO:149
  EndIf
  If removeRefFromTargetsCollection ; #DEBUG_LINE_NO:153
    ScanTargets.RemoveRef(scannedRef) ; #DEBUG_LINE_NO:154
  EndIf
EndFunction

Function SpawnTargetRefs()
  ObjectReference spawnAtRef = SpawnAt.GetReference() ; #DEBUG_LINE_NO:160
  ObjectReference spawnedRef = ScanTargets.GetAt(0) ; #DEBUG_LINE_NO:161
  Int minSpawnCount = SpawnAmountMinBase ; #DEBUG_LINE_NO:165
  Int maxSpawnCount = SpawnAmountMaxBase ; #DEBUG_LINE_NO:166
  Int h = 0 ; #DEBUG_LINE_NO:169
  Bool foundHerd = False ; #DEBUG_LINE_NO:170
  While h < HerdSizeSpawnCount.Length && foundHerd == False ; #DEBUG_LINE_NO:171
    rq_scancreaturesscript:herdsize theHerdSize = HerdSizeSpawnCount[h] ; #DEBUG_LINE_NO:172
    foundHerd = spawnedRef.HasKeyword(theHerdSize.herdSizeKeyword) ; #DEBUG_LINE_NO:173
    If foundHerd ; #DEBUG_LINE_NO:174
      minSpawnCount += theHerdSize.extraSpawnCount ; #DEBUG_LINE_NO:177
      maxSpawnCount += theHerdSize.extraSpawnCount ; #DEBUG_LINE_NO:178
      RQ_ScanQuestReward.SetValueInt(Math.Floor(CreditsRewardRadiantQuestLarge.GetValue() * theHerdSize.rewardMult)) ; #DEBUG_LINE_NO:180
    EndIf
    h += 1 ; #DEBUG_LINE_NO:182
  EndWhile
  Int amountToSpawn = Utility.RandomInt(minSpawnCount, maxSpawnCount) ; #DEBUG_LINE_NO:185
  If amountToSpawn > 0 ; #DEBUG_LINE_NO:189
    ObjectReference[] spawnedRefs = new ObjectReference[0] ; #DEBUG_LINE_NO:190
    Int I = 0 ; #DEBUG_LINE_NO:192
    While I < amountToSpawn ; #DEBUG_LINE_NO:193
      spawnedRefs.add(spawnAtRef.PlaceAtMe(ScanTargetBase as Form, 1, False, False, True, None, None, True), 1) ; #DEBUG_LINE_NO:194
      I += 1 ; #DEBUG_LINE_NO:195
    EndWhile
    ScanTargets.AddArray(spawnedRefs) ; #DEBUG_LINE_NO:200
  EndIf
EndFunction

Function DebugMoveToNextTarget()
  Game.GetPlayer().MoveTo(ScanTargets.GetAt(iDebugNextTarget), 0.0, 0.0, 0.0, True, False) ; #DEBUG_LINE_NO:206
  iDebugNextTarget += 1 % ScanTargets.GetCount() ; #DEBUG_LINE_NO:208
EndFunction
