local player = game.Players.LocalPlayer
local service = game:GetService("Players")

local isResizing = false

function resizeHeadHitbox()
for _, otherPlayer in ipairs(service:GetPlayers()) do
if otherPlayer ~= player then
local character = otherPlayer.Character

if character then
local head = character:FindFirstChild("Head")
if head then
-- Increase head size
head.Size = Vector3.new(5, 5, 5)
-- Decrease transparency
head.Transparency = 0.5
end
end
end
end
end
            
function resetHeadHitbox()
for _, otherPlayer in ipairs(service:GetPlayers()) do
local character = otherPlayer.Character
if character then
local head = character:FindFirstChild("Head")
if head then
-- Reset head size
head.Size = Vector3.new(1, 1, 1)
-- Reset transparency
head.Transparency = 0
end
end
end
end
            
game:GetService("Players").PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(character)
if isResizing then
-- Wait a second before resizing head to ensure character has fully loaded
wait(0.1)
resizeHeadHitbox()
end
end)
end)

local success, GS_UI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Ghost-Gui-888/Ghost-Script/refs/heads/main/UI/GHOST-TEAM-UI.lua"))()---ui链接
end)

if not success then
    warn("UI库加载失败")
    return
end
local GS = GS_UI:new(" 鬼脚本 | 兵工厂")

local GS_UI_Tab = GS:Tab("武器模式", "78699805802392")
local GS_Tab = GS_UI_Tab:section("Ghost-Script",true)

SGV_Tab:Button("无限子弹",function()
while wait(0.5) do
game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 100
game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 100
end
end)

SGV_Tab:Button("快速射击",function()
local replicationstorage = game.ReplicatedStorage
for i, v in pairs(replicationstorage.Weapons:GetDescendants()) do
if v.Name == "Auto" then
v.Value = true
end
if v.Name == "RecoilControl" then
v.Value = 0
end
if v.Name == "MaxSpread" then
v.Value = 0
end
if v.Name == "ReloadTime" then
v.Value = 0
end
if v.Name == "FireRate" then
v.Value = 0.05
end
if v.Name == "Crit" then
v.Value = 20
end
end       
end)

local GS_UI_Tab = GS:Tab("透视模式", "78699805802392")
local GS_Tab = GS_UI_Tab:section("Ghost-Script",true)

SGV_Tab:Button("开启透视",function()
_G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true
--------------------------------------------------------------------
local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"
local Box = Instance.new("BoxHandleAdornment")
Box.Name = "nilBox"
Box.Size = Vector3.new(1, 2, 1)
Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Box.Transparency = 0.7
Box.ZIndex = 0
Box.AlwaysOnTop = false
Box.Visible = false
                    
local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false
                    
local LoadCharacter = function(v)
repeat wait() until v.Character ~= nil
v.Character:WaitForChild("Humanoid")
local vHolder = Holder:FindFirstChild(v.Name)
vHolder:ClearAllChildren()
local b = Box:Clone()
b.Name = v.Name .. "Box"
b.Adornee = v.Character
b.Parent = vHolder
local t = NameTag:Clone()
t.Name = v.Name .. "NameTag"
t.Enabled = true
t.Parent = vHolder
t.Adornee = v.Character:WaitForChild("Head", 5)
if not t.Adornee then
return UnloadCharacter(v)
end
t.Tag.Text = v.Name
b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
local Update
local UpdateNameTag = function()
if not pcall(function()
v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
local maxh = math.floor(v.Character.Humanoid.MaxHealth)
local h = math.floor(v.Character.Humanoid.Health)
end) then

Update:Disconnect()
end
end
UpdateNameTag()
Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
end

local UnloadCharacter = function(v)
local vHolder = Holder:FindFirstChild(v.Name)
if vHolder and (vHolder:FindFirstChild(v.Name .. "Box") ~= nil or vHolder:FindFirstChild(v.Name .. "NameTag") ~= nil) then
vHolder:ClearAllChildren()
end
end

local LoadPlayer = function(v)
local vHolder = Instance.new("Folder", Holder)
vHolder.Name = v.Name
v.CharacterAdded:Connect(function()
pcall(LoadCharacter, v)
end)
v.CharacterRemoving:Connect(function()
pcall(UnloadCharacter, v)
end)
v.Changed:Connect(function(prop)
if prop == "TeamColor" then
UnloadCharacter(v)
wait()
LoadCharacter(v)
end
end)
LoadCharacter(v)
end
                    
local UnloadPlayer = function(v)
UnloadCharacter(v)
local vHolder = Holder:FindFirstChild(v.Name)
if vHolder then
vHolder:Destroy()
end
end

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
spawn(function() pcall(LoadPlayer, v) end)
end
                    

game:GetService("Players").PlayerAdded:Connect(function(v)
pcall(LoadPlayer, v)
end)
                    
game:GetService("Players").PlayerRemoving:Connect(function(v)
pcall(UnloadPlayer, v)
end)
                    
game:GetService("Players").LocalPlayer.NameDisplayDistance = 0
                    
if _G.Reantheajfdfjdgs then
return
end
                    
_G.Reantheajfdfjdgs = ":suifayhgvsdghfsfkajewfrhk321rk213kjrgkhj432rj34f67df"

local players = game:GetService("Players")
local plr = players.LocalPlayer
                    
function esp(target, color)

if target.Character then
if not target.Character:FindFirstChild("GetReal") then
local highlight = Instance.new("Highlight")
highlight.RobloxLocked = true
highlight.Name = "GetReal"
highlight.Adornee = target.Character
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor = color
highlight.Parent = target.Character
else
target.Character.GetReal.FillColor = color
end
end
end

while task.wait() do
for i, v in pairs(players:GetPlayers()) do
if v ~= plr then
esp(v, _G.UseTeamColor and v.TeamColor.Color or ((plr.TeamColor == v.TeamColor) and _G.FriendColor or _G.EnemyColor))
end
end
end
end)

local GS_UI_Tab = GS:Tab("速度模式", "78699805802392")
local GS_Tab = GS_UI_Tab:section("Ghost-Script",true)

SGV_Tab:Toggle("速度 (开/关)","开关",false,function(v)
if v == true then
sudu = game:GetService("RunService").Heartbeat:Connect(function()
if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
end
end
end)
elseif not v and sudu then
sudu:Disconnect()
sudu = nil
end
end)

SGV_Tab:Slider('速度设置', '拉条',  1, 1, 1000,false, function(v)
Speed = v
end)


local GS_UI_Tab = GS:Tab("跳跃模式", "78699805802392")
local GS_Tab = GS_UI_Tab:section("Ghost-Script",true)

GS_Tab:Toggle("无限跳","Toggle",false,function(Value)
Jump = Value
game.UserInputService.JumpRequest:Connect(function()
if Jump then
game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
end
end)
end)


GS_Tab:Textbox("文本框", "", "请输入", function(Value)
    print(Value)
end)
-- 输入文本 Value为输入的内容

GS_Tab:Button("按钮", function()
    print("Button")
end)
-- 一个按钮点击执行里面的内容

GS_Tab:Toggle("开关", "", false, function(Value)
    print(Value)
end)
-- 一个开关false为默认关闭，true默认打开，Value为返回值

GS_Tab:Dropdown("下拉条", '', {"0","1","2","3","4","5","6","7","8","9"}, function(s)
    print(s)
end)
-- 一个下拉条，'{"0","1","2","3","4","5","6","7","8","9"}'为下拉的内容
-- Value为返回值为选择了什么

GS_Tab:Keybind("键位绑定", Enum.KeyCode.LeftControl, function()
    OpenMain()
end)
-- 一个快捷键，用于电脑，作用为打开或关闭UI

GS_Tab:Slider("拉条", "", 1, 1, 100, false, function(Value)
    print(Value)
end)
-- 一个能拉动的拉条，Value为数值

GS_Tab:Label("标签")
-- 一个标签类似于留言