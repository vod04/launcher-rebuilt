-- Options
HeatTime = 600 -- Time in real milliseconds between increasing heat
HeatTimeHeatModifier = 2 --Amount to increase the heat per interval
HeatMax = 100 -- Maximum heat
HeatShot = 20 -- Heat gained per shot
HeatFaceoff = 5 -- Heat gained per faceoff
HeatNetLoose = 10 -- Heat gained from the net being loose
HeatPuckPossessionTime = Launcher.Game.GoalieCoverTime() -- If the goalie can't find a safe pass within this time, cover the puck
HeatDraw = true -- Draw the heat value on the screen
QuickShotTime = 700 -- maximum time (in real milliseconds) between consecutive shots to increase heat
QuickShotAmount = 3 -- Amount of consecutive shots made within the amount of time above
QuickShotHeat = 20 -- Amount to increase the heat after the amount of consecutive shots above
BaseHeatFirst = 0 -- Base heat for first period
BaseHeatSecond = 10 -- Base heat for second period
BaseHeatThird = 15 -- Base heat for third period
BaseHeatOT = 20  -- Base heat for OT
--- Internal
Heat = 0
QuickShotCount = 0
QuickShotLast = 0
---
function IncreaseHeat(Value)
    Heat = math.max(math.min(Heat + Value, HeatMax),0)
end
function ResetHeat()
    local Period
    Period = Launcher.Game.Period()
    if Period == 1 then
        Heat = BaseHeatFirst
    elseif Period == 2 then
        Heat = BaseHeatSecond
    elseif Period == 3 then
        Heat = BaseHeatThird
    else 
        Heat = BaseHeatOT
    end
end
function HeatTimer()
    if not Launcher.Game.Paused() and not Launcher.Game.PlayStopped() then
        IncreaseHeat(HeatTimeHeatModifier)
    end
end
function ZoneChangedCallback()
    ResetHeat()
    QuickShotCount=0
    if Launcher.Game.PuckZone() ~= 0 and Timer == nil then
        Timer = Launcher.Timer.SetInterval(HeatTime,HeatTimer)
    else
        if Timer ~= nil then
            Launcher.Timer.Release(Timer)
            Timer = nil
        end
    end
end
function GoalieCoverCallback()
    QuickShotCount=0
    if Launcher.Game.PuckPossessionTime() >= HeatPuckPossessionTime then 
        return true
    end
    if math.random(0,HeatMax-Heat) == 0 then
        return true
    else
        return false
    end
end
function ShotCallback()
    local Time     
    IncreaseHeat(HeatShot)
    Time = Launcher.System.Time()
    if Time <= QuickShotLast + QuickShotTime then
        QuickShotCount = QuickShotCount + 1
        if QuickShotCount >= QuickShotAmount then
            IncreaseHeat(QuickShotHeat)
        end
    else
        QuickShotCount = 0
    end
    QuickShotLast = Time
end
function PlayStartedCallback()
    if Launcher.Game.PuckZone() ~= 0 then
        IncreaseHeat(HeatFaceoff)
    end
end
function LoadAssets()
    if HeatDraw == true then
        Font = Launcher.Font.Load("Arial",20, 200)
        Launcher.Callback.Register("Render",RenderCallback)
    end
end
function DeviceCreatedCallback()
    Heat = BaseHeatFirst
    QuickShotCount=0
    if Timer ~= nil then
        Launcher.Timer.Release(Timer)
        Timer = nil
    end
    LoadAssets()
end
function ReloadedCallback()
    LoadAssets()
end
function RenderCallback()
    Launcher.Font.DrawText(Font,Heat,10,Launcher.Screen.Height()-Launcher.Font.TextHeight(Font,Heat)-10,0xff000000)
end
function PlayStoppedCallback(Reason)
    if Reason == LauncherPlayStoppedNetLoose then
        IncreaseHeat(HeatNetLoose)
    end
end
Launcher.Callback.Register("GoalieCover",GoalieCoverCallback)
Launcher.Callback.Register("ZoneChanged",ZoneChangedCallback)
Launcher.Callback.Register("ShotHome",ShotCallback)
Launcher.Callback.Register("ShotAway",ShotCallback)
Launcher.Callback.Register("PlayStarted",PlayStartedCallback)
Launcher.Callback.Register("PlayStopped",PlayStoppedCallback)
Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
Launcher.Callback.Register("Reloaded",ReloadedCallback)
