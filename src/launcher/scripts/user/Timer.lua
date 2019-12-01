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


Launcher.Game.SetTimer(Launcher.Config.Int("timer",0))
Launcher.Game.SetPenaltyTimer(Launcher.Config.Int("penaltytimer",20))
Launcher.Game.SetOTTimer(Launcher.Config.Int("ottimer",20))
Launcher.Game.SetLastMinuteTimer(Launcher.Config.Int("lastmintimer",29))
Launcher.Clock.SetHideDuration(Launcher.Config.Int("clockhidetime",120))
Launcher.Clock.SetDisplayDuration(Launcher.Config.Int("clockdisplaytime",45))
Launcher.Clock.SetDisplayPowerPlaySeconds(Launcher.Config.Int("clockdisplaypowerplay",45))
MinTime = Launcher.Config.Int("minpuckdroptime",60)
MaxTime = Launcher.Config.Int("maxpuckdroptime",60)
if MaxTime > MinTime then
    Time = MinTime + math.random(MaxTime-MinTime)
else
    Time = MinTime
end
if Time > 127 then
    Time = 127
elseif Time < 2 then
    Time = 2
end
Launcher.Game.SetPuckDropTime(Time,60)