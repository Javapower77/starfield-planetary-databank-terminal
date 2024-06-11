ScriptName Javas_Config Extends ScriptObject


Function ToggleDebugMode() Global
    GlobalVariable Javas_DebugEnabled = Game.GetFormFromFile(2083, "Javas_PlanetTerminal.esm") as GlobalVariable
    If Javas_DebugEnabled.GetValueInt() == 0 
        Javas_DebugEnabled.SetValueInt(1) 
    Else
        Javas_DebugEnabled.SetValueInt(0) 
    EndIf
EndFunction

Bool Function IsDebugEnabled() Global
    GlobalVariable Javas_DebugEnabled = Game.GetFormFromFile(2083, "Javas_PlanetTerminal.esm") as GlobalVariable
    If Javas_DebugEnabled.GetValueInt() == 1 
        return True
    Else
        return False
    EndIf
EndFunction

Bool Function IsDebugLogAllInUniqueUserLogFile() Global
    GlobalVariable Javas_DebugLogAllInUniqueUserLogFile = Game.GetFormFromFile(2084, "Javas_PlanetTerminal.esm") as GlobalVariable
    If Javas_DebugLogAllInUniqueUserLogFile.GetValueInt() == 1 
        return True
    Else
        return False
    EndIf
EndFunction

String Function GetModName() Global
    return "PlanetaryDatabank"
EndFunction