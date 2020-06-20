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
function Set(Name, Function, ConfigFunction)
	local Val
	Val = ConfigFunction(Name,-1)
	if Val ~= -1 then
		Function(Val)
	end
end
function LoadingCompleteCallback()
	Set("puckgravity",Launcher.Physics.SetPuckGravity,Launcher.Config.Number)
	Set("puckbouncefriction",Launcher.Physics.SetPuckBounceFriction,Launcher.Config.Number)
	Set("puckboardfriction",Launcher.Physics.SetPuckBoardFriction,Launcher.Config.Number)
	Set("puckboardbouncefriction",Launcher.Physics.SetPuckBoardBounceFriction,Launcher.Config.Number)
	Set("playerbasespeed",Launcher.Physics.SetPlayerBaseSpeed,Launcher.Config.Number)
	Set("playerupperspeed",Launcher.Physics.SetPlayerUpperSpeed,Launcher.Config.Number)
	Set("playerspeedmulti",Launcher.Physics.SetPlayerSpeedMultiplier,Launcher.Config.Number)
	Set("playerspeedboostmulti",Launcher.Physics.SetPlayerSpeedBoostMultiplier,Launcher.Config.Number)
	Set("homeplayerspeedmulti",Launcher.Physics.SetHomePlayerSpeedMultiplier,Launcher.Config.Number)
	Set("awayplayerspeedmulti",Launcher.Physics.SetAwayPlayerSpeedMultiplier,Launcher.Config.Number)
	Set("passbasespeed",Launcher.Physics.SetPassBaseSpeed,Launcher.Config.Number)
	Set("passupperspeed",Launcher.Physics.SetPassUpperSpeed,Launcher.Config.Number)
	Set("goaliepassspeedmulti",Launcher.Physics.SetGoaliePassSpeedMultiplier,Launcher.Config.Number)
	Set("saucerpassspeedmulti",Launcher.Physics.SetSaucerPassSpeedMultiplier,Launcher.Config.Number)
	Set("playerspeedenergymulti",Launcher.Physics.SetPlayerSpeedEnergyMultiplier,Launcher.Config.Number)
	Set("bluelineposition",Launcher.Arena.SetBlueLinePosition,Launcher.Config.Number)
	Set("goallineposition",Launcher.Arena.SetGoalLinePosition,Launcher.Config.Number)
	Set("icewidth",Launcher.Arena.SetIceWidth,Launcher.Config.Number)
	Set("icelength",Launcher.Arena.SetIceLength,Launcher.Config.Number)
    
    Launcher.Graphics.EnablePuckShadow(Launcher.Config.Bool("puckshadow",true))
    Launcher.Graphics.SetPuckShadowSize(Launcher.Config.Number("puckshadowsize",50))

    Launcher.Graphics.EnablePlayerShadows(Launcher.Config.Bool("playershadows",true))
    Launcher.Graphics.EnablePlayerReflections(Launcher.Config.Bool("playerreflections",true))

    Launcher.Graphics.SetPlayerShadowOffset(Launcher.Config.Number("playershadowoffset",0.1))

    Launcher.Graphics.SetPlayerShadowColor(Launcher.Config.Color("playershadowcolor","rgba(0,0,0.3,0.25)"))
    
    
end

Launcher.Callback.Register("LoadingComplete",LoadingCompleteCallback)