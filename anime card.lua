```lua
--==================================================
-- 1TAP PACK AUTO FARM
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RequestConveyorOffer = Remotes:WaitForChild("RequestConveyorOffer")
local BuyPack = Remotes:WaitForChild("BuyPack")
local SetRecoverPack = Remotes:WaitForChild("SetRecoverPack")

--==================================================
-- REMOVE OLD GUI
--==================================================

local Old = CoreGui:FindFirstChild("1tap_PackFarm")

if Old then
    Old:Destroy()
end

--==================================================
-- SETTINGS
--==================================================

local Running = false
local AntiAFK = true
local Delay = 1.5

local AllowedPacks = {
    ["HSR Pack"] = true,
    ["Eternity Pack"] = true
}

local Logs = {}
local MAX_LOGS = 5

--==================================================
-- COLORS
--==================================================

local BG = Color3.fromRGB(18, 18, 22)
local SIDEBAR = Color3.fromRGB(14, 14, 18)
local PANEL = Color3.fromRGB(24, 24, 29)
local SELECTED = Color3.fromRGB(45, 45, 55)

local TEXT = Color3.fromRGB(235, 235, 240)
local SUBTEXT = Color3.fromRGB(145, 145, 155)
local GREEN = Color3.fromRGB(100, 220, 130)
local RED = Color3.fromRGB(230, 90, 90)

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "1tap_PackFarm"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Gui.Parent = CoreGui

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 600, 0, 380)
Main.Position = UDim2.new(0.5, -300, 0.5, -190)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.ZIndex = 1
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

--==================================================
-- SHOW HUB BUTTON
--==================================================

local ShowHubButton = Instance.new("TextButton")
ShowHubButton.Name = "ShowHubButton"
ShowHubButton.Size = UDim2.new(0, 75, 0, 35)
ShowHubButton.Position = UDim2.new(0, 15, 0.5, -18)
ShowHubButton.BackgroundColor3 = BG
ShowHubButton.BorderSizePixel = 0
ShowHubButton.Text = "1tap"
ShowHubButton.TextColor3 = TEXT
ShowHubButton.TextSize = 13
ShowHubButton.Font = Enum.Font.GothamBold
ShowHubButton.AutoButtonColor = false
ShowHubButton.Visible = false
ShowHubButton.ZIndex = 100
ShowHubButton.Parent = Gui

local ShowHubCorner = Instance.new("UICorner")
ShowHubCorner.CornerRadius = UDim.new(0, 8)
ShowHubCorner.Parent = ShowHubButton

--==================================================
-- HIDE / SHOW
--==================================================

local HideHubButton = Instance.new("TextButton")
HideHubButton.Name = "HideHubButton"
HideHubButton.Size = UDim2.new(0, 32, 0, 32)
HideHubButton.Position = UDim2.new(1, -42, 0, 9)
HideHubButton.BackgroundColor3 = PANEL
HideHubButton.BorderSizePixel = 0
HideHubButton.Text = "—"
HideHubButton.TextColor3 = TEXT
HideHubButton.TextSize = 16
HideHubButton.Font = Enum.Font.GothamBold
HideHubButton.AutoButtonColor = false
HideHubButton.ZIndex = 20
HideHubButton.Parent = Main

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 7)
HideCorner.Parent = HideHubButton

HideHubButton.MouseEnter:Connect(function()
    HideHubButton.BackgroundColor3 = SELECTED
end)

HideHubButton.MouseLeave:Connect(function()
    HideHubButton.BackgroundColor3 = PANEL
end)

HideHubButton.Activated:Connect(function()
    Main.Visible = false
    ShowHubButton.Visible = true
end)

ShowHubButton.MouseEnter:Connect(function()
    ShowHubButton.BackgroundColor3 = SELECTED
end)

ShowHubButton.MouseLeave:Connect(function()
    ShowHubButton.BackgroundColor3 = BG
end)

ShowHubButton.Activated:Connect(function()
    Main.Visible = true
    ShowHubButton.Visible = false
end)

--==================================================
-- SHOW BUTTON DRAG
--==================================================

local ShowDragging = false
local ShowDragStart
local ShowStartPosition

ShowHubButton.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        ShowDragging = true
        ShowDragStart = Input.Position
        ShowStartPosition = ShowHubButton.Position

    end

end)

UserInputService.InputChanged:Connect(function(Input)

    if not ShowDragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - ShowDragStart

        ShowHubButton.Position = UDim2.new(
            ShowStartPosition.X.Scale,
            ShowStartPosition.X.Offset + Delta.X,
            ShowStartPosition.Y.Scale,
            ShowStartPosition.Y.Offset + Delta.Y
        )

    end

end)

UserInputService.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        ShowDragging = false

    end

end)

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 5
TopBar.Parent = Main

local Title = Instance.new("TextLabel
```
