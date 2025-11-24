-- Vipy Hub Blox Fruits 2025 - Full & Safe
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
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Library/Rayfield/main/source.lua'))()

getgenv().Settings = {AutoFarm=false,AutoStats=false,SelectedStat="Melee",FlySpeed=200}
getgenv().Fly = false
getgenv().NoClip = false

local Window = Rayfield:CreateWindow({Name=HubName,LoadingTitle=HubName.." Đang tải...",LoadingSubtitle="by "..OwnerName,ConfigurationSaving={Enabled=true,FolderName=HubName,FileName="Config"},KeySystem=false})
Rayfield:Notify({Title="Vipy Hub",Content="Loaded thành công ❤️",Duration=6,Image=AvatarURL})

local Home = Window:CreateTab("Trang Chủ",4483362458)
local s = Home:CreateSection("Info")
s:CreateLabel(" "); s:CreateImage({Image=AvatarURL,Size=UDim2.new(0,200,0,200)})
s:CreateLabel("Vipy Hub Blox Fruits 2025"); s:CreateLabel("Owner: "..OwnerName)

local Main = Window:CreateTab("Blox Fruits",4483362458)

-- Auto Farm Level thật
Main:CreateSection("Farm"):CreateToggle({Name="Auto Farm Level",CurrentValue=false,Callback=function(v)
    getgenv().Settings.AutoFarm = v
    spawn(function()
        while getgenv().Settings.AutoFarm do task.wait()
            pcall(function()
                local quest = player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if quest:find("Defeat") then
                    local enemy = quest:match("Defeat (.+)")
                    for _,mob in pairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name:find(enemy) and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health>0 then
                            repeat task.wait()
                                player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
                                VirtualUser:ClickButton1(Vector2.new())
                            until not getgenv().Settings.AutoFarm or mob.Humanoid.Health<=0
                        end
                    end
                end
            end)
        end
    end)
end})

-- Auto Stats chậm
Main:CreateSection("Stats"):CreateDropdown({Name="Chọn Stats",Options={"Melee","Defense","Sword","Gun","Fruit"},CurrentOption="Melee",Callback=function(v) getgenv().Settings.SelectedStat=v end})
Main:CreateSection("Stats"):CreateToggle({Name="Auto Stats",CurrentValue=false,Callback=function(v)
    getgenv().Settings.AutoStats = v
    spawn(function()
        while getgenv().Settings.AutoStats do task.wait(math.random(4,8))
            pcall(function() CommF_:InvokeServer("AddPoint", getgenv().Settings.SelectedStat, 1) end)
        end
    end)
end})

-- Teleport chuẩn
local Tp = {["Sea 1"]=Vector3.new(1071,15,-1380),["Sea 2"]=Vector3.new(-4611,50,-1005),["Sea 3"]=Vector3.new(-5050,315,-2850),["Mansion"]=Vector3.new(-1250,350,5200),["Port Town"]=Vector3.new(-290,80,5450)}
Main:CreateSection("Teleport"):CreateDropdown({Name="Chọn nơi",Options={"Sea 1","Sea 2","Sea 3","Mansion","Port Town"},CurrentOption="Sea 1",Callback=function(v)
    TweenService:Create(player.Character.HumanoidRootPart,TweenInfo.new(2),{CFrame=CFrame.new(Tp[v])}):Play()
end})

-- Fly + phím E tắt
Main:CreateSection("Misc"):CreateToggle({Name="Fly (E = Tắt)",CurrentValue=false,Callback=function(v)
    getgenv().Fly = v
    if v then
        local bv = Instance.new("BodyVelocity",player.Character.HumanoidRootPart)
        bv.Name="VipyFly"; bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        spawn(function()
            while getgenv().Fly do task.wait()
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().Settings.FlySpeed
            end
            bv:Destroy()
        end)
    end
end})
UserInputService.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.E and getgenv().Fly then getgenv().Fly=false end end)

Main:CreateSection("Misc"):CreateSlider({Name="Fly Speed",Range={50,500},Increment=10,CurrentValue=200,Callback=function(v) getgenv().Settings.FlySpeed=v end})
Main:CreateSection("Misc"):CreateToggle({Name="NoClip",CurrentValue=false,Callback=function(v) getgenv().NoClip=v end})

-- Loop NoClip + Anti-AFK
spawn(function()
    while task.wait(1) do pcall(function()
        if getgenv().NoClip then for _,p in player.Character:GetDescendants() do if p:IsA("BasePart") then p.CanCollide=false end end end
        VirtualUser:CaptureController()
    end) end
end)

Rayfield:Notify({Title="Vipy Hub Ready!",Content="Farm thoải mái • Acc phụ nha!",Duration=8,Image=AvatarURL})
