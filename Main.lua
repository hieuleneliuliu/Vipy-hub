local HubName = "Vipy Hub"
local AvatarURL = "https://i.imgur.com/9YxK8jF.png"
local OwnerName = "Vipy"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Library/Rayfield/main/source.lua'))()

getgenv().Config = {
    AutoFarm = false,
    AutoBoss = false,
    AutoMastery = false,
    AutoFruits = false,
    AutoStats = "Melee",
    FlySpeed = 200
}
getgenv().FlyEnabled = false
getgenv().NoClip = false

local Window = Rayfield:CreateWindow({
    Name = HubName,
    LoadingTitle = HubName.." Đang Tải...",
    LoadingSubtitle = "by "..OwnerName,
    ConfigurationSaving = {Enabled = true, FolderName = HubName, FileName = "Config"},
    KeySystem = false
})

Rayfield:Notify({
    Title = "Vipy Hub Loaded!",
    Content = "Chào mừng bạn đến với Vipy Hub ❤️",
    Duration = 6,
    Image = AvatarURL
})

local HomeTab = Window:CreateTab("Trang Chủ", 4483362458)
local HomeSec = HomeTab:CreateSection("Thông Tin")
HomeSec:CreateLabel(" ")
HomeSec:CreateImage({Image = AvatarURL, Size = UDim2.new(0,200,0,200)})
HomeSec:CreateLabel("Vipy Hub Blox Fruits 2025")
HomeSec:CreateLabel("Owner: "..OwnerName)
HomeSec:CreateLabel("Full tính năng - No Key")
HomeSec:CreateLabel("Chơi acc phụ để an toàn!")

local MainTab = Window:CreateTab("Blox Fruits", 4483362458)

local FarmSec = MainTab:CreateSection("Tự Động Farm")
MainTab:CreateToggle({Name="Auto Farm Level/Quest",CurrentValue=false,Callback=function(v) getgenv().Config.AutoFarm=v end})
MainTab:CreateToggle({Name="Auto Farm Boss",CurrentValue=false,Callback=function(v) getgenv().Config.AutoBoss=v end})
MainTab:CreateToggle({Name="Auto Mastery",CurrentValue=false,Callback=function(v) getgenv().Config.AutoMastery=v end})
MainTab:CreateToggle({Name="Auto Collect Fruits",CurrentValue=false,Callback=function(v) getgenv().Config.AutoFruits=v end})

local StatsSec = MainTab:CreateSection("Auto Stats")
MainTab:CreateDropdown({Name="Chọn Stats",Options={"Melee","Defense","Sword","Gun","Fruit"},CurrentOption="Melee",Callback=function(o) getgenv().Config.AutoStats=o end})
MainTab:CreateToggle({Name="Bật Auto Stats",CurrentValue=false,Callback=function(v)
    if v then
        spawn(function()
            while v and task.wait(0.5) do
                pcall(function() CommF_:InvokeServer("AddPoint", getgenv().Config.AutoStats, 1) end)
            end
        end)
    end
end})

local TpSec = MainTab:CreateSection("Teleport")
local TpList = {
    ["Sea 1"]=Vector3.new(1071,15,-1380),["Sea 2"]=Vector3.new(-3850,73,-1005),["Sea 3"]=Vector3.new(5742,623,-190),
    ["Green Zone"]=Vector3.new(-2440,73,-2160),["Fountain City"]=Vector3.new(5127,5,4012),
    ["Mansion"]=Vector3.new(-1250,350,5200),["Port Town"]=Vector3.new(-290,80,5450),["Hydra Island"]=Vector3.new(5742,623,-190)
}
MainTab:CreateDropdown({Name="Chọn Địa Điểm",Options={"Sea 1","Sea 2","Sea 3","Green Zone","Fountain City","Mansion","Port Town","Hydra Island"},CurrentOption="Sea 1",
Callback=function(o)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and TpList[o] then
        TweenService:Create(player.Character.HumanoidRootPart,TweenInfo.new(2),{CFrame=CFrame.new(TpList[o])}):Play()
    end
end})

local MiscSec = MainTab:CreateSection("Misc")
MainTab:CreateToggle({Name="Fly",CurrentValue=false,Callback=function(v) getgenv().FlyEnabled=v end})
MainTab:CreateSlider({Name="Fly Speed",Range={50,500},Increment=10,CurrentValue=200,Callback=function(v) getgenv().Config.FlySpeed=v end})
MainTab:CreateToggle({Name="NoClip",CurrentValue=false,Callback=function(v) getgenv().NoClip=v end})
MainTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Callback=function(v)
    if v then UserInputService.JumpRequest:Connect(function() if v then player.Character.Humanoid:ChangeState("Jumping") end end) end
end})

spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().NoClip and player.Character then
                for _,p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide=false end
                end
            end
            if getgenv().FlyEnabled and player.Character then
                local hrp = player.Character.HumanoidRootPart
                local bv = hrp:FindFirstChild("VipyFly") or Instance.new("BodyVelocity",hrp)
                bv.Name="VipyFly"
                bv.MaxForce=Vector3.new(1e5,1e5,1e5)
                bv.Velocity=(workspace.CurrentCamera.CFrame.LookVector*getgenv().Config.FlySpeed)+Vector3.new(0,20,0)
                if not getgenv().FlyEnabled then bv:Destroy() end
            end
        end)
    end
end)

Rayfield:Notify({
    Title="Vipy Hub Ready!",
    Content="Nhấn Insert để ẩn/hiện • Chúc farm zui nha!",
    Duration=7,
    Image=AvatarURL
})
