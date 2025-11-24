-- Vipy Hub Blox Fruits Main Game 2025 - Fixed All Errors
local HubName = "Vipy Hub"
local AvatarURL = "https://i.imgur.com/9YxK8jF.png"
local OwnerName = "Vipy"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Check Blox Fruits Main Place ID (Sea 1-3)
local BloxFruitsIDs = {2750916689, 4442272183, 7449423635}
if not table.find(BloxFruitsIDs, game.PlaceId) then
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Lỗi", Text="Chỉ chạy ở Blox Fruits chính thức! Place ID: "..game.PlaceId, Duration=10})
    return
end

-- Robust load Remotes + Character
task.wait(3)  -- Đợi game load
local CommF_ = nil
for i = 1, 10 do  -- Timeout 10s
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then CommF_ = remotes:FindFirstChild("CommF_") end
    end)
    if CommF_ then break end
    task.wait(1)
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Library/Rayfield/main/source.lua'))()

getgenv().Settings = {AutoFarm=false, AutoStats=false, SelectedStat="Melee", FlySpeed=200}
getgenv().FlyEnabled = false
getgenv().NoClipEnabled = false

local Window = Rayfield:CreateWindow({
    Name = HubName,
    LoadingTitle = HubName.." Đang tải...",
    LoadingSubtitle = "by "..OwnerName.." | Main Blox Fruits OK",
    ConfigurationSaving = {Enabled=true, FolderName=HubName, FileName="Config"},
    KeySystem = false
})

Rayfield:Notify({Title="Vipy Hub", Content="Loaded OK - Main Game Detected ❤️", Duration=6, Image=AvatarURL})

-- Tab Home
local HomeTab = Window:CreateTab("🏠 Trang Chủ", 4483362458)
local HomeSec = HomeTab:CreateSection("Info")
HomeSec:CreateLabel("🔥 Vipy Hub Blox Fruits Main 2025")
HomeSec:CreateLabel("👑 Owner: "..OwnerName)
HomeSec:CreateLabel("✅ Place ID: "..game.PlaceId.." | CommF_: "..(CommF_ and "OK" or "Không có"))

-- Tab Blox Fruits
local BFTab = Window:CreateTab("🍎 Blox Fruits", 4483362458)

-- Auto Farm (safe)
local FarmSec = BFTab:CreateSection("🚀 Auto Farm Level")
BFTab:CreateToggle({
    Name = "Bật Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Settings.AutoFarm = Value
        spawn(function()
            while getgenv().Settings.AutoFarm do
                task.wait(0.5)
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local quest = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest")
                        if quest and quest.Visible then
                            local title = quest.Container.QuestTitle.Title.Text
                            if string.find(title, "Defeat") then
                                local enemy = string.match(title, "Defeat%s+(%d+)%s+(.+)")
                                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                                    if mob.Name:find(enemy or "") and mob.Humanoid.Health > 0 then
                                        player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
                                        VirtualUser:ClickButton1(Vector2.new())
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

-- Auto Stats
local StatsSec = BFTab:CreateSection("📊 Auto Stats (Chậm Anti-Ban)")
BFTab:CreateDropdown({
    Name = "Chọn Stats",
    Options = {"Melee","Defense","Sword","Gun","Fruit"},
    CurrentOption = "Melee",
    Callback = function(Option) getgenv().Settings.SelectedStat = Option end
})
BFTab:CreateToggle({
    Name = "Bật Auto Stats",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Settings.AutoStats = Value
        spawn(function()
            while getgenv().Settings.AutoStats do
                task.wait(math.random(4,7))
                if CommF_ then
                    pcall(function() CommF_:InvokeServer("AddPoint", getgenv().Settings.SelectedStat, 1) end)
                end
            end
        end)
    end
})

-- Teleport chuẩn Sea 1-3
local TeleSec = BFTab:CreateSection("🗺️ Teleport")
local TPs = {
    ["Sea 1"] = CFrame.new(1071,15,-1380),
    ["Sea 2"] = CFrame.new(-3850,73,-1005),
    ["Sea 3"] = CFrame.new(5748,623,-190),
    ["Green Zone"] = CFrame.new(-2448,73,-2160),
    ["Mansion"] = CFrame.new(-1245,350,5200)
}
BFTab:CreateDropdown({
    Name = "Chọn",
    Options = {"Sea 1","Sea 2","Sea 3","Green Zone","Mansion"},
    CurrentOption = "Sea 1",
    Callback = function(Option)
        if player.Character and player.Character.HumanoidRootPart then
            TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(2), {CFrame=TPs[Option]}):Play()
        end
    end
})

-- Misc
local MiscSec = BFTab:CreateSection("⚡ Misc")
BFTab:CreateToggle({
    Name = "Fly (E Tắt)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().FlyEnabled = Value
        if player.Character then
            local hrp = player.Character.HumanoidRootPart
            if Value then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "VipyFly"
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                repeat task.wait() bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().Settings.FlySpeed until not getgenv().FlyEnabled
                bv:Destroy()
            end
        end
    end
})
BFTab:CreateSlider({Name="Fly Speed", Range={50,500}, Increment=10, CurrentValue=200, Callback=function(Value) getgenv().Settings.FlySpeed=Value end})
BFTab:CreateToggle({Name="NoClip", CurrentValue=false, Callback=function(Value) getgenv().NoClipEnabled=Value end})

UserInputService.InputBegan:Connect(function(key) if key.KeyCode==Enum.KeyCode.E and getgenv().FlyEnabled then getgenv().FlyEnabled=false end end)

-- Loop NoClip + AntiAFK
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if getgenv().NoClipEnabled and player.Character then
                for _, part in player.Character:GetDescendants() do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

Rayfield:Notify({Title="Vipy Hub Ready!", Content="0 Lỗi - Farm thoải mái acc phụ! Insert toggle", Duration=10, Image=AvatarURL})
