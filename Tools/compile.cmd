@echo off

@REM Get Caprica from https://github.com/Orvid/Caprica currently installed is old manual compile -- v0.3.0 causes a io stream failure

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Tools"

@REM Clear Dist DIR
@echo "Clearing and scafolding the Dist dir"
del /s /q "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist\*.*"
rmdir /s /q "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist"
mkdir "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist"
@REM mkdir "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist\SFSE\Plugins\RealTimeFormPatcher"

@REM Clear Dist-BA2-Main DIR
@echo "Clearing and scafolding the Dist-BA2-Main dir"
del /s /q "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main\*.*"
rmdir /s /q "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main"
mkdir "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main"
mkdir "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main\Scripts\"

@REM Compile and deploy Scripts to Dist-BA2-Main folder
@echo "Compiling all script in Source/Papyrus to Dist-BA2-Main folder"
"D:\Starfield Tools\SKKPapyrus\Caprica.exe" --game starfield --import "D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\perks;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\packages;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\quests;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\scenes;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\terminals;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fragments\topicinfos;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\fx;D:\Steam\steamapps\common\Starfield\Data\scripts\Source\Base\nativeterminal ;D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Source\Papyrus" --output "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main\Scripts" "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Source\Papyrus" -R -q && (
  @echo "Compile all scripts has successfully compiled"
  (call )
) || (
  @echo "Error:  Compile all scripts has failed to compile <======================================="
  exit /b 1
)

@REM Deploy RTFP to Dist folder
@echo "Deploy RTFP to Dist folder"
@REM copy /y "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Source\RTFP\VenworksCoreConfig.txt" "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist\SFSE\Plugins\RealTimeFormPatcher"

@REM ESM is purely binary so need to pull from starfield dir where xedit has to have it 
@echo "Copying the ESM from MO2 into the Dist folder"
copy /y "D:\Modding\MO2\mods\The Planetary Databank Terminal\Javas_PlanetTerminal.esm" "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Source\ESM"
copy /y "D:\Modding\MO2\mods\The Planetary Databank Terminal\Javas_PlanetTerminal.esm" "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist"

@REM Use Spriggit to extract record from ESM
@echo "Running Spriggit to extract record from ESM"
"D:\Starfield Tools\Spriggit\Spriggit.CLI.exe" serialize --InputPath "D:\Modding\MO2\mods\The Planetary Databank Terminal\Javas_PlanetTerminal.esm" --OutputPath "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Source\ESM-Extracted" --GameRelease Starfield --PackageName Spriggit.Yaml

@REM Create and copy the BA2 Main Archive to Dist folder
@echo "Creating the BA2 Main Archive"
"D:\Program Files\xEdit\BSArch64.exe" pack "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main" "Javas_PlanetTerminal - Main.ba2" -sf1 -mt && (
  @echo "Main Archive successfully assembled"
  (call )
) || (
  @echo "ERROR:  Main Archive failed to assemble <======================================="
  exit /b 1
)

@REM Copying the BA2 Archives to the Dist folder
@echo "Copying the BA2 Archives to the Dist folder"
copy /y "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist-BA2-Main\Javas_PlanetTerminal.ba2" "D:\code\Starfield MyMods\starfield-planetary-databank-terminal\Dist"