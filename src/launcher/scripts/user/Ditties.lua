--[[
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

--[[

    Events (* = No reverb):

    Interface*
    Loading*
    Intro
    Menu*
    Intermission*
    Goal Home
    Goal Road (Loaded from away team)
    Goal Away (If 'Goal Road' from the away team does not exist)
    Play Stopped
    Puck over (Or Play Stopped if doesn't exist)
    Offside (Or Play Stopped if doesn't exist)
    Icing (Or Play Stopped if doesn't exist)
    Net Loose (Or Play Stopped if doesn't exist)
    Two Line Pass (Or Play Stopped if doesn't exist)
    Penalty Home
    Penalty Away
    Home Win
    Away Win
    Tie
    Fight
    Period Started
    Period Over
--]]

-- Options
MusicPath = "launcher/media/sound/ditties/"
ArenaVolume = 0.4  -- Volume range: 0.0 - 1.0
MenuVolume = 0.4
InterfaceVolume = 0.4
DisableReverb = false
IntroReverb = true
IntermissionReverb = false
MenuReverb = false
LoadingReverb = false
FadeOutTime = Launcher.Config.Integer("dittyfadeouttime",1000)
MenuRepeat = true
MenuMusicInReplay = Launcher.Config.Bool("menumusicinreplay",false)
PreloadDitties = Launcher.Config.Bool("preloadditties",true)

BASS_DX8_I3DL2REVERB_lRoom = -10
BASS_DX8_I3DL2REVERB_lRoomHF = 0
BASS_DX8_I3DL2REVERB_flRoomRolloffFactor = 0.000
BASS_DX8_I3DL2REVERB_flDecayTime = 0.755
BASS_DX8_I3DL2REVERB_flDecayHFRatio = 0.500
BASS_DX8_I3DL2REVERB_lReflections = -2048
BASS_DX8_I3DL2REVERB_flReflectionsDelay = 0.007
BASS_DX8_I3DL2REVERB_lReverb = 92
BASS_DX8_I3DL2REVERB_flReverbDelay = 0.095
BASS_DX8_I3DL2REVERB_flDiffusion = 15.500
BASS_DX8_I3DL2REVERB_flDensity = 35.500
BASS_DX8_I3DL2REVERB_flHFReference = 8192.000
  
  
  --[[

lRoom:               Attenuation of the room effect, in millibels (mB), in the range from -10000 to 0. The default value is -1000 mB.  
lRoomHF:             Attenuation of the room high-frequency effect, in mB, in the range from -10000 to 0. The default value is -100 mB.  
flRoomRolloffFactor: Rolloff factor for the reflected signals, in the range from 0 to 10. The default value is 0.0.  
flDecayTime:         Decay time, in seconds, in the range from 0.1 to 20. The default value is 1.49 seconds.  
flDecayHFRatio:      Ratio of the decay time at high frequencies to the decay time at low frequencies, in the range from 0.1 to 2. The default value is 0.83.  
lReflections:        Attenuation of early reflections relative to lRoom, in mB, in the range from -10000 to 1000. The default value is -2602 mB.  
flReflectionsDelay:  Delay time of the first reflection relative to the direct path, in seconds, in the range from 0 to 0.3. The default value is 0.007 seconds.  
lReverb:             Attenuation of late reverberation relative to lRoom, in mB, in the range from -10000 to 2000. The default value is 200 mB.  
flReverbDelay:       Time limit between the early reflections and the late reverberation relative to the time of the first reflection, in seconds, in the range from 0 to 0.1. The default value is 0.011 seconds.  
flDiffusion:         Echo density in the late reverberation decay, in percent, in the range from 0 to 100. The default value is 100.0 percent.  
flDensity:           Modal density in the late reverberation decay, in percent, in the range from 0 to 100. The default value is 100.0 percent.  
flHFReference:       Reference high frequency, in hertz, in the range from 20 to 20000. The default value is 5000.0 Hz.  

--]]
  
  
--***************



Preloaded = {}

function StopSong(MusicStream)
    if MusicStream ~= nil then
        if Launcher.Sound.Loaded(MusicStream) then
            Launcher.Sound.Release(MusicStream)
        end
    end
end
function PlaySong(Path, Reverb, Volume)
    local RetStream
    if Reverb and not DisableReverb then
        RetStream = Launcher.Sound.Load(Path,false)
		if RetStream ~= nil then
			Launcher.Sound.SetReverb(RetStream,BASS_DX8_I3DL2REVERB_lRoom,BASS_DX8_I3DL2REVERB_lRoomHF,BASS_DX8_I3DL2REVERB_flRoomRolloffFactor,BASS_DX8_I3DL2REVERB_flDecayTime,BASS_DX8_I3DL2REVERB_flDecayHFRatio,BASS_DX8_I3DL2REVERB_lReflections,BASS_DX8_I3DL2REVERB_flReflectionsDelay,BASS_DX8_I3DL2REVERB_lReverb,BASS_DX8_I3DL2REVERB_flReverbDelay,BASS_DX8_I3DL2REVERB_flDiffusion,BASS_DX8_I3DL2REVERB_flDensity,BASS_DX8_I3DL2REVERB_flHFReference)
		end
    else
        RetStream = Launcher.Sound.Load(Path,true)
    end
	if RetStream ~= nil then
		Launcher.Sound.SetVolume(RetStream,Volume)	
		Launcher.Sound.Play(RetStream,true)
	end
    return RetStream
end
function PickSong(Event,Alt) --Alt = Use Away team's ditties
    math.randomseed(os.time())
	local FileList,FileCount, List, Size, Path, Filename, Rand, Abbrev, Line, File

    Abbrev = HomeAbbreviation
    if Alt ~= nil then
        if Alt == 1 then
            Abbrev = AwayAbbreviation
        end
    end
	if Abbrev ~= nil then
		Path = MusicPath..Abbrev.."/".. Event
		if not Launcher.Filesystem.DirectoryExists(Path.."/") and not Launcher.Filesystem.FileExists(Path..".m3u") then
			Path = MusicPath.."ALL/".. Event
		end
	else
		Path = MusicPath.."ALL/".. Event
        Abbrev = "ALL"
	end
    if PreloadDitties then
        if Preloaded[Abbrev] ~= nil then
            if Preloaded[Abbrev][Event] ~= nil and #Preloaded[Abbrev][Event] > 0 then
                Rand = math.random(1,#Preloaded[Abbrev][Event])
                return Preloaded[Abbrev][Event][Rand]
            end
        end
        return nil
    end
    if Launcher.Filesystem.FileExists(Path..".m3u") then
        List = {}
        File = Launcher.File.Load(Path..".m3u")
        if File ~= nil then
            repeat 
                Line = Launcher.File.ReadString(File)
                if Line ~= nil then
                    if string.lower(Launcher.Filesystem.FileExtension(Line)) == "mp3" then
                        table.insert(List,Line)
                    end
                end
            until Line == nil
            Launcher.File.Close(File)
            if #List > 0 then
                Rand = math.random(1,#List)
                return List[Rand] 
            else
                return nil
            end
        else
            return nil
        end
	elseif Launcher.Filesystem.DirectoryExists(Path.."/") then
		FileList = Launcher.Filesystem.FileList(Path.."/","mp3",1)
		List = {}
		if FileList ~= nil then
            FileCount = #FileList
			for I = 1,FileCount do 
				table.insert(List,FileList[I])
			end
			if #List > 0 then
                Rand = math.random(1,#List)
				return List[Rand] 
			else 
				return nil
			end
		else
			return nil
		end
	else
		return nil
	end
end
function PlayInterfaceTimer()
    if InterfaceTimer ~= nil and Launcher.Sound.Loaded(InterfaceStream) then
        if Launcher.Sound.Status(InterfaceStream) == 0 then
            StopSong(InterfaceStream)
            InterfaceTimer = nil            
            PlayInterface()
            return
        end
        InterfaceTimer = Launcher.Timer.SetTimeout(1000,PlayInterfaceTimer)
    end
end
function PlayMenuTimer()
    if MenuTimer ~= nil and Launcher.Sound.Loaded(MenuStream) ~= nil then
        if Launcher.Sound.Status(MenuStream) == 0 then
            StopSong(MenuStream)
            MenuTimer = nil
            MenuStream = nil
            PlayMenu()
            return
        end
        MenuTimer = Launcher.Timer.SetTimeout(1000,PlayMenuTimer)
    end
end
function PlayMenu()
    if not Launcher.Game.Over() then
        local MenuSong, Reverb
        Reverb = false
        StopSong(MenuStream)
        MenuStream = nil
        MenuTimer = nil
        if Launcher.Sound.Loaded(ArenaStream) then
            if Launcher.Sound.Status(ArenaStream) ~= 0 then
                Launcher.Sound.Pause(ArenaStream)
            else
                StopSong(ArenaStream)
                ArenaStream = nil
            end
        end
        if Launcher.Game.Time() == 0 then
            MenuSong = PickSong("Intermission")
            if MenuSong ~= nil and IntermissionReverb then
                Reverb = true
            end
        end
        if MenuSong == nil then
            MenuSong = PickSong("Menu")
            if MenuSong ~= nil and MenuReverb then
                Reverb = true
            end
        end
        if MenuSong ~= nil then
            MenuStream = PlaySong(MenuSong, Reverb, MenuVolume)
            if MenuStream ~= nil and MenuRepeat then
                MenuTimer = Launcher.Timer.SetTimeout(1000,PlayMenuTimer)
            end
        end
    end
end
function PlayInterface()
	local Song = PickSong("Interface")
	if Song ~= nil then
		InterfaceStream = PlaySong(Song, false, InterfaceVolume)
        if InterfaceStream ~= nil then
            InterfaceTimer = Launcher.Timer.SetTimeout(1000,PlayInterfaceTimer)
        end
	end
end
function QuitGameCallback()
	HomeAbbreviation = nil
    MenuTimer = nil

    StopSong(ArenaStream)
    StopSong(MenuStream)
    StopSong(InterfaceStream)
    MenuStream = nil
    ArenaStream = nil
    InterfaceStream = nil
	PlayInterface()
end
function PreloadEvent(Event,Alt)
	local FileList,FileCount, Size, Path, Filename, Abbrev, I, File, Line
   
    Abbrev = HomeAbbreviation
    if Alt ~= nil then
        if Alt == 1 then
            Abbrev = AwayAbbreviation
        end
    end
	if Abbrev ~= nil then
		Path = MusicPath..Abbrev.."/".. Event
		if not Launcher.Filesystem.DirectoryExists(Path.."/") and not Launcher.Filesystem.FileExists(Path..".m3u") then
			Path = MusicPath.."ALL/".. Event
		end
	else
        Abbrev = "ALL"
		Path = MusicPath.."ALL/".. Event
	end
    if Launcher.Filesystem.FileExists(Path..".m3u") then
        File = Launcher.File.Load(Path..".m3u")
        if File ~= nil then
            if Preloaded[Abbrev] == nil then
                Preloaded[Abbrev] = {}
            end
            Preloaded[Abbrev][Event] = {}
            repeat 
                Line = Launcher.File.ReadString(File)
                if Line ~= nil then
                    if string.lower(Launcher.Filesystem.FileExtension(Line)) == "mp3" then
                        table.insert(Preloaded[Abbrev][Event],Line)
                    end
                end
            until Line == nil
            Launcher.File.Close(File)
        end
	elseif Launcher.Filesystem.DirectoryExists(Path.."/") then
        if Preloaded[Abbrev] == nil then
            Preloaded[Abbrev] = {}
        end
        Preloaded[Abbrev][Event] = {}
        FileList = Launcher.Filesystem.FileList(Path.."/","mp3",1)
		if FileList ~= nil then
            FileCount = #FileList
			for I = 1,FileCount do
				table.insert(Preloaded[Abbrev][Event],FileList[I])
			end
		else
			return nil
		end
	else
		return nil
	end
end
function Preload(Event)
    if Event ~= nil then
        PreloadEvent(Event)
        return
    end
    local Count = #Preloaded
    local I
    for I=1, Count do Preloaded[I]=nil end
    PreloadEvent("Menu")
    PreloadEvent("Interface")
    PreloadEvent("Loading")
    PreloadEvent("Intro")
    PreloadEvent("Menu")
    PreloadEvent("Intermission")
    PreloadEvent("Goal Home")
    PreloadEvent("Goal Away")
    PreloadEvent("Goal Road",1)
    PreloadEvent("Play Stopped")
    PreloadEvent("Puck over")
    PreloadEvent("Offside")
    PreloadEvent("Icing")
    PreloadEvent("Net Loose")
    PreloadEvent("Penalty Home")
    PreloadEvent("Penalty Away")
    PreloadEvent("Home Win")
    PreloadEvent("Away Win")
    PreloadEvent("Tie")
    PreloadEvent("Fight")
    PreloadEvent("Period Started")
    PreloadEvent("Period Over")
    PreloadEvent("Two Line Pass")
end
function DeviceCreatedCallback()
    local Vol
    InterfaceTimer = nil
    MenuTimer = nil
	HomeAbbreviation = Launcher.Game.HomeNameAbbreviation()
    AwayAbbreviation = Launcher.Game.AwayNameAbbreviation()
    if PreloadDitties then
        Preload()
    end  
    StopSong(InterfaceStream)
    InterfaceStream = nil
    
    Vol = Launcher.Game.MusicVolume()/100
    if Launcher.Config.Bool("arenamusicslider",true) then
        ArenaVolume = Vol
    end
    if Launcher.Config.Bool("menumusicslider",true) then
        MenuVolume = Vol      
    end
    if Launcher.Config.Bool("interfacemusicslider",true) then
        InterfaceVolume = Vol       
    end
	local Song = PickSong("Loading")
	if Song ~= nil then
        if LoadingReverb then
            ArenaStream = PlaySong(Song, true, ArenaVolume)
        else
            MenuStream = PlaySong(Song, false, MenuVolume)
        end
	end
end
function PausedCallback()
    PlayMenu()
end
function UnpausedCallback()
    MenuTimer = nil
    StopSong(MenuStream)
    MenuStream = nil
    if ArenaStream ~= nil then
        if Launcher.Sound.Loaded(ArenaStream) then
            Launcher.Sound.Play(ArenaStream,false)
        end
    end
end
function FadeOutTimer()
    StopSong(ArenaStream)
    ArenaStream = nil
end
function PlayStartedCallback()
    StopSong(MenuStream)
    StopSong(InterfaceStream)
    MenuStream = nil
    InterfaceStream = nil
    if ArenaStream ~= nil then
        if Launcher.Sound.Loaded(ArenaStream) then
            Launcher.Sound.FadeVolume(ArenaStream,0,FadeOutTime)
            Launcher.Timer.SetTimeout(FadeOutTime,FadeOutTimer)
        end
    end
    
end
function CutsceneStartedCallback(CutsceneID)
    if CutsceneID == 44 then --Intro
        StopSong(InterfaceStream)
        StopSong(MenuStream)
        InterfaceStream = nil
        MenuStream = nil
        Song = PickSong("Intro")
        if Song ~= nil then
            if IntroReverb then
                ArenaStream = PlaySong(Song,true,ArenaVolume)
            else
                MenuStream = PlaySong(Song,false,MenuVolume)
            end
        end       
    end
end
function PlayStoppedCallback(Reason)
	local Song = nil
    local UseReverb = true
    local FileOptions = ""
    local Filename
    StopSong(ArenaStream)
    ArenaStream = nil
	if Reason == LauncherPlayStoppedPeriod then
		Song = PickSong("Period Over")
	elseif Reason == LauncherPlayStoppedGoalHome then
        Song = PickSong("Goal Home")
	elseif Reason == LauncherPlayStoppedGoalAway then
        Song = PickSong("Goal Road",1)
        if Song == nil then
            Song = PickSong("Goal Away")
        end
	elseif Reason == LauncherPlayStoppedPuckOver then
		Song = PickSong("Puck Over")
        if Song == nil then
            Song = PickSong("Play Stopped")
        end
	elseif Reason == LauncherPlayStoppedOffside then
		Song = PickSong("Offside")
        if Song == nil then
            Song = PickSong("Play Stopped")
        end
	elseif Reason == LauncherPlayStoppedIcing then
		Song = PickSong("Icing")
        if Song == nil then
            Song = PickSong("Play Stopped")
        end
    elseif Reason == LauncherPlayStoppedNetLoose then
		Song = PickSong("Net Loose")
        if Song == nil then
            Song = PickSong("Play Stopped")
        end
    elseif Reason == LauncherPlayStoppedTwoLinePass then
		Song = PickSong("Two Line Pass")
        if Song == nil then
            Song = PickSong("Play Stopped")
        end
    elseif Reason == LauncherPlayStoppedPenaltyHome then
		Song = PickSong("Penalty Home")
	elseif Reason == LauncherPlayStoppedPenaltyAway then
		Song = PickSong("Penalty Away")
	elseif Reason == LauncherPlayStoppedHomeWin then
        Song = PickSong("Home Win")
	elseif Reason == LauncherPlayStoppedAwayWin then
        Song = PickSong("Away Win")
	elseif Reason == LauncherPlayStoppedTie then
        Song = PickSong("Tie")
    elseif Reason == LauncherPlayStoppedFight then
        Song = PickSong("Fight")
    else
		Song = PickSong("Play Stopped")
	end
	if Song ~= nil then
        Filename = Launcher.Filesystem.PathFilename(Song)
        FileOptions = string.sub(Filename,1,3)
        if FileOptions == "NR_" then
            UseReverb = false
        end
		ArenaStream = PlaySong(Song,UseReverb,ArenaVolume)
	end
end



function InitSoundCallback()
    if PreloadDitties then
        Preload("Interface")
    end
	PlayInterface()
end
function RematchCallback()
    StopSong(MenuStream)
    StopSong(ArenaStream)
    ArenaStream = nil
    MenuStream = nil
    MenuTimer = nil
end
function PeriodStartedCallback()
    local Song
    StopSong(ArenaStream)
    StopSong(MenuStream)
    ArenaStream = nil
    MenuStream = nil
    Song = PickSong("Period Started")
    if Song ~= nil then
        ArenaStream = PlaySong(Song,true, ArenaVolume)
    end
end
function EnterReplayCallback()
    MenuTimer = nil
    StopSong(MenuStream)
    MenuStream = nil
end
function MusicVolumeChangedCallback()
    local Vol
    Vol = Launcher.Game.MusicVolume()/100
    if Launcher.Config.Bool("arenamusicslider",true) then
        ArenaVolume = Vol
        if ArenaStream ~= nil then
            if Launcher.Sound.Loaded(ArenaStream) then
                Launcher.Sound.SetVolume(ArenaStream,ArenaVolume)
            end
        end
    end
    if Launcher.Config.Bool("menumusicslider",true) then
        MenuVolume = Vol
        if MenuStream ~= nil then
            if Launcher.Sound.Loaded(MenuStream) then
                Launcher.Sound.SetVolume(MenuStream,MenuVolume)
            end
        end        
    end
    if Launcher.Config.Bool("interfacemusicslider",true) then
        InterfaceVolume = Vol
        if InterfaceStream ~= nil then
            if Launcher.Sound.Loaded(InterfaceStream) then
                Launcher.Sound.SetVolume(InterfaceStream,InterfaceVolume)
            end
        end        
    end

end
if Launcher.Config.Bool("enableditties",true) then
    Launcher.Override.DisableHorn()
    Launcher.Override.DisableMusic()

    Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
    Launcher.Callback.Register("PlayStarted",PlayStartedCallback)
    Launcher.Callback.Register("PlayStopped",PlayStoppedCallback)
    Launcher.Callback.Register("Paused",PausedCallback)
    Launcher.Callback.Register("Unpaused",UnpausedCallback)
    Launcher.Callback.Register("QuitGame",QuitGameCallback)
    Launcher.Callback.Register("SoundInit",InitSoundCallback)
    Launcher.Callback.Register("CutsceneStarted",CutsceneStartedCallback)
    Launcher.Callback.Register("Rematch",RematchCallback)
    Launcher.Callback.Register("PeriodStarted",PeriodStartedCallback)
    Launcher.Callback.Register("MusicVolumeChanged",MusicVolumeChangedCallback)
    if MenuMusicInReplay == false then
        Launcher.Callback.Register("EnterReplay",EnterReplayCallback)
    end
end
