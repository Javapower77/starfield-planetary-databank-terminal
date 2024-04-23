ScriptName Javas_Quest_Trigger_Fragments Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property QuestToTrigger Auto Const mandatory

;-- Functions ---------------------------------------

Function Fragment_Stage_0010_Item_00()
  Debug.Trace("::Javas_Quest_Trigger_Fragments::DEBUG::VERBOSE->IN:FUNCTION: Fragment_Stage_0010_Item_00()", 0)  
  Debug.Trace("::Javas_Quest_Trigger_Fragments::DEBUG::VERBOSE->Quest QuestToTrigger:" + QuestToTrigger as String, 0)  
  Debug.Trace("::Javas_Quest_Trigger_Fragments::DEBUG::VERBOSE->Trigger Quest", 0)  
  QuestToTrigger.Start() ; #DEBUG_LINE_NO:22
  Debug.Trace("::Javas_Quest_Trigger_Fragments::DEBUG::VERBOSE->Stop Current Quest that call the Triggered Quest", 0)  
  Self.Stop() ; #DEBUG_LINE_NO:23
EndFunction
