RumbleShoot = Launcher.Config.Bool("xinputrumbleshoot",true)
RumbleDuration = Launcher.Config.Integer("xinputrumbleduration",250)
RumbleIntensity = Launcher.Config.Integer("xinputrumbleintensity",100)
if RumbleIntensity > 100 then
	RumbleIntensity = 65535
elseif RumbleIntensity < 0 then
	RumbleIntensity = 0
elseif RumbleIntensity > 0 then
	RumbleIntensity = 65535/(100/RumbleIntensity)
end
DisplayBattery = Launcher.Config.Bool("xinputdisplaybattery",true)
ControllerFound = nil
function RenderCallback()
    if Launcher.Game.Paused() then
		local BatteryLevel = Launcher.XInput.BatteryLevel(ControllerFound,BATTERY_DEVTYPE_GAMEPAD)
        if BatteryLevel ~= nil and BatteryLevel > -1 then
            Launcher.Sprite.Clip(BatterySprite,BatteryLevel*32,0,32,42)
			Launcher.Sprite.Draw(BatterySprite,0,0)
        end
    end
end
function Timeout()
    Launcher.XInput.SetVibration(ControllerFound,0,0)
end
function ShotAwayCallback()
    if Launcher.Game.ControllerTeam(1) == 1 then
        Launcher.XInput.SetVibration(ControllerFound,0,RumbleIntensity)
        Launcher.Timer.SetTimeout(RumbleDuration,Timeout)
    end
end
function ShotHomeCallback()
    if Launcher.Game.ControllerTeam(1) == 0 then
        Launcher.XInput.SetVibration(ControllerFound,0,RumbleIntensity)
        Launcher.Timer.SetTimeout(RumbleDuration,Timeout)
    end
end
function LoadAssets()
    BatterySprite = Launcher.Sprite.Load("launcher/media/textures/xinput/Battery.png")
	if BatterySprite ~= nil then
		Launcher.Callback.Register("Render",RenderCallback)
	end
end
function DeviceCreatedCallback()
    LoadAssets()
end
function ReloadedCallback()
    LoadAssets()
end
function DetectControllers()
	local I
	for I=0,3 do
		ControllerState = Launcher.XInput.State(I)
		if ControllerState ~= nil then
			ControllerFound = I
			break
		end
	end
end
DetectControllers()
if ControllerFound ~= nil then
    Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
	Launcher.Callback.Register("Reloaded",ReloadedCallback)
    if RumbleShoot and RumbleIntensity > 0 then
		Launcher.Callback.Register("ShotHome",ShotHomeCallback)
		Launcher.Callback.Register("ShotAway",ShotAwayCallback)
	end

   
end





