ScriptName OutpostHarvesterFloraPlanterScript Extends ObjectReference
{ script for placing flora at nodes }

;-- Variables ---------------------------------------

;-- Guards ------------------------------------------
;*** WARNING: Guard declaration syntax is EXPERIMENTAL, subject to change
Guard CreateFloraGuard

;-- Properties --------------------------------------
String Property FloraNodeName = "FloraNode" Auto Const
{ base node name for flora in "planters" }
Int Property FloraNodeMax = 8 Auto Const
{ max number of nodes in any planter (used to create node name string) }
ActorValue Property HandScannerTarget Auto mandatory
{ used to tag created flora }
Float Property FloraScaleMin = 0.150000006 Auto Const
{ possibly temp - we may get this from an actor value on the Flora object that we are spawning }
Float Property FloraScaleMax = 0.25 Auto Const
{ possibly temp - we may get this from an actor value on the Flora object that we are spawning }
ObjectReference[] Property createdFlora Auto hidden

;-- Functions ---------------------------------------

Event OnInit()
  createdFlora = new ObjectReference[0] ; #DEBUG_LINE_NO:22
EndEvent

Function RegisterForCreateFloraEvent(outpostharvesterflorascript myHarvester)
  Self.RegisterForCustomEvent(myHarvester as ScriptObject, "outpostharvesterflorascript_CreateFloraEvent") ; #DEBUG_LINE_NO:27
EndFunction

Event OutpostHarvesterFloraScript.CreateFloraEvent(outpostharvesterflorascript akSender, Var[] akArgs)
  Flora floraToCreate = akArgs[0] as Flora ; #DEBUG_LINE_NO:31
  Self.CreateFlora(floraToCreate) ; #DEBUG_LINE_NO:33
EndEvent

Function CreateFlora(Flora floraToCreate)
  Guard CreateFloraGuard ;*** WARNING: Experimental syntax, may be incorrect: Guard  ; #DEBUG_LINE_NO:41
    Self.ClearCreatedFlora() ; #DEBUG_LINE_NO:43
    If floraToCreate ; #DEBUG_LINE_NO:44
      Int I = 1 ; #DEBUG_LINE_NO:45
      While I <= FloraNodeMax ; #DEBUG_LINE_NO:46
        String nodeName = FloraNodeName ; #DEBUG_LINE_NO:47
        If I < 10 ; #DEBUG_LINE_NO:48
          nodeName += "0" ; #DEBUG_LINE_NO:49
        EndIf
        nodeName += I as String ; #DEBUG_LINE_NO:51
        If Self.HasNode(nodeName) ; #DEBUG_LINE_NO:53
          ObjectReference createdFloraRef = Self.PlaceAtNode(nodeName, floraToCreate as Form, 1, False, True, True, True) ; #DEBUG_LINE_NO:54
          createdFlora.add(createdFloraRef, 1) ; #DEBUG_LINE_NO:56
          createdFloraRef.SetHarvested(True) ; #DEBUG_LINE_NO:57
          createdFloraRef.SetValue(HandScannerTarget, 1.0) ; #DEBUG_LINE_NO:58
          Float scale = Utility.RandomFloat(FloraScaleMin, FloraScaleMax) ; #DEBUG_LINE_NO:59
          createdFloraRef.SetScale(scale) ; #DEBUG_LINE_NO:60
          createdFloraRef.Enable(False) ; #DEBUG_LINE_NO:61
          createdFloraRef.SetScanned(True) ; #DEBUG_LINE_NO:63
        EndIf
        I += 1 ; #DEBUG_LINE_NO:67
      EndWhile
    EndIf
  EndGuard ;*** WARNING: Experimental syntax, may be incorrect: EndGuard 
EndFunction

Function ClearCreatedFlora()
  Int I = 0 ; #DEBUG_LINE_NO:75
  While createdFlora.Length > 0 ; #DEBUG_LINE_NO:76
    Self.ClearCreatedFloraSingle(createdFlora[0]) ; #DEBUG_LINE_NO:77
    createdFlora.remove(0, 1) ; #DEBUG_LINE_NO:78
  EndWhile
EndFunction

Function ClearCreatedFloraSingle(ObjectReference createdFloraRef)
  If createdFloraRef != None ; #DEBUG_LINE_NO:84
    createdFloraRef.Delete() ; #DEBUG_LINE_NO:85
    createdFloraRef = None ; #DEBUG_LINE_NO:86
  EndIf
EndFunction
