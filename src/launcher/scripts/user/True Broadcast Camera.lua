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



CameraRotationMinSpeed = 0.0008 -- Minimum rotation speed
CameraRotationMaxSpeed = 0.010 -- Maximum rotation speed
CameraRotationAccel=0.0001 -- Rotation acceleration
CameraRotationDecay = 0.9999 -- Speed decay when we're at the target
CameraRotationSnapThreshold = 0.2 -- Snap to the angle when the angle difference is higher than this value (in radians)
CameraRotationSpeed = CameraRotationMinSpeed

CameraTiltMinSpeed = 0.0008
CameraTiltMaxSpeed = 0.008
CameraTiltAccel = 0.0001
CameraTiltDecay = 0.9999
CameraTiltSpeed = CameraTiltMinSpeed
CameraTiltSnapThreshold = 0.2



CameraMinZoom = 0.12
CameraMaxZoom = 0.40
CameraZoomSpeed = 0.01
CameraZoom = CameraMaxZoom
CameraZoomTarget =  CameraZoom
CameraZoomTiltMultiplier = 0.85

CameraX = -3100.0
CameraY = 1300.0
CameraZ = 0.0

FPSTarget = 60
CameraAngle = 0.0
CameraAngleTarget = 0.0
CameraTiltTarget=0.453
CameraTilt=0.453
CameraMaxTargetRotation = math.rad(55)+1.5708
CameraMinTargetRotation = math.rad(-55)+1.5708


function InitCamera()
	Launcher.Camera.SetPosition(CameraX,CameraY,CameraZ)
	Launcher.Camera.SetZoom(CameraZoom)
	Launcher.Camera.SetRotation(math.deg(90))
	Launcher.Camera.SetTilt(CameraTilt)
	ZoomTarget = MinZoom


	Launcher.Override.DisableCamera()
	Launcher.Callback.Register("Tick",TickCallback)	
	Launcher.Callback.Register("CutsceneStarted",CutsceneStartedCallback)
	Launcher.Callback.Register("CutsceneStopped",CutsceneStoppedCallback)
	Launcher.Callback.Register("FaceoffStarted",FaceoffStartedCallback)
end
function FreeCamera()
	Launcher.Override.EnableCamera()
	Launcher.Callback.Remove("Tick")
	Launcher.Callback.Remove("CutsceneStarted")
	Launcher.Callback.Remove("CutsceneStopped")
	Launcher.Callback.Remove("FaceoffStarted")
end
function CameraCreatedCallback()
	
	
	if Launcher.Camera.Type() == 5 then
		InitCamera()
	end
end
function OperateCamera(Instant)
	if Instant == true or not Launcher.Game.Paused() then
		local TargetX, TargetY, TargetZ, XDistance, YDistance, ZDistance, Distance, FPSMultiplier
		FPSMultiplier = Launcher.Renderstate.FPSMultiplier(FPSTarget)
		TargetX, TargetY, TargetZ = Launcher.Camera.Target()
		
		
		CameraAngleTarget = math.atan2(TargetX-CameraX,CameraZ-TargetZ)
		
		if CameraAngleTarget > CameraMaxTargetRotation then
			CameraAngleTarget = CameraMaxTargetRotation
		elseif CameraAngleTarget < CameraMinTargetRotation then
			CameraAngleTarget = CameraMinTargetRotation
		end
		
		if CameraAngleTarget > CameraAngle then
			CameraAngle = CameraAngle + CameraRotationSpeed * FPSMultiplier
			if CameraAngle > CameraAngleTarget then
				CameraAngle = CameraAngleTarget
				CameraRotationSpeed = CameraRotationSpeed * (CameraRotationDecay*FPSMultiplier)
			else
				if math.abs(CameraAngle-CameraAngleTarget) < CameraRotationSnapThreshold then
					CameraRotationSpeed = CameraRotationSpeed + (CameraRotationAccel * FPSMultiplier)
				else
					CameraRotationSpeed = CameraRotationMaxSpeed
				end
			end
		elseif CameraAngleTarget < CameraAngle then
			CameraAngle = CameraAngle - CameraRotationSpeed * FPSMultiplier
			if CameraAngle < CameraAngleTarget then
				CameraAngle = CameraAngleTarget
				CameraRotationSpeed = CameraRotationSpeed * (CameraRotationDecay*FPSMultiplier)
			else
				if math.abs(CameraAngle-CameraAngleTarget) < CameraRotationSnapThreshold then
					CameraRotationSpeed = CameraRotationSpeed + (CameraRotationAccel * FPSMultiplier)
				else
					CameraRotationSpeed = CameraRotationMaxSpeed
				end
			end
		else
			CameraRotationSpeed = CameraRotationSpeed * (CameraRotationDecay*FPSMultiplier)
		end
		CameraRotationSpeed = math.max(CameraRotationSpeed,CameraRotationMinSpeed)
		CameraRotationSpeed = math.min(CameraRotationSpeed,CameraRotationMaxSpeed)
		





		XDistance = math.abs(TargetX-CameraX)
		YDistance = math.abs(CameraY-TargetY)
		ZDistance = math.abs(CameraZ-TargetZ)
		
		Distance = math.sqrt(XDistance * YDistance + ZDistance * ZDistance)
		CameraTiltTarget = math.atan2(YDistance, Distance)
		if CameraTiltTarget > CameraTilt then
			CameraTilt = CameraTilt + CameraTiltSpeed * FPSMultiplier
			if CameraTilt > CameraTiltTarget then
				CameraTilt = CameraTiltTarget
				CameraTiltSpeed = CameraTiltSpeed * (CameraTiltDecay*FPSMultiplier)
			else
				if math.abs(CameraTilt-CameraTiltTarget) < CameraTiltSnapThreshold then
					CameraTiltSpeed = CameraTiltSpeed + (CameraTiltAccel * FPSMultiplier)
				else
					CameraTiltSpeed = CameraTiltMaxSpeed
				end
			end
		elseif CameraTiltTarget < CameraTilt then
			CameraTilt = CameraTilt - CameraTiltSpeed * FPSMultiplier
			if CameraTilt < CameraTiltTarget then
				CameraTilt = CameraTiltTarget
				CameraTiltSpeed = CameraTiltSpeed * (CameraTiltDecay*FPSMultiplier)
			else
				if math.abs(CameraTilt-CameraTiltTarget) < CameraTiltSnapThreshold then
					CameraTiltSpeed = CameraTiltSpeed + (CameraTiltAccel * FPSMultiplier)
				else
					CameraTiltSpeed = CameraTiltMaxSpeed
				end
			end
		else
			CameraTiltSpeed = CameraTiltSpeed * (CameraTiltDecay*FPSMultiplier)
		end
		CameraTiltSpeed = math.max(CameraTiltSpeed,CameraTiltMinSpeed)
		CameraTiltSpeed = math.min(CameraTiltSpeed,CameraTiltMaxSpeed)
		
		CameraZoomTarget = CameraTilt*CameraZoomTiltMultiplier

		if CameraZoomTarget > CameraZoom then
			CameraZoom = CameraZoom + CameraZoomSpeed * FPSMultiplier
			if CameraZoom > CameraZoomTarget then
				CameraZoom = CameraZoomTarget
			end
		elseif CameraZoomTarget < CameraAngle then
			CameraZoom = CameraZoom - CameraZoomSpeed * FPSMultiplier
			if CameraZoom < CameraZoomTarget then
				CameraZoom = CameraZoomTarget
			end
		end
		
		
		if Instant == true then
			CameraTilt = CameraTiltTarget
			CameraAngle = CameraAngleTarget
			CameraZoom = CameraZoomTarget
			CameraRotationSpeed = CameraRotationMinSpeed
		end
		Launcher.Camera.SetTilt(CameraTilt)
		Launcher.Camera.SetRotation(CameraAngle)
		Launcher.Camera.SetZoom(CameraZoom)
	end
end
function TickCallback()

	OperateCamera(false)

end
function CutsceneStartedCallback()
	Launcher.Override.EnableCamera()
	
end
function CutsceneStoppedCallback()
	Launcher.Override.DisableCamera()
	Launcher.Camera.SetPosition(CameraX,CameraY,CameraZ)
end
function CameraTypeChangedCallback()
	if Launcher.Camera.Type() == 5 then
		InitCamera()
		OperateCamera(true)
	else
		FreeCamera()
	end
end
function DeviceReleasedCallback()
	FreeCamera()
end
function CameraTimeout()
	OperateCamera(true)	
end
function FaceoffStartedCallback()
	Launcher.Timer.SetTimeout(100,CameraTimeout)
end
Launcher.Callback.Register("CameraCreated",CameraCreatedCallback)
Launcher.Callback.Register("CameraTypeChanged",CameraTypeChangedCallback)
Launcher.Callback.Register("DeviceReleased",DeviceReleasedCallback)
