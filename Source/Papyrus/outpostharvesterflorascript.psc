ScriptName OutpostHarvesterFloraScript Extends OutpostEventHandlerParent
{ manages creating the appropriate flora for a flora harvester }

;-- Structs -----------------------------------------
Struct ResourceGlobalData
  ActorValue resourceAV
  GlobalVariable resourceGlobal
EndStruct


;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Group Required_Properties
  ActorValue Property OrganicResourceAV Auto hidden
  { set by menu from build menu event }
  Keyword Property OutpostLinkFloraPlanter Auto mandatory
  { used to get planters to spawn flora }
EndGroup

Group Optional_Properties
  outpostharvesterflorascript:resourceglobaldata[] Property ResourceGlobals Auto Const
  { OPTIONAL - array of global variables to update when the builder is set to build the matching resource AV }
  Float Property ResourceGlobalValueToSet = 25.0 Auto Const
  { value to set resourceGlobal to }
EndGroup

outpostharvesterfloraplanterscript[] Property myPlanters Auto hidden

;-- Functions ---------------------------------------

Function HandleOnWorkshopObjectPlaced(ObjectReference akReference)
  ; Empty function
EndFunction

Event OnInit()
  myPlanters = Self.GetRefsLinkedToMe(OutpostLinkFloraPlanter, None) as outpostharvesterfloraplanterscript[] ; #DEBUG_LINE_NO:33
  Int I = 0 ; #DEBUG_LINE_NO:36
  While I < myPlanters.Length ; #DEBUG_LINE_NO:37
    myPlanters[I].RegisterForCreateFloraEvent(Self) ; #DEBUG_LINE_NO:38
    I += 1 ; #DEBUG_LINE_NO:39
  EndWhile
  Self.UpdateResource() ; #DEBUG_LINE_NO:42
EndEvent

Event OnBuilderMenuSelect(ActorValue akActorValue)
  OrganicResourceAV = akActorValue ; #DEBUG_LINE_NO:48
  Self.UpdateResource() ; #DEBUG_LINE_NO:49
  If ResourceGlobals.Length > 0 ; #DEBUG_LINE_NO:52
    Int resourceGlobalIndex = ResourceGlobals.findstruct("resourceAV", OrganicResourceAV, 0) ; #DEBUG_LINE_NO:53
    If resourceGlobalIndex > -1 ; #DEBUG_LINE_NO:54
      GlobalVariable globalToSet = ResourceGlobals[resourceGlobalIndex].resourceGlobal ; #DEBUG_LINE_NO:56
      If globalToSet as Bool && globalToSet.GetValue() != ResourceGlobalValueToSet ; #DEBUG_LINE_NO:57
        globalToSet.SetValue(ResourceGlobalValueToSet) ; #DEBUG_LINE_NO:58
      EndIf
    EndIf
  EndIf
EndEvent

Function HandleOnWorkshopObjectRemoved(ObjectReference akReference)
  Self.ClearCreatedFlora() ; #DEBUG_LINE_NO:72
EndFunction

Function UpdateResource()
  Self.CreateFlora() ; #DEBUG_LINE_NO:78
EndFunction

Function CreateFlora()
  If OrganicResourceAV ; #DEBUG_LINE_NO:83
    ObjectReference workshopRef = Self.GetWorkshop() ; #DEBUG_LINE_NO:84
    Flora floraToCreate = Self.GetFloraForResource(OrganicResourceAV) ; #DEBUG_LINE_NO:85
    If floraToCreate ; #DEBUG_LINE_NO:87
      Var[] kargs = new Var[1] ; #DEBUG_LINE_NO:88
      kargs[0] = floraToCreate as Var ; #DEBUG_LINE_NO:89
      Self.SendCustomEvent("outpostharvesterflorascript_CreateFloraEvent", kargs) ; #DEBUG_LINE_NO:90
    EndIf
  EndIf
EndFunction

Function ClearCreatedFlora()
  Var[] kargs = new Var[1] ; #DEBUG_LINE_NO:101
  kargs[0] = None ; #DEBUG_LINE_NO:102
  Self.SendCustomEvent("outpostharvesterflorascript_CreateFloraEvent", kargs) ; #DEBUG_LINE_NO:103
EndFunction
