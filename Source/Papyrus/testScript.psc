ScriptName testScript Extends ObjectReference

;-- Variables ---------------------------------------
planet targetPlanet
String ScriptNameString = "testScript"

;-- Properties --------------------------------------
Group MissionTypeData
  missionsurveyquestscript Property SQ_SurveyQuest Auto Const
  sq_parentscript Property SQ_Parent Auto Const mandatory
  ReferenceAlias Property PlanetTarget Auto Const mandatory
  { target ref in planet orbit - used to get target Planet }
  Float Property RewardPlanetTraitMult = 1000.0 Auto Const
  { multiplier based on total trait value on planet for total reward }
  Float Property RewardPlanetAbundanceMult = 1000.0 Auto Const
  { multiplier based on total abundance value on planet for total reward }
  Int Property SurveyObjective = 10 Auto Const
  { objective for surveying }
  Int Property MissionAcceptTutorialID = 0 Auto Const
  { tutorial ID when accepting this mission - see SQ_Parent.TutorialMessages }
  Int Property MissionLandTutorialID = 1 Auto Const
  { tutorial ID when landing on the target planet - see SQ_Parent.TutorialMessages }
  GlobalVariable Property RewardXPAmountGlobalActual Auto Const mandatory
  { The actual amount of XP we're going to reward the player with - possibly adjusted by specific mission factors }
  FormList Property flPlanets Auto Const
EndGroup


;-- Functions ---------------------------------------

;Event OnQuestStarted()
Event OnActivate(ObjectReference akActionRef)
  Javas_Debug.WriteLogEvent(ScriptNameString, "IN", "OnActivate(ObjectReference akActionRef)", 1)
  var[] valuesToShow = new var[10]
  valuesToShow[0] = ("sq_parentscript SQ_Parent = " + SQ_Parent as String) as Var
  valuesToShow[1] = ("ReferenceAlias PlanetTarget = " + PlanetTarget as String) as Var
  valuesToShow[2] = ("Float RewardPlanetTraitMult = " + RewardPlanetTraitMult as String) as Var
  valuesToShow[3] = ("Float RewardPlanetAbundanceMult = " + RewardPlanetAbundanceMult as String) as Var
  valuesToShow[4] = ("Int SurveyObjective = " +  SurveyObjective as String) as Var
  valuesToShow[5] = ("Int MissionAcceptTutorialID = " + MissionAcceptTutorialID as String) as Var
  valuesToShow[6] = ("Int MissionLandTutorialID = " + MissionLandTutorialID as String) as Var
  valuesToShow[7] = ("GlobalVariable RewardXPAmountGlobalActual = " + RewardXPAmountGlobalActual as String) as Var
  valuesToShow[8] = ("missionsurveyquestscript SQ_SurveyQuest = " + SQ_SurveyQuest as String) as Var
  Javas_Debug.WriteLogAllVariables(ScriptNameString, "OnQuestStarted", valuesToShow, 1)

  targetPlanet = PlanetTarget.GetRef().GetCurrentPlanet() ; #DEBUG_LINE_NO:37
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Planet targetPlanet", targetPlanet, 1)

  Planet myPlanet = Game.GetPlayer().GetCurrentPlanet()
  Int myPlanetId = myPlanet.GetFormID()
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Int myPlanetId", myPlanetId, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Planet myPlanet", myPlanet, 1)

  ObjectReference oPlanet = Game.GetFormFromFile(0x0005E0B0, "starfield.esm") as ObjectReference
  Planet ppPlanet = Game.GetFormFromFile(0x0005E0B0, "starfield.esm") as Planet
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "ObjectReference oPlanet", oPlanet, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Planet ppPlanet", ppPlanet, 1)

  ObjectReference mm = flPlanets.GetAt(0) as ObjectReference
  Planet pPlanet = flPlanets.GetAt(0) as Planet
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "flPlanets.GetAt(0)", flPlanets.GetAt(0), 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "Planet pPlanet", pPlanet, 1)
  Javas_Debug.WriteLog(ScriptNameString, "OnActivate", "ObjectReference mm", mm, 1)

  SQ_SurveyQuest.SetStage(10)

  Javas_Debug.WriteLogEvent(ScriptNameString, "OUT", "OnActivate(ObjectReference akActionRef)", 1)
EndEvent



