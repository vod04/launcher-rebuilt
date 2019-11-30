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


CutsceneCount = 0
if Launcher.Config.Bool("enablenehl",false) then
    ReplayCount = 1
else
    ReplayCount = Launcher.Config.Int("goalreplays",1)
end
function CutsceneStartedCallback(Val)
	--Launcher.Window.MessageBox("",Val)
end

function CutsceneLoopCallback(Val)
	-- Goalie Hold, 0x11
	-- Icing, 0x15,0x16
	-- Offside - 0x18
	-- Intro - 0x2c
    -- Goal - 0x25, 0x26, 0x27, 0x2A, 0x2B, 0x4D, 0x4E
	-- Own net goal 0x28
	if Val == 0x25 or Val == 0x26 or Val == 0x27 or Val == 0x28 or Val == 0x2A or Val == 0x2B or Val == 0x4E then
		CutsceneCount = CutsceneCount + 1
		if CutsceneCount >= ReplayCount then
			CutsceneCount = 0
			return false
		else
			return true
		end
	end
	return false
end


Launcher.Callback.Register("CutsceneLoop",CutsceneLoopCallback)
Launcher.Callback.Register("CutsceneStarted",CutsceneStartedCallback)