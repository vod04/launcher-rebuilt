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


function Replace(Path)
	local Dir, Filename, Name, Tex, Ext, FileList, FileCount, I, FilePath
	FileList = Launcher.Filesystem.FileList(Path,"dds,png")
	if FileList ~= nil then
        FileCount = #FileList
        if FileCount > 0 then
            for I = 1,FileCount do
                FilePath = FileList[I]
                Filename = Launcher.Filesystem.PathFilename(FilePath)
                Name = string.sub(Filename,1,string.len(Filename)-4)
                if string.len(Name) == 4 then
                    Tex = Launcher.Texture.Load(FilePath)
                    if Tex ~= nil then
                        Launcher.Texture.Inject(Tex,Name)
                    end
                end
            end
        end
    end
	
end
function LoadAssets()
    Replace("launcher/media/textures/inject/")
    Replace("launcher/media/textures/inject/"..Launcher.Game.HomeNameAbbreviation().."/")  
end
function DeviceCreatedCallback()
    LoadAssets()
end
function ReloadedCallback()
    LoadAssets()
end

Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
Launcher.Callback.Register("Reloaded",ReloadedCallback)