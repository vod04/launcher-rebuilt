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

FormatExt = {}
FormatExt[0] = "bmp"
FormatExt[1] = "jpg"
FormatExt[2] = "png"
FormatExt[3] = "dds"
Launcher.Override.DisableScreenshot()
Format = Launcher.Config.Integer("screenshotformat",0)
DocsPath = Launcher.System.DocsPath()
function TickCallback()
    local Path, Number, Filename
	if Launcher.Input.KeyPressed(VK_SNAPSHOT) then
		Surface = Launcher.Screen.DefaultRenderTargetSurface()
        Number = 0
        while true do
            Pre = ""
            if Number < 10 then
                Pre = "000"
            elseif Number < 100 then
                Pre = "00"
            elseif Number < 1000 then
                Pre = "0"
            end
            Filename = Pre .. Number .. "." .. FormatExt[Format]
            Path = DocsPath.."\\"..Filename
            if not Launcher.Filesystem.FileExists(Path) then
                break
            end
            Number = Number + 1
        end
        if Launcher.Surface.Save(Surface,Path) then
            Launcher.Log.Write("Screenshot saved to "..Filename)
        else
            Launcher.Log.Write("Unable to save screenshot")
        end
	end
	
end
Launcher.Callback.SetPriority(-999)
Launcher.Callback.Register("Tick",TickCallback)