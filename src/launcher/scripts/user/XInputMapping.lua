Mode = Launcher.Config.Integer("xinputmode",1)
TriggerThreshold = Launcher.Config.Integer("xinputtriggerthreshold",200)

ControllerFound = nil

function GetDeviceState()
	local State = Launcher.XInput.State(ControllerFound)
	if State ~= nil then
		if Mode == 1 then
			local Address = 0x7D6CE4
			
			if State.LeftTrigger >= TriggerThreshold then
				Launcher.Mem.WriteByte(Address + 6,0x80)
			else
				Launcher.Mem.WriteByte(Address + 6,0)
			end

			if State.RightTrigger >= TriggerThreshold then
				Launcher.Mem.WriteByte(Address + 7,0x80)
			else
				Launcher.Mem.WriteByte(Address + 7,0)
			end
			
			Launcher.Mem.WriteShort(0x7D6998,State.ThumbRX)
			Launcher.Mem.WriteShort(0x7D69A4,State.ThumbRY)
			
			
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_A) ~= 0 then -- A
				Launcher.Mem.WriteByte(Address + 1,0x80)
			else
				Launcher.Mem.WriteByte(Address + 1,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_B) ~= 0 then -- B
				Launcher.Mem.WriteByte(Address + 2,0x80)
			else
				Launcher.Mem.WriteByte(Address + 2,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_X) ~= 0 then --X
				Launcher.Mem.WriteByte(Address + 0,0x80)
			else
				Launcher.Mem.WriteByte(Address + 0,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_Y) ~= 0 then --Y
				Launcher.Mem.WriteByte(Address + 3,0x80)
			else
				Launcher.Mem.WriteByte(Address + 3,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_START) ~= 0 then --Start
				Launcher.Mem.WriteByte(Address + 9,0x80)
			else
				Launcher.Mem.WriteByte(Address + 9,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_BACK) ~= 0 then --Back
				Launcher.Mem.WriteByte(Address + 8,0x80)
			else
				Launcher.Mem.WriteByte(Address + 8,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_LEFT_SHOULDER) ~= 0 then --Left Shoulder
				Launcher.Mem.WriteByte(Address + 4,0x80)
			else
				Launcher.Mem.WriteByte(Address + 4,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_RIGHT_SHOULDER) ~= 0 then --Right Shoulder
				Launcher.Mem.WriteByte(Address + 5,0x80)
			else
				Launcher.Mem.WriteByte(Address + 5,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_LEFT_THUMB) ~= 0 then --Left Thumb
				Launcher.Mem.WriteByte(Address + 10,0x80)
			else
				Launcher.Mem.WriteByte(Address + 10,0)
			end
			if bit32.band(State.Buttons, XINPUT_GAMEPAD_RIGHT_THUMB)~=0 then --Right Thumb
				Launcher.Mem.WriteByte(Address + 11,0x80)
			else
				Launcher.Mem.WriteByte(Address + 11,0)
			end			
		end
	end
end
function DetectControllers()
	local I
	for I=0,3 do
		ControllerState = Launcher.XInput.State(I)
		if ControllerState ~= nil then
			ControllerFound = I
			break
		end
	end
end

DetectControllers()

if ControllerFound ~= nil then
   
   
	ASM = [[
		**GetDeviceState
		mov dword [esi],00000000
		ret  
	]]
	ASMPointer = Launcher.Mem.AssembleString(ASM)
	if ASMPointer ~= nil then
		Launcher.Mem.WriteCall(0x40f732,ASMPointer,1)
	end

   
end





