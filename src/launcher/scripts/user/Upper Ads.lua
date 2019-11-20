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


Frame = 0
FrameTimer = 0

CurrentTeam = {}
CurrentTeam.TextureName = {}

OldFrames = 0
PreviousFrame = 0

function DefaultGoalHome(Frame)
    local Text, TextWidth, TextHeight, Alpha, F
    Launcher.Screen.SetRenderTarget(1,RenderSprite)
    if Launcher.Screen.BeginScene() then
        Text = "GOAL!"
        F = (Frame * 10) % 200
        if F <= 100 then
            Alpha = F / 100
        else
            Alpha = 1-(F-100) / 100
        end
        TextWidth = Launcher.Font.TextWidth(CurrentTeam.LargeFont,Text)
        TextHeight = Launcher.Font.TextHeight(CurrentTeam.LargeFont,Text)
        Launcher.Sprite.Draw(CurrentTeam.BGSprite3,0, 0 , 0, CurrentTeam.Color)
        Launcher.Font.DrawText(CurrentTeam.LargeFont, Text, CurrentTeam.Width/2-TextWidth/2, CurrentTeam.Height/2-TextHeight/2, RGBA(255,255,255,255*Alpha))
        Launcher.Screen.EndScene()
    end
end
function DefaultGeneric(Frame)
    local X, I, Y, BGAlpha, BGColor1, BGColor2, Color, Cols
    Launcher.Screen.SetRenderTarget(1,RenderSprite)
    if Launcher.Screen.BeginScene() then
        if CurrentTeam.Mode == 0 then -- Large logo drop
  
            
            BGColor1 = RGBA(Red(CurrentTeam.Color),Green(CurrentTeam.Color),Blue(CurrentTeam.Color),255)

            Launcher.Sprite.Draw(CurrentTeam.BGSprite1,0,0,0,BGColor1)

            Color = RGBA(255,255,255,100)
            Cols = CurrentTeam.Width/64
            for I = 0, Cols do
                X = (I * 64) + (Frame * 2) % CurrentTeam.Width
                Y = (Frame * 2) % CurrentTeam.Height
                Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X,Y, 0, Color)
                if X + 64  > CurrentTeam.Width then
                    Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X-CurrentTeam.Width,Y, 0, Color)
                    if Y > 0 then
                        Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X-CurrentTeam.Width,Y-CurrentTeam.Height, 0, Color)
                    end
                elseif Y + 64 >= CurrentTeam.Height then
                    Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X,Y-CurrentTeam.Height, 0, Color)
                end
                

            end
            Y = (Frame*8) % 256
            if Y > 0 then
                Launcher.Sprite.Draw(CurrentTeam.LogoSprite256,0,Y-256,0,RGBA(255,255,255,200))
            end
            Launcher.Sprite.Draw(CurrentTeam.LogoSprite256,0,Y,0,RGBA(255,255,255,200))
        elseif CurrentTeam.Mode == 1 then -- Right scrolling 64x64 logo
            Cols = CurrentTeam.Width/64
            Launcher.Sprite.Draw(CurrentTeam.BGSprite3,0, 0 , 0, CurrentTeam.Color)
            for I = 0, Cols do
                X = (I * 64) + (Frame * 6) % CurrentTeam.Width  
                Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X, 0 , 0, RGBA(255,255,255,255))
                if X + 64  > CurrentTeam.Width then
                    Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X-CurrentTeam.Width,0, 0, RGBA(255,255,255,255))
                end
            end
        elseif CurrentTeam.Mode == 2 then  -- Left scrolling 64x64 logo
            Cols = CurrentTeam.Width/64
            Launcher.Sprite.Draw(CurrentTeam.BGSprite3,0, 0 , 0, CurrentTeam.Color)
            for I = 0, Cols do
                X = (I * 64) - (Frame * 6) % CurrentTeam.Width
                Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X, 0 , 0, RGBA(255,255,255,255))
                if X < 0 then
                    Launcher.Sprite.Draw(CurrentTeam.LogoSprite64,X+CurrentTeam.Width,0, 0, RGBA(255,255,255,255))
                end
            end
        end
        Launcher.Screen.EndScene()
        CurrentTeam.Mode = math.floor((Frame/CurrentTeam["Generic"].ModeChangeFrequency) % (CurrentTeam["Generic"].Modes))
    end
end
function Update(Frame)
    if CurrentTeam[CurrentEvent].Update ~= nil then
        ThisEvent = CurrentEvent
        CurrentTeam[CurrentEvent].Update(Frame)
    
        Launcher.Screen.SetRenderTarget(0,RenderTexture)
        if Launcher.Screen.BeginScene() then
            Launcher.Sprite.Draw(RenderSprite,0,0)
            Launcher.Sprite.Draw(RenderSprite,0,CurrentTeam.Height)      
            Launcher.Screen.EndScene()
        end

        Launcher.Screen.ResetRenderTarget()
    end
end
function DeviceCreatedCallback()
    local Count,Path, I
	HomeTeam = Launcher.Game.HomeTeamID()
    HomeAbbreviation = Launcher.Game.HomeNameAbbreviation()
   

    Count = #CurrentTeam.TextureName
    for I=1, Count do 
        CurrentTeam.TextureName[I]=nil 
    end

    CurrentTeam.LogoSprite64 = Launcher.Sprite.Load("launcher/media/textures/upper ads/logos/"..HomeAbbreviation.."-64.png",0)
    if CurrentTeam.LogoSprite64 == nil then
        return false
    end

    CurrentTeam.LogoSprite256 = Launcher.Sprite.Load("launcher/media/textures/upper ads/logos/"..HomeAbbreviation.."-256.png",0)
    if CurrentTeam.LogoSprite256 == nil then
        return false
    end
    CurrentTeam.LargeFont = Launcher.Font.Load("Lucida Sans",58,600)
    CurrentTeam.Mode = 0
    CurrentTeam.BGSprite1 = nil
    CurrentTeam.BGSprite2 = nil
    CurrentTeam.BGSprite3 = nil
    
    Path = "launcher/scripts/modules/upper ads/"..HomeAbbreviation..".lua"
    
    if Launcher.Filesystem.FileExists(Path) then
        Launcher.Script.ExecuteFile(Path)
        CurrentTeam.Height2 = CurrentTeam.Height*2        
    else
        return false
    end
    
    if CurrentTeam.BGSprite1 == nil then
        CurrentTeam.BGSprite1 = Launcher.Sprite.Load("launcher/media/textures/upper ads/bg1.png",0)
    end
    if CurrentTeam.BGSprite2 == nil then
        CurrentTeam.BGSprite2 = Launcher.Sprite.Load("launcher/media/textures/upper ads/bg2.png",0)
    end
    if CurrentTeam.BGSprite3 == nil then
        CurrentTeam.BGSprite3 = Launcher.Sprite.Load("launcher/media/textures/upper ads/bg3.png",0)
    end
    
    RenderTexture = Launcher.Texture.Create(CurrentTeam.Width, CurrentTeam.Height2,1)
    RenderSprite = Launcher.Sprite.Create(CurrentTeam.Width, CurrentTeam.Height,1)
    
    --Update(0)
    Frame = 0
    Count = #CurrentTeam.TextureName
    for I = 1, Count do
        Launcher.Texture.Inject(RenderTexture,CurrentTeam.TextureName[I])
    end


    FPSTimer = Launcher.System.Time(2)
    Launcher.Callback.Register("Tick",TickCallback)
    
    
end
function TickCallback()
    local I, Count, Time, Ratio
    if Launcher.Game.AwaySiren() then
        CurrentEvent = "Goal Home"
    else
        CurrentEvent = "Generic"
    end
    if Launcher.Game.InCutscene() then
        if not Launcher.Game.Paused() then
        
        

			Frame = Frame + Launcher.Renderstate.FPSMultiplier(CurrentTeam[CurrentEvent].AnimationFPS)
            
            DisplayFrame = math.floor(Frame)
            if DisplayFrame ~= PreviousFrame then 
            
              
                PreviousFrame = DisplayFrame
                Update(DisplayFrame)
                Count = #CurrentTeam.TextureName
                for I = 1, Count do
                    Launcher.Texture.Inject(RenderTexture,CurrentTeam.TextureName[I])
                end
            end

        end
    elseif Launcher.Game.InReplay() then
        if Launcher.System.Time() >= FrameTimer then
            FrameTimer = Launcher.System.Time() + 1000
            Frames = Launcher.Replay.Frame()
            FrameRate = Frames - OldFrames
            OldFrames = Frames
        end
        Ratio = 30/CurrentTeam[CurrentEvent].AnimationFPS
        DisplayFrame = math.floor(Launcher.Replay.Frame() / Ratio) --% CurrentTeam[CurrentEvent].Frames
        if DisplayFrame ~= PreviousFrame then
            PreviousFrame = DisplayFrame
            Update(DisplayFrame)
            Count = #CurrentTeam.TextureName
            for I = 1, Count do
                Launcher.Texture.Inject(RenderTexture,CurrentTeam.TextureName[I])
            end
        end
    end
end
function DeviceReleasedCallback()
	Launcher.Callback.Remove("Tick")
end

if Launcher.Config.Bool("animatedupperads",true) then
    Launcher.Callback.Register("DeviceCreated",DeviceCreatedCallback)
    Launcher.Callback.Register("DeviceReleased",DeviceReleasedCallback)
end