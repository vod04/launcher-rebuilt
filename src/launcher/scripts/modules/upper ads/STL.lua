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

CurrentTeam.TextureName[1]="UAD1"
CurrentTeam.TextureName[2]="UAD3"
CurrentTeam.TextureName[3]="UAD5"
CurrentTeam.TextureName[4]="UAD6"

CurrentTeam.Width = 256
CurrentTeam.Height = 64
CurrentTeam.Color = RGBA(31,71,145,255)
CurrentTeam.ShortName = "BLUES"



CurrentTeam["Generic"] = {}
CurrentTeam["Generic"].AnimationFPS=30
CurrentTeam["Generic"].Modes = 3
CurrentTeam["Generic"].ModeChangeFrequency = 1000 -- Higher is slower   
CurrentTeam["Goal Home"] = {}
CurrentTeam["Goal Home"].AnimationFPS=30
CurrentTeam["Goal Home"].Modes = 1
CurrentTeam["Goal Home"].ModeChangeFrequency = 1000 -- Higher is slower
    

CurrentTeam["Generic"].Update = function (Frame)
    DefaultGeneric(Frame)
end
CurrentTeam["Goal Home"].Update = function (Frame)
    DefaultGoalHome(Frame)
end
