ScriptName Util Extends ScriptObject Native hidden


String Function TruncateString(String sText, Int iLengthToTruncate) Global
    Int[] iTest = Utility.SplitStringChars(sText)
    String sNewText = ""
    Int x = 0
    String sSpacesToFill = ""
    If iTest.Length < iLengthToTruncate ; if the string is smaller than truncated length, fill the string with space until get the truncate length
        Int y = 0        
        While y < (iLengthToTruncate-iTest.Length)
            sSpacesToFill = sSpacesToFill + " "
            y += 1
        EndWhile
        return sText + sSpacesToFill ; return the original text plus the spaces fill
    ElseIf iTest.Length == iLengthToTruncate ; the text length is iqual to the length to truncate so return the string without do anything
            return sText
        Else
            While x < iLengthToTruncate ; need to truncate the text
                sNewText = sNewText + ConvertCharCodeToString(iTest[x])
                x += 1
            EndWhile
            return sNewText
    EndIf
EndFunction

String[] Function StringToArray(String sText, String cDelimiter) Global
    Int[] iTemp = Utility.SplitStringChars(RemoveLastChar(sText, cDelimiter))
    Int[] iCharTemp = Utility.SplitStringChars(cDelimiter)
    Int x = 0
    Int iArrays = 0
    String[] sArrayString = new String[RepeatedChar(sText, iCharTemp[0])] ; get the fixed size of the array asking how many the demiliter char is repeated
    String sTextInEachArray = ""
    While x < iTemp.Length
        If iTemp[x] != iCharTemp[0] ; if the char is not the same as the delimiter char keep constructing the string
            sTextInEachArray = sTextInEachArray + ConvertCharCodeToString(iTemp[x])
        Else ; found the delimiter char so add the constructed string to the array and clean the value of the construct string to generated the next one
            sArrayString[iArrays] = sTextInEachArray
            sTextInEachArray = ""
            iArrays += 1
        EndIf
        x += 1
    EndWhile
    return sArrayString
EndFunction

String Function RemoveLastChar(string sText, String cCharToFind) Global
    Int[] iTemp = Utility.SplitStringChars(sText)
    Int[] iCharTemp = Utility.SplitStringChars(cCharToFind)

    Int X = 0
    Int Y = 0
    Int iStringLength = iTemp.Length
    String sTextReturn = ""

    if iTemp[iTemp.Length] == iCharTemp[0] ; Check if the last char of the string is the char to be removed
        iStringLength = iStringLength - 1 ; So later while reconstruct the string without the last char
    EndIf

    While X < iStringLength
        sTextReturn = sTextReturn + ConvertCharCodeToString(iTemp[X])
        X += 1
    EndWhile
    return sTextReturn   
EndFunction

Int Function RepeatedChar(String sText, String cCharToFind) Global
    Int[] iTemp = Utility.SplitStringChars(sText)
    Int[] iCharTemp = Utility.SplitStringChars(cCharToFind)
    Int X = 0
    Int iRepeated = 0
    While X < iTemp.Length
        If iTemp[X] == iCharTemp[0] ; If the repeted char was found then increment the repeted time
            iRepeated += 1
        EndIf
        X += 1
    EndWhile
    return iRepeated
EndFunction

Int Function StringLength(String sText) Global
    Int[] iTemp = Utility.SplitStringChars(sText)
    return iTemp.Length
EndFunction
  
String Function ToUpper(String sText) Global
    Int[] iTest = Utility.SplitStringChars(sText)
    debug.trace(iTest as String, 1)
    debug.trace(sText, 1)
    String sReturn = ""

    ;/
    Int X = 0
    While X < iTest.Length
        debug.trace("X=" + x as string + "|iTest[x]=" + iTest[X] as string + "=" + ConvertCharCodeToString(iTest[X]), 1)
        if iTest[X] >= 97 && iTest[X] <= 122
            sReturn = sReturn + ConvertCharCodeToString(iTest[X]-32)
            debug.trace("Minuscula:" + ConvertCharCodeToString(iTest[X]-32) + "|sReturn=" + sReturn, 1)
        Else
            sReturn = sReturn + ConvertCharCodeToString(iTest[X])
            debug.trace("Mayuscula:" + ConvertCharCodeToString(iTest[X]) + "|sReturn=" + sReturn, 1)
        EndIf   
   
        X += 1
    EndWhile  
    /;
    return sReturn
EndFunction
  

String Function ConvertCharCodeToString(Int iCharCode) Global
    String[] sCharMap = GetArrayCharMap()
    return sCharMap[iCharCode-32]
EndFunction
  
String[] Function GetArrayCharMap() Global
    String[] aChar = new String[95]
    aChar[0]=" "
    aChar[1]="!"
    aChar[2]="'"
    aChar[3]="#"
    aChar[4]="$"
    aChar[5]="%"
    aChar[6]="&"
    aChar[7]="'"
    aChar[8]="("
    aChar[9]=")"
    aChar[10]="*"
    aChar[11]="+"
    aChar[12]=","
    aChar[13]="-"
    aChar[14]="."
    aChar[15]="/"
    aChar[16]="0"
    aChar[17]="1"
    aChar[18]="2"
    aChar[19]="3"
    aChar[20]="4"
    aChar[21]="5"
    aChar[22]="6"
    aChar[23]="7"
    aChar[24]="8"
    aChar[25]="9"
    aChar[26]=":"
    aChar[27]=";"
    aChar[28]="<"
    aChar[29]="="
    aChar[30]=">"
    aChar[31]="?"
    aChar[32]="@"
    aChar[33]="A"
    aChar[34]="B"
    aChar[35]="C"
    aChar[36]="D"
    aChar[37]="E"
    aChar[38]="F"
    aChar[39]="G"
    aChar[40]="H"
    aChar[41]="I"
    aChar[42]="J"
    aChar[43]="K"
    aChar[44]="L"
    aChar[45]="M"
    aChar[46]="N"
    aChar[47]="O"
    aChar[48]="P"
    aChar[49]="Q"
    aChar[50]="R"
    aChar[51]="S"
    aChar[52]="T"
    aChar[53]="U"
    aChar[54]="V"
    aChar[55]="W"
    aChar[56]="X"
    aChar[57]="Y"
    aChar[58]="Z"
    aChar[59]="["
    aChar[60]="|"
    aChar[61]="]"
    aChar[62]="^"
    aChar[63]="_"
    aChar[64]="`"
    aChar[65]="a"
    aChar[66]="b"
    aChar[67]="c"
    aChar[68]="d"
    aChar[69]="e"
    aChar[70]="f"
    aChar[71]="g"
    aChar[72]="h"
    aChar[73]="i"
    aChar[74]="j"
    aChar[75]="k"
    aChar[76]="l"
    aChar[77]="m"
    aChar[78]="n"
    aChar[79]="o"
    aChar[80]="p"
    aChar[81]="q"
    aChar[82]="r"
    aChar[83]="s"
    aChar[84]="t"
    aChar[85]="u"
    aChar[86]="v"
    aChar[87]="w"
    aChar[88]="x"
    aChar[89]="y"
    aChar[90]="z"
    aChar[91]="{"
    aChar[92]="|"
    aChar[93]="}"
    aChar[94]="~"
    return aChar
EndFunction