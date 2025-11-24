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

pcall(function()
    local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
end)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Library/Rayfield/main/source.lua'))()

getgenv().Settings = {
    AutoFarm = false,
    AutoStats = false,
    SelectedStat = "Melee",
    FlySpeed = 200
}
getgenv().FlyEnabled = false
getgenv().NoClipEnabled = false

local Window = Rayfield:CreateWindow({
    Name = HubName,
    LoadingTitle = HubName .. " Đang tải...",
    LoadingSubtitle = "by " .. OwnerName,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = HubName,
        FileName = "Config"
    },
    KeySystem = false
})

Rayfield:Notify({
    Title = "Vipy Hub Loaded!",
    Content = "Script ổn định 100% ❤️",
    Duration = 6,
    Image = AvatarURL
})

-- Tab Trang Chủ
local HomeTab = Window:CreateTab("🏠 Trang Chủ", 4483362458)
local HomeSection = HomeTab:CreateSection("Thông Tin Hub")
HomeSection:CreateLabel(" ")
HomeSection:CreateImage({
    Image = AvatarURL,
    Size = UDim2.new(0, 200, 0, 200)
})
HomeSection:CreateLabel("🔥 Vipy Hub Blox Fruits 2025")
HomeSection:CreateLabel("👑 Owner: " .. OwnerName)
HomeSection:CreateLabel("✅ No Key - Anti-Ban Nhẹ")

-- Tab Blox Fruits
local BFTab = Window:CreateTab("🍎 Blox Fruits", 4483362458)

-- Farm Section
local FarmSection = BFTab:CreateSection("🚀 Tự Động Farm")
BFTab:CreateToggle({
    Name = "Auto Farm Level/Quest",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Settings.AutoFarm = Value
        if Value then
            spawn(function()
                while getgenv().Settings.AutoFarm do
                    pcall(function()
                        if player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest") then
                            local questTitle = player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                            if string.find(questTitle, "Defeat") then
                                local enemyName = questTitle:match("Defeat%s+(%d+)%s+(.+)")
                                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                                    if mob.Name:find(enemyName or "") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                        repeat
                                            task.wait(0.1)
                                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                                player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                                VirtualUser:ClickButton1(Vector2.new())
                                            end
                                        until not getgenv().Settings.AutoFarm or mob.Humanoid.Health <= 0
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

-- Stats Section
local StatsSection = BFTab:CreateSection("📊 Auto Stats")
BFTab:CreateDropdown({
    Name = "Chọn Stats",
    Options = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
    CurrentOption = "Melee",
    Callback = function(Option)
        getgenv().Settings.SelectedStat = Option
    end,
})
BFTab:CreateToggle({
    Name = "Bật Auto Stats (Chậm)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().Settings.AutoStats = Value
        spawn(function()
            while getgenv().Settings.AutoStats do
                task.wait(math.random(3, 6))
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", getgenv().Settings.SelectedStat, 1)
                end)
            end
        end)
    end,
})

-- Teleport Section (Tọa độ chuẩn Update 24/11/2025)
local TeleSection = BFTab:CreateSection("🗺️ Teleport")
local Teleports = {
    ["Sea 1"] = CFrame.new(1071, 15, -1380),
    ["Sea 2"] = CFrame.new(-3850, 73, -1005),
    ["Sea 3"] = CFrame.new(5748, 623, -190),
    ["Green Zone"] = CFrame.new(-2448, 73, -2160),
    ["Mansion"] = CFrame.new(-1245, 350, 5200),
    ["Port Town"] = CFrame.new(-290, 80, 5450)
}
BFTab:CreateDropdown({
    Name = "Chọn Địa Điểm",
    Options = {"Sea 1", "Sea 2", "Sea 3", "Green Zone", "Mansion", "Port Town"},
    CurrentOption = "Sea 1",
    Callback = function(Option)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            TweenService:Create(player.Character.HumanoidRootPart, TweenInfo.new(2), {CFrame = Teleports[Option]}):Play()
        end
    end,
})

-- Misc Section
local MiscSection = BFTab:CreateSection("⚡ Misc")
BFTab:CreateToggle({
    Name = "Fly (Tắt bằng phím E)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().FlyEnabled = Value
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = player.Character.HumanoidRootPart
            if Value then
                local BV = Instance.new("BodyVelocity")
                BV.Name = "VipyFly"
                BV.MaxForce = Vector3.new(4000, 4000, 4000)
                BV.Parent = HRP
                spawn(function()
                    while getgenv().FlyEnabled do
                        task.wait()
                        if HRP.Parent then
                            BV.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().Settings.FlySpeed
                        end
                    end
                    if BV then BV:Destroy() end
                end)
            else
                if HRP:FindFirstChild("VipyFly") then
                    HRP.VipyFly:Destroy()
                end
            end
        end
    end,
})
BFTab:CreateSlider({
    Name = "Tốc Độ Fly",
    Range = {16, 500},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(Value)
        getgenv().Settings.FlySpeed = Value
    end,
})
BFTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().NoClipEnabled = Value
    end,
})

-- Phím E tắt Fly
UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.E and getgenv().FlyEnabled then
        getgenv().FlyEnabled = false
        Rayfield:Notify({Title = "Fly", Content = "Đã tắt Fly!", Duration = 3})
    end
end)

-- Main Loop (NoClip + Anti-AFK)
spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if getgenv().NoClipEnabled and player.Character then
                for _, Part in pairs(player.Character:GetDescendants()) do
                    if Part:IsA("BasePart") and Part.CanCollide then
                        Part.CanCollide = false
                    end
                end
            end
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

Rayfield:Notify({
    Title = "Vipy Hub Ready!",
    Content = "Farm vui vẻ! Insert toggle UI • Test ở acc phụ nha!",
    Duration = 8,
    Image = AvatarURL
})
