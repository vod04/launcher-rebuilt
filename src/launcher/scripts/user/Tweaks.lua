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

function LoadingCompleteCallback()
	Launcher.Physics.SetPuckGravity(Launcher.Config.Number("puckgravity",2.5))
    Launcher.Physics.SetPuckElasticity(Launcher.Config.Number("puckelasticity",0.25))
    Launcher.Physics.SetPlayerBaseSpeed(Launcher.Config.Number("playerbasespeed",40))
    Launcher.Physics.SetPlayerUpperSpeed(Launcher.Config.Number("playerupperspeed",20))
    Launcher.Physics.SetPlayerSpeedMultiplier(Launcher.Config.Number("playerspeedmulti",0.62))
    Launcher.Physics.SetPlayerSpeedBoostMultiplier(Launcher.Config.Number("playerspeedboostmulti",0.66))
    Launcher.Physics.SetHomePlayerSpeedMultiplier(Launcher.Config.Number("homeplayerspeedmulti",1))
    Launcher.Physics.SetAwayPlayerSpeedMultiplier(Launcher.Config.Number("awayplayerspeedmulti",1))
    Launcher.Physics.SetPassBaseSpeed(Launcher.Config.Number("passbasespeed",92))
    Launcher.Physics.SetPassUpperSpeed(Launcher.Config.Number("passupperspeed",75))
    Launcher.Physics.SetGoaliePassSpeedMultiplier(Launcher.Config.Number("goaliepassspeedmulti",0.95))
    Launcher.Physics.SetSaucerPassSpeedMultiplier(Launcher.Config.Number("saucerpassspeedmulti",0.8))
    
    
    Launcher.Physics.SetPlayerSpeedEnergyMultiplier(Launcher.Config.Number("playerspeedenergymulti",0.000244140625))
    
    Launcher.Arena.SetBlueLinePosition(Launcher.Config.Number("bluelineposition",1316.00))
    Launcher.Arena.SetGoalLinePosition(Launcher.Config.Number("goallineposition",4176.00))

    Launcher.Arena.SetIceWidth(Launcher.Config.Number("icewidth",2040.00))
    Launcher.Arena.SetIceLength(Launcher.Config.Number("icelength",4800.00))

    
    Launcher.Graphics.EnablePuckShadow(Launcher.Config.Bool("puckshadow",true))
    Launcher.Graphics.SetPuckShadowSize(Launcher.Config.Number("puckshadowsize",50))

    Launcher.Graphics.EnablePlayerShadows(Launcher.Config.Bool("playershadows",true))
    Launcher.Graphics.EnablePlayerReflections(Launcher.Config.Bool("playerreflections",true))

    Launcher.Graphics.SetPlayerShadowOffset(Launcher.Config.Number("playershadowoffset",0.1))

    Launcher.Graphics.SetPlayerShadowColor(Launcher.Config.Color("playershadowcolor","rgba(0,0,0.3,0.25)"))
    
    
end

Launcher.Callback.Register("LoadingComplete",LoadingCompleteCallback)