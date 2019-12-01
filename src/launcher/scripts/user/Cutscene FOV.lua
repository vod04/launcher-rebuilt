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


CutsceneFOVMin = Launcher.Config.Number("cutscenefovmin",0)
CutsceneFOVMax = Launcher.Config.Number("cutscenefovmax",0)
OldFOV = Launcher.Camera.FOVModifier()


function CutsceneStartedCallback(CutsceneID) 
    OldFOV = Launcher.Camera.FOVModifier()
	Launcher.Camera.SetFOVModifier(CutsceneFOVMin + (math.random()*(CutsceneFOVMax-CutsceneFOVMin)))
end


function CutsceneStoppedCallback(CutsceneID)
    Launcher.Camera.SetFOVModifier(OldFOV)
end


Launcher.Callback.Register("CutsceneStarted",CutsceneStartedCallback)
Launcher.Callback.Register("CutsceneStopped",CutsceneStoppedCallback)
