ScriptName OutpostHarvesterFaunaScript Extends OutpostEventHandlerParent
{ manages creating the appropriate actor for a fauna harvester }

;-- Structs -----------------------------------------
Struct FaunaCreationData
  Keyword CreatureKeyword
  Int createCount
EndStruct

Struct ResourceGlobalData
  ActorValue resourceAV
  GlobalVariable resourceGlobal
EndStruct


;-- Variables ---------------------------------------
Int InitTimerID = 3 Const
Int RespawnResetTimerID = 2 Const
Float RespawnSeconds = 0.0
Int RespawnTimerID = 1 Const
Bool allowRespawn = True

;-- Guards ------------------------------------------
;*** WARNING: Guard declaration syntax is EXPERIMENTAL, subject to change
Guard createdActorsGuard

;-- Properties --------------------------------------
Group Required_Properties
  Bool Property DeleteActorWhenDestroyed = True Auto Const
  { if TRUE, actor will be deleted when this object is destroyed (actor will be recreated when object is repaired) }
  Keyword Property OutpostLinkCreatedActorTarget Auto Const mandatory
  { AUTOFILL - used to get reference to link created actor to }
  outpostharvesterfaunascript:faunacreationdata[] Property FaunaCreation Auto Const mandatory
  { array used to decide how many to create
        order with highest CreationCount first in the array }
  Faction Property OutpostFaunaFaction Auto Const mandatory
  { faction to put on all created actors to be friends with player }
  ReferenceAlias Property OutpostFauna Auto Const mandatory
  { alias on SQ_Parent used to stamp data on created fauna }
  ActorValue Property OrganicResourceAV Auto hidden
  { set by menu from build menu event }
  ActorValue Property HandScannerTarget Auto mandatory
  { used to tag created actors }
EndGroup

Group Optional_Properties
  LocationRefType Property CreatedActorBaseRefType Auto Const
  { OPTIONAL: loc ref to tag created actor }
  Keyword Property OutpostLinkCreatedActor Auto Const
  { OPTIONAL: used to link actor to this ref }
  outpostharvesterfaunascript:resourceglobaldata[] Property ResourceGlobals Auto Const
  { OPTIONAL - array of global variables to update when the builder is set to build the matching resource AV }
  Float Property ResourceGlobalValueToSet = 25.0 Auto Const
  { value to set resourceGlobal to }
EndGroup

Group Respawn_Properties
{ How long to wait after an actor dies before respawning? }
  Float Property RespawnSecondsMin = 10.0 Auto Const
  { min value for RespawnSeconds - this is the starting value }
  Float Property RespawnSecondsMax = 120.0 Auto Const
  { max that RespawnSeconds is allowed to reach }
  Float Property RespawnSecondsAddPerDeath = 10.0 Auto Const
  { how many seconds to add to RespawnSeconds per death }
  Float Property RespawnResetSeconds = 900.0 Auto Const
  { how long after last death to reset Respawn time to min }
EndGroup

Actor[] Property createdActors Auto hidden

;-- Functions ---------------------------------------

Event Actor.OnEnterBleedout(Actor akSource)
  ; Empty function
EndEvent

Function HandleOnWorkshopObjectPlaced(ObjectReference akReference)
  ; Empty function
EndFunction

Event OnInit()
  Guard createdActorsGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:85
    createdActors = new Actor[0] ; #DEBUG_LINE_NO:86
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
  RespawnSeconds = RespawnSecondsMin ; #DEBUG_LINE_NO:88
  Self.StartTimer(1.0, InitTimerID) ; #DEBUG_LINE_NO:89
EndEvent

Event OnBuilderMenuSelect(ActorValue akActorValue)
  OrganicResourceAV = akActorValue ; #DEBUG_LINE_NO:95
  Self.UpdateResource() ; #DEBUG_LINE_NO:96
  If ResourceGlobals.Length > 0 ; #DEBUG_LINE_NO:98
    Int resourceGlobalIndex = ResourceGlobals.findstruct("resourceAV", OrganicResourceAV, 0) ; #DEBUG_LINE_NO:99
    If resourceGlobalIndex > -1 ; #DEBUG_LINE_NO:100
      GlobalVariable globalToSet = ResourceGlobals[resourceGlobalIndex].resourceGlobal ; #DEBUG_LINE_NO:102
      If globalToSet as Bool && globalToSet.GetValue() != ResourceGlobalValueToSet ; #DEBUG_LINE_NO:103
        globalToSet.SetValue(ResourceGlobalValueToSet) ; #DEBUG_LINE_NO:104
      EndIf
    EndIf
  EndIf
EndEvent

Event Actor.OnDeath(Actor akSource, ObjectReference akKiller)
  Self.StartTimer(RespawnSeconds, RespawnTimerID) ; #DEBUG_LINE_NO:119
EndEvent

Event OnObjectRepaired(ObjectReference akReference)
  Self.CreateActors() ; #DEBUG_LINE_NO:125
EndEvent

Function HandleOnWorkshopObjectRemoved(ObjectReference akReference)
  Self.ClearCreatedActors(True) ; #DEBUG_LINE_NO:136
EndFunction

Event OnObjectDestroyed(ObjectReference akReference)
  If DeleteActorWhenDestroyed ; #DEBUG_LINE_NO:142
    Self.ClearCreatedActors(True) ; #DEBUG_LINE_NO:143
  EndIf
EndEvent

Event OnTimer(Int aiTimerID)
  If aiTimerID == RespawnTimerID ; #DEBUG_LINE_NO:148
    Self.RespawnCreatedActor() ; #DEBUG_LINE_NO:149
  ElseIf aiTimerID == RespawnResetTimerID ; #DEBUG_LINE_NO:150
    RespawnSeconds = RespawnSecondsMin ; #DEBUG_LINE_NO:153
  ElseIf aiTimerID == InitTimerID ; #DEBUG_LINE_NO:154
    Self.UpdateResource() ; #DEBUG_LINE_NO:155
  EndIf
EndEvent

Function UpdateResource()
  Self.ClearCreatedActors(True) ; #DEBUG_LINE_NO:160
  Self.CreateActors() ; #DEBUG_LINE_NO:161
EndFunction

Function ClearCreatedActors(Bool bDeleteActor)
  Guard createdActorsGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:166
    Int I = createdActors.Length - 1 ; #DEBUG_LINE_NO:167
    While I > -1 ; #DEBUG_LINE_NO:168
      Self.ClearCreatedActor(createdActors[I], bDeleteActor) ; #DEBUG_LINE_NO:169
      createdActors.removelast() ; #DEBUG_LINE_NO:170
      I -= 1 ; #DEBUG_LINE_NO:171
    EndWhile
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Function ClearCreatedActor(Actor createdActorRef, Bool bDeleteActor)
  If createdActorRef != None ; #DEBUG_LINE_NO:179
    Self.UnregisterForRemoteEvent(createdActorRef as ScriptObject, "OnDeath") ; #DEBUG_LINE_NO:180
    Self.UnregisterForRemoteEvent(createdActorRef as ScriptObject, "OnEnterBleedout") ; #DEBUG_LINE_NO:181
    If bDeleteActor ; #DEBUG_LINE_NO:183
      createdActorRef.Delete() ; #DEBUG_LINE_NO:185
    EndIf
    createdActorRef = None ; #DEBUG_LINE_NO:188
  EndIf
EndFunction

Function RespawnCreatedActor()
  Guard createdActorsGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:195
    Bool respawnedActor = False ; #DEBUG_LINE_NO:197
    Int I = 0 ; #DEBUG_LINE_NO:198
    While I < createdActors.Length && respawnedActor == False ; #DEBUG_LINE_NO:199
      Actor createdActorRef = createdActors[I] ; #DEBUG_LINE_NO:200
      If createdActorRef.IsDead() ; #DEBUG_LINE_NO:201
        If allowRespawn && respawnedActor == False ; #DEBUG_LINE_NO:202
          respawnedActor = True ; #DEBUG_LINE_NO:203
          createdActors[I] = Self.CreateActor(None) ; #DEBUG_LINE_NO:204
        EndIf
      EndIf
      I += 1 ; #DEBUG_LINE_NO:207
    EndWhile
    Self.CheckForRespawnOrDestroy() ; #DEBUG_LINE_NO:210
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Function CreateActors()
  Guard createdActorsGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:216
    If createdActors == None ; #DEBUG_LINE_NO:219
      createdActors = new Actor[0] ; #DEBUG_LINE_NO:220
    EndIf
    If createdActors.Length <= 0 ; #DEBUG_LINE_NO:223
      Actor newActor = Self.CreateActor(None) ; #DEBUG_LINE_NO:227
      If newActor ; #DEBUG_LINE_NO:228
        createdActors.add(newActor, 1) ; #DEBUG_LINE_NO:229
        Int I = 0 ; #DEBUG_LINE_NO:231
        Int createCount = 0 ; #DEBUG_LINE_NO:232
        While I < FaunaCreation.Length && createCount == 0 ; #DEBUG_LINE_NO:233
          outpostharvesterfaunascript:faunacreationdata theData = FaunaCreation[I] ; #DEBUG_LINE_NO:234
          If newActor.HasKeyword(theData.CreatureKeyword) ; #DEBUG_LINE_NO:235
            createCount = theData.createCount ; #DEBUG_LINE_NO:236
          EndIf
          I += 1 ; #DEBUG_LINE_NO:238
        EndWhile
        If createCount > 1 ; #DEBUG_LINE_NO:241
          createCount -= 1 ; #DEBUG_LINE_NO:242
          I = 0 ; #DEBUG_LINE_NO:244
          While I < createCount ; #DEBUG_LINE_NO:245
            Actor createdActor = Self.CreateActor(None) ; #DEBUG_LINE_NO:246
            createdActors.add(createdActor, 1) ; #DEBUG_LINE_NO:247
            I += 1 ; #DEBUG_LINE_NO:248
          EndWhile
        EndIf
      EndIf
    EndIf
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Actor Function CreateActor(Actor createdActorRef)
  If createdActorRef ; #DEBUG_LINE_NO:258
    If createdActorRef.IsDead() == False ; #DEBUG_LINE_NO:260
      createdActorRef.RestoreValue(Game.GetHealthAV(), 9999.0) ; #DEBUG_LINE_NO:261
    EndIf
  ElseIf OrganicResourceAV
    ObjectReference workshopRef = Self.GetWorkshop() ; #DEBUG_LINE_NO:264
    ActorBase createdActorBase = Self.GetActorBaseForResource(OrganicResourceAV) ; #DEBUG_LINE_NO:266
    If createdActorBase ; #DEBUG_LINE_NO:268
      createdActorRef = Self.PlaceAtMe(createdActorBase as Form, 1, False, True, True, None, None, True) as Actor ; #DEBUG_LINE_NO:269
      createdActorRef.IgnoreFriendlyHits(True) ; #DEBUG_LINE_NO:270
      createdActorRef.SetValue(HandScannerTarget, 1.0) ; #DEBUG_LINE_NO:271
      createdActorRef.SetScanned(True) ; #DEBUG_LINE_NO:272
      OutpostFauna.ApplyToRef(createdActorRef as ObjectReference) ; #DEBUG_LINE_NO:273
      createdActorRef.AddToFaction(OutpostFaunaFaction) ; #DEBUG_LINE_NO:274
      Self.RegisterForRemoteEvent(createdActorRef as ScriptObject, "OnDeath") ; #DEBUG_LINE_NO:275
      Self.RegisterForRemoteEvent(createdActorRef as ScriptObject, "OnEnterBleedout") ; #DEBUG_LINE_NO:276
      If OutpostLinkCreatedActor ; #DEBUG_LINE_NO:279
        ObjectReference createdActorTargetRef = Self.GetLinkedRef(OutpostLinkCreatedActorTarget) ; #DEBUG_LINE_NO:280
        If createdActorTargetRef == None ; #DEBUG_LINE_NO:281
          createdActorTargetRef = Self as ObjectReference ; #DEBUG_LINE_NO:282
        EndIf
        createdActorRef.SetLinkedRef(createdActorTargetRef, OutpostLinkCreatedActor, False) ; #DEBUG_LINE_NO:285
        createdActorRef.MoveTo(createdActorTargetRef, 0.0, 0.0, 0.0, True, False) ; #DEBUG_LINE_NO:286
      EndIf
      If CreatedActorBaseRefType ; #DEBUG_LINE_NO:289
        Location workshopLocation = workshopRef.GetCurrentLocation() ; #DEBUG_LINE_NO:291
        createdActorRef.SetLocRefType(workshopLocation, CreatedActorBaseRefType) ; #DEBUG_LINE_NO:293
      EndIf
      createdActorRef.Enable(False) ; #DEBUG_LINE_NO:298
    EndIf
  EndIf
  Return createdActorRef ; #DEBUG_LINE_NO:305
EndFunction

Function CheckForRespawnOrDestroy()
  allowRespawn = False ; #DEBUG_LINE_NO:312
  Int deadCount = 0 ; #DEBUG_LINE_NO:314
  Int I = 0 ; #DEBUG_LINE_NO:315
  While I < createdActors.Length ; #DEBUG_LINE_NO:316
    If createdActors[I].IsDead() ; #DEBUG_LINE_NO:317
      deadCount += 1 ; #DEBUG_LINE_NO:318
    EndIf
    I += 1 ; #DEBUG_LINE_NO:320
  EndWhile
  If deadCount >= createdActors.Length ; #DEBUG_LINE_NO:323
    Self.DamageObject(9999.0) ; #DEBUG_LINE_NO:325
    Self.SetDestroyed(True) ; #DEBUG_LINE_NO:326
    Self.ClearCreatedActors(False) ; #DEBUG_LINE_NO:327
  ElseIf deadCount > 0 ; #DEBUG_LINE_NO:328
    Self.StartTimer(RespawnSeconds, RespawnTimerID) ; #DEBUG_LINE_NO:331
    RespawnSeconds += RespawnSecondsAddPerDeath ; #DEBUG_LINE_NO:333
    RespawnSeconds = Math.Min(RespawnSecondsMax, RespawnSeconds) ; #DEBUG_LINE_NO:335
    Self.StartTimer(RespawnResetSeconds, RespawnResetTimerID) ; #DEBUG_LINE_NO:339
  EndIf
  allowRespawn = True ; #DEBUG_LINE_NO:341
EndFunction
