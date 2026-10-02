-- v1.0.1
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local delayTime = 0.3
local minSlot = 1
local maxSlot = 8

local function getRemoteEvent()
    local GarageConstsModule = ReplicatedStorage:FindFirstChild("Garage", true) and ReplicatedStorage:FindFirstChild("Garage", true):FindFirstChild("GarageConsts")

    if not GarageConstsModule then
        for _, desc in pairs(ReplicatedStorage:GetDescendants()) do
            if desc.Name == "GarageConsts" and desc:IsA("ModuleScript") then
                GarageConstsModule = desc
                break
            end
        end
    end

    if GarageConstsModule then
        local success, GarageConsts = pcall(require, GarageConstsModule)

        if success and type(GarageConsts) == "table" and GarageConsts.SLOT_LOAD_REMOTE_NAME then
            return ReplicatedStorage:FindFirstChild(GarageConsts.SLOT_LOAD_REMOTE_NAME, true)
        end
    end

    return nil
end

task.spawn(function()
    local currentSlot = minSlot

    while true do
        local slotName = tostring(currentSlot)
        local loadRemote = getRemoteEvent()

        if loadRemote then
            pcall(function()
                loadRemote:FireServer(slotName)
            end)
        end

        currentSlot = currentSlot + 1

        if currentSlot > maxSlot then
            currentSlot = minSlot
        end

        task.wait(delayTime)
    end
end)
