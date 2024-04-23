ScriptName PlanetDBTerminal Extends ObjectReference conditional

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Keyword[] Property traitsKeywordToDiscover Auto hidden
planet Property planetToCheck Auto hidden
Bool Property traitDataAwarded = False Auto conditional hidden

;-- Functions ---------------------------------------

Event OnTerminalMenuItemRun(Int auiMenuItemID, terminalmenu akTerminalBase, ObjectReference akTerminalRef)
  ; Empty function
EndEvent
