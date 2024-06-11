ScriptName Javas_Testing extends ObjectReference

;-- Variables  ---------------------------------------
String ScriptNameString  = "Javas_Testing"

;-- Properties ---------------------------------------

;-- Events ---------------------------------------
Event OnCellLoad() 
    Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnCellLoad()", 1)

    ObjectReference[] linkedRefs = Self.GetLinkedRefChain(None, 100);
    Int I = 0
    While I < linkedRefs.length
        Javas_Debug.WriteLog(ScriptNameString, "OnCellLoad", "ObjectReference[" + I as String + "] linkedRefs_Self", linkedRefs[I], 1)
        I += 1
    EndWhile

    ObjectReference[] refsLinkedToMe = Self.GetRefsLinkedToMe(None, None);
    I = 0
    While I < refsLinkedToMe.length
        Javas_Debug.WriteLog(ScriptNameString, "OnCellLoad", "ObjectReference[" + I as String + "] refsLinkedToMe_Self", refsLinkedToMe[I], 1)
        I += 1
    EndWhile

    ObjectReference oSelf = Self.GetLinkedRef(None)
    Javas_Debug.WriteLog(ScriptNameString, "OnCellLoad", "ObjectReference oSelf", oSelf, 1)

    Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnCellLoad()", 1)
EndEvent

;-- Functions ---------------------------------------
Function Pruebas(ObjectReference akRef)
    Javas_Debug.WriteLogFunction(ScriptNameString, "IN", "Pruebas(ObjectReference akRef)", 1)

    Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference akRef", akRef, 1)

    Cell cSelfParentCell = Self.GetParentCell()
    Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "Cell cSelfParentCell", cSelfParentCell, 1)

    ObjectReference oSelf = Self.GetLinkedRef(None)
    Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference oSelf", oSelf, 1)

    Javas_Debug.WriteLogComment(ScriptNameString, "Pruebas", "Self.GetLinkedRefChain(None, 100)", 1)
    ObjectReference[] linkedRefs = Self.GetLinkedRefChain(None, 100);
    Int I = 0
    While I < linkedRefs.length
        Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference[" + I as String + "] linkedRefs_Self", linkedRefs[I], 1)
        I += 1
    EndWhile

    Javas_Debug.WriteLogComment(ScriptNameString, "Pruebas", "Self.GetRefsLinkedToMe(None, None)", 1)
    ObjectReference[] refsLinkedToMe = Self.GetRefsLinkedToMe(None, None);
    I = 0
    While I < refsLinkedToMe.length
        Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference[" + I as String + "] refsLinkedToMe_Self", refsLinkedToMe[I], 1)
        I += 1
    EndWhile

    Javas_Debug.WriteLogComment(ScriptNameString, "Pruebas", "akRef.GetLinkedRefChain(None, 100)", 1)
    ObjectReference[] linkedRefs_akRef = akRef.GetLinkedRefChain(None, 100);
    I = 0
    While I < linkedRefs_akRef.length
        Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference[" + I as String + "] linkedRefs_akRef", linkedRefs_akRef[I], 1)
        I += 1
    EndWhile

    Javas_Debug.WriteLogComment(ScriptNameString, "Pruebas", "akRef.GetRefsLinkedToMe(None, None)", 1)
    ObjectReference[] refsLinkedToMe_akRef = akRef.GetRefsLinkedToMe(None, None);
    I = 0
    While I < refsLinkedToMe_akRef.length
        Javas_Debug.WriteLog(ScriptNameString, "Pruebas", "ObjectReference[" + I as String + "] refsLinkedToMe_akRef", refsLinkedToMe_akRef[I], 1)
        I += 1
    EndWhile

    Javas_Debug.WriteLogFunction(ScriptNameString, "OUT", "Pruebas(ObjectReference akRef)", 1)
EndFunction