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


Padding = 3
FontFamily = "Arial"
FontColor = 0xFFCCEEFF
FontSize = 12
FontWeight = 600
BGAlpha = 0xBB000000

-- ***********************
UpdateRate = Launcher.Config.Int("fpsupdate",1)
Padding2 = Padding * 2

FPSText = "FPS"
AVGText = "AVG"
function LoadAssets()
	FrameRate = 0
	Text = ""
	FPSFont = Launcher.Font.Load(FontFamily,FontSize,FontWeight)
	BGSprite = Launcher.Sprite.Load("launcher/media/textures/shared/BlackBG.png")
    FrameTimer = Launcher.System.Time() + 1000	
    Launcher.Callback.Register("Render",RenderCallback)
end
function DeviceCreatedCallback()
    LoadAssets()
end
function ReloadedCallback()
    LoadAssets()
end

function Round(num, idp)
  return string.format("%." .. (idp or 0) .. "f", num)
end
function RenderCallback()
	local X, Y, Time, FrameRate, AvgFramerate

    if UpdateRate == 1 then
        Time = Launcher.System.Time()
        if Time >= FrameTimer then
            FrameRate = Launcher.Renderstate.FPS()
            AvgFrameRate = Launcher.Renderstate.FPSAvg()
            FrameTimer = Time + 1000
            Text = FPSText..": " .. Round(FrameRate,2) .. " "..AVGText..": "..Round(AvgFrameRate,2)
        end
    else
        FrameRate = Launcher.Renderstate.FPS()
        AvgFrameRate = Launcher.Renderstate.FPSAvg()
        Text = FPSText..": " .. Round(FrameRate,2) .. " "..AVGText..": "..Round(AvgFrameRate,2)
    end
    
    

	Width = Launcher.Font.TextWidth(FPSFont,Text)
	Height = Launcher.Font.TextHeight(FPSFont,Text)
	X = Launcher.Screen.Width() - Width
	Y = Launcher.Screen.Height() - Height
	Launcher.Sprite.Resize(BGSprite,Width + Padding2,Height + Padding2)
	Launcher.Sprite.Draw(BGSprite, X - Padding2, Y - Padding2, 0, BGAlpha)
	Launcher.Font.DrawText(FPSFont, Text, X-Padding, Y-Padding, FontColor)
end
function ExitCallback()
    Launcher.Log.Write("AVG FPS: "..Round(Launcher.Renderstate.FPSAvg(),4))
end

if Launcher.Config.Bool("drawfps",false) then
	Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
    Launcher.Callback.Register("Exit",ExitCallback)
    Launcher.Callback.Register("Reloaded",ReloadedCallback)
end


