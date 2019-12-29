PenaltyTextLookup = {}
PenaltyTextLookup[0] = "game misconduct"
PenaltyTextLookup[22] = "slashing"
PenaltyTextLookup[23] = "roughing"
PenaltyTextLookup[24] = "cross-checking"
PenaltyTextLookup[25] = "hooking"
PenaltyTextLookup[26] = "tripping"
PenaltyTextLookup[27] = "interference"
PenaltyTextLookup[29] = "elbowing"
PenaltyTextLookup[32] = "holding"
PenaltyTextLookup[34] = "hooking"
PenaltyTextLookup[36] = "tripping"
PenaltyTextLookup[38] = "fighting"
LogFilename = "Game log"
LogNumber = nil
function LogAction(String)
    if File == nil then
        if LogNumber == nil then
            File = io.open(LogFilename .. ".txt", "w")
        else
            File = io.open(LogFilename .. " " .. LogNumber .. ".txt", "w")
        end
    end
    local Time =Launcher.Game.Time()
    local Minutes = math.floor(Time/60)
    if Minutes < 10 then
        Minutes = "0"..Minutes
    end
    local Seconds = Time % 60
    if Seconds < 10 then
        Seconds = "0"..Seconds
    end

    File:write(Minutes .. ":" .. Seconds.." - " .. String, "\n")
    File:flush()
end
function DeviceCreatedCallback()
    if Launcher.Config.Boolean("newgamelog",false) then
        LogNumber = 1
        while Launcher.Filesystem.FileExists(LogFilename .. " ".. LogNumber .. ".txt") do
            LogNumber = LogNumber + 1
        end
    end
    
    
    PeriodOver = false
    LogAction("Game started between " .. Launcher.Game.HomeFullName() .. " and " .. Launcher.Game.AwayFullName() .. " at the " .. Launcher.Game.ArenaName() .. " in "..Launcher.Game.ArenaLocation())
end
function PlayStoppedCallback(Reason)
    local Player, PlayerName, Team, String, AwayGoals, HomeGoals, PlayerName2
    if Reason == LauncherPlayStoppedPeriod then
        LogAction("Period Over")  
    elseif Reason == LauncherPlayStoppedPuckOver then
        LogAction("Play stopped: Puck out of bounds")  
    elseif Reason == LauncherPlayStoppedIcing then
        LogAction("Play stopped: Icing")  
    elseif Reason == LauncherPlayStoppedOffside then
        LogAction("Play stopped: Offside")  
    elseif Reason == LauncherPlayStoppedGoalHome then
        Player = Launcher.Game.LastGoalPlayer()
        Team = Launcher.Game.HomeNameAbbreviation()
        PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
        LogAction(PlayerName .. " scored a goal ("..Team..")")  
    elseif Reason == LauncherPlayStoppedGoalAway then
        Player = Launcher.Game.LastGoalPlayer()
        Team = Launcher.Game.AwayNameAbbreviation()
        PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
        LogAction(PlayerName .. " scored a goal ("..Team..")")
    elseif Reason == LauncherPlayStoppedGoalie then
        Player = Launcher.Game.PlayerWithPuck()
        PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
        if Launcher.Game.TeamWithPuck() == 0 then
            Team = Launcher.Game.HomeNameAbbreviation()
        else
            Team = Launcher.Game.AwayNameAbbreviation()
        end
        LogAction(PlayerName.."(G) stopped the play ("..Team..")")  
    elseif Reason == LauncherPlayStoppedNetLoose then
        LogAction("Play stopped: Net loose")  
    elseif Reason == LauncherPlayStoppedGameOver then
        HomeGoals = Launcher.Stats.HomeGoals()
        AwayGoals = Launcher.Stats.AwayGoals()
        if HomeGoals > AwayGoals then
            String = Launcher.Game.HomeNameAbbreviation() .. " won: " .. HomeGoals .. "-"..AwayGoals
        elseif AwayGoals > HomeGoals then
            String = Launcher.Game.AwayNameAbbreviation() .. " won: " .. AwayGoals .. "-"..HomeGoals
        else
            String = "Tie: "..HomeGoals.."-"..AwayGoals
        end
        LogAction("Game over. " .. String)  
    elseif Reason == LauncherPlayStoppedFight then
        Player = Launcher.Game.HomeFighter()
        PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
        Player = Launcher.Game.AwayFighter()
        PlayerName2 = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
        LogAction("Fight between "..PlayerName.." and "..PlayerName2)  
    elseif Reason == LauncherPlayStoppedTwoLinePass then
        LogAction("Play stopped: Two line pass")  
    end
end
function PlayStartedCallback()
    local PlayerWithPuck = Launcher.Game.PlayerWithPuck(), FirstName, LastName
    if PlayerWithPuck ~= nil then
        local Team
        if Launcher.Game.TeamWithPuck() == 0 then
            Team = Launcher.Game.HomeNameAbbreviation()
        else
            Team = Launcher.Game.AwayNameAbbreviation()
        end
        FirstName = Launcher.Player.FirstName(PlayerWithPuck) 
        LastName = Launcher.Player.LastName(PlayerWithPuck)
        if FirstName ~= nil and LastName ~= nil then
            LogAction("Faceoff won by " .. FirstName.." " .. LastName .. " (" .. Team .. ")")
        end
    end
end
function PenaltyCallback(Index)
    Player = Launcher.Game.PenaltyPlayer(Index)
    Team = Launcher.Game.PenaltyTeam(Index)
    PenaltyID = Launcher.Game.PenaltyID(Index)
    Time = Launcher.Game.PenaltyTime(Index)
    PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
    Time = Launcher.Util.FormatTime(Time)
    if Team == 0 then
        Team = Launcher.Game.HomeNameAbbreviation()
    else
        Team = Launcher.Game.AwayNameAbbreviation()
    end
    if PenaltyTextLookup[PenaltyID] == nil then
        PenaltyString = "unknown ("..PenaltyID..")"
    else
        PenaltyString = PenaltyTextLookup[PenaltyID]
    end
    LogAction("Penalty: "..PlayerName.." for "..PenaltyString.." "..Time.." ("..Team..")")      
end
function PenaltyPendingCallback(Player, Team, PenaltyID, Time)
    PlayerName = Launcher.Player.FirstName(Player).." "..Launcher.Player.LastName(Player)
    Time = Launcher.Util.FormatTime(Time)
    if Team == 0 then
        Team = Launcher.Game.HomeNameAbbreviation()
    else
        Team = Launcher.Game.AwayNameAbbreviation()
    end
    if PenaltyTextLookup[PenaltyID] == nil then
        PenaltyString = "unknown ("..PenaltyID..")"
    else
        PenaltyString = PenaltyTextLookup[PenaltyID]
    end
    LogAction("Penalty pending: "..PlayerName.." for "..PenaltyString.." "..Time.." ("..Team..")")     
end
function PeriodStartedCallback()
    Period = Launcher.Game.Period()
    if Period > 3 then
        LogAction("OT started")    
    else
        LogAction("Period " .. Period .. " started")    
    end
end
function DeviceReleasedCallback()
    if File ~= nil then
        File:close()
    end
    File = nil
end
Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
Launcher.Callback.Register("DeviceReleased",DeviceReleasedCallback)
Launcher.Callback.Register("PlayStarted",PlayStartedCallback)
Launcher.Callback.Register("PlayStopped",PlayStoppedCallback)
Launcher.Callback.Register("Penalty",PenaltyCallback)
Launcher.Callback.Register("PenaltyPending",PenaltyPendingCallback)
Launcher.Callback.Register("PeriodStarted",PeriodStartedCallback)