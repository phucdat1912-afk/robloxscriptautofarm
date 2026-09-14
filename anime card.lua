local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local RequestConveyorOffer = Remotes:WaitForChild("RequestConveyorOffer")
local BuyPack = Remotes:WaitForChild("BuyPack")
local SetRecoverPack = Remotes:WaitForChild("SetRecoverPack")

--==================================================
-- SETTINGS
--==================================================

local Running = false
local Delay = 1.5

local AllowedPacks = {
    ["HSR Pack"] = true,
    ["Eternity Pack"] = true
}

--==================================================
-- UI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "PackAutoFarm"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 380)
Main.Position = UDim2.new(0.5, -160, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

--==================================================
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateDrag(input)
    end
end)

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Pack Auto Farm"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 0, 42)
Status.BackgroundTransparency = 1
Status.Text = "Status: OFF"
Status.TextColor3 = Color3.fromRGB(255, 80, 80)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.Parent = Main

--==================================================
-- START / STOP
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -20, 0, 38)
Toggle.Position = UDim2.new(0, 10, 0, 70)
Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Toggle.Text = "START"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.TextSize = 16
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 7)
ToggleCorner.Parent = Toggle

--==================================================
-- HSR
--==================================================

local HSR = Instance.new("TextButton")
HSR.Size = UDim2.new(0.48, -5, 0, 35)
HSR.Position = UDim2.new(0, 10, 0, 120)
HSR.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
HSR.Text = "HSR: ON"
HSR.TextColor3 = Color3.new(1, 1, 1)
HSR.TextSize = 14
HSR.Font = Enum.Font.GothamBold
HSR.Parent = Main

local HSRCorner = Instance.new("UICorner")
HSRCorner.CornerRadius = UDim.new(0, 7)
HSRCorner.Parent = HSR

--==================================================
-- ETERNITY
--==================================================

local Eternity = Instance.new("TextButton")
Eternity.Size = UDim2.new(0.48, -5, 0, 35)
Eternity.Position = UDim2.new(0.52, 0, 0, 120)
Eternity.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
Eternity.Text = "Eternity: ON"
Eternity.TextColor3 = Color3.new(1, 1, 1)
Eternity.TextSize = 14
Eternity.Font = Enum.Font.GothamBold
Eternity.Parent = Main

local EternityCorner = Instance.new("UICorner")
EternityCorner.CornerRadius = UDim.new(0, 7)
EternityCorner.Parent = Eternity

--==================================================
-- DELAY
--==================================================

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 35)
DelayBox.Position = UDim2.new(0, 10, 0, 165)
DelayBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DelayBox.Text = tostring(Delay)
DelayBox.PlaceholderText = "Delay"
DelayBox.TextColor3 = Color3.new(1, 1, 1)
DelayBox.TextSize = 14
DelayBox.Font = Enum.Font.Gotham
DelayBox.ClearTextOnFocus = false
DelayBox.Parent = Main

local DelayCorner = Instance.new("UICorner")
DelayCorner.CornerRadius = UDim.new(0, 7)
DelayCorner.Parent = DelayBox

DelayBox.FocusLost:Connect(function()
    local value = tonumber(DelayBox.Text)

    if value and value >= 0 then
        Delay = value
    else
        DelayBox.Text = tostring(Delay)
    end
end)

--==================================================
-- LOG FRAME
--==================================================

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1, -20, 0, 20)
LogTitle.Position = UDim2.new(0, 10, 0, 205)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "Roll Log"
LogTitle.TextColor3 = Color3.new(1, 1, 1)
LogTitle.TextSize = 14
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.Parent = Main

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 0, 135)
LogFrame.Position = UDim2.new(0, 10, 0, 228)
LogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 7
LogFrame.ScrollingDirection = Enum.ScrollingDirection.Y
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.Active = true
LogFrame.Parent = Main

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 7)
LogCorner.Parent = LogFrame

local LogText = Instance.new("TextLabel")
LogText.Size = UDim2.new(1, -10, 0, 0)
LogText.Position = UDim2.new(0, 5, 0, 5)
LogText.BackgroundTransparency = 1
LogText.Text = ""
LogText.TextColor3 = Color3.new(1, 1, 1)
LogText.TextSize = 12
LogText.Font = Enum.Font.Code
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.TextWrapped = true
LogText.AutomaticSize = Enum.AutomaticSize.Y
LogText.Parent = LogFrame

--==================================================
-- LOG SYSTEM
--==================================================

local Logs = {}

-- CHỈ GIỮ 5 LOG
local MAX_LOGS = 5

local function RefreshLog()

    LogText.Text = table.concat(Logs, "\n")

    task.defer(function()

        local height = LogText.AbsoluteSize.Y + 10

        LogFrame.CanvasSize = UDim2.new(
            0,
            0,
            0,
            height
        )

        -- Kéo xuống log mới nhất
        LogFrame.CanvasPosition = Vector2.new(
            0,
            math.max(
                0,
                height - LogFrame.AbsoluteSize.Y
            )
        )

    end)

end

local function AddLog(message)

    local time = os.date("%H:%M:%S")

    local line = string.format(
        "[%s] %s",
        time,
        tostring(message)
    )

    --==============================================
    -- ĐỦ 5 LOG -> CLEAR TOÀN BỘ
    --==============================================

    if #Logs >= MAX_LOGS then

        table.clear(Logs)

    end

    -- Thêm log mới
    table.insert(Logs, line)

    RefreshLog()

end

--==================================================
-- PACK TOGGLE
--==================================================

HSR.MouseButton1Click:Connect(function()

    AllowedPacks["HSR Pack"] =
        not AllowedPacks["HSR Pack"]

    if AllowedPacks["HSR Pack"] then

        HSR.Text = "HSR: ON"
        HSR.BackgroundColor3 =
            Color3.fromRGB(50, 150, 80)

    else

        HSR.Text = "HSR: OFF"
        HSR.BackgroundColor3 =
            Color3.fromRGB(150, 50, 50)

    end

end)

Eternity.MouseButton1Click:Connect(function()

    AllowedPacks["Eternity Pack"] =
        not AllowedPacks["Eternity Pack"]

    if AllowedPacks["Eternity Pack"] then

        Eternity.Text = "Eternity: ON"
        Eternity.BackgroundColor3 =
            Color3.fromRGB(50, 150, 80)

    else

        Eternity.Text = "Eternity: OFF"
        Eternity.BackgroundColor3 =
            Color3.fromRGB(150, 50, 50)

    end

end)

--==================================================
-- BUY + ROLL
--==================================================

local function BuyAndRoll()

    local success, result = pcall(function()

        return RequestConveyorOffer:InvokeServer(1)

    end)

    if not success or typeof(result) ~= "table" then

        AddLog("ERROR: Không lấy được offer")

        return

    end

    for _, offer in pairs(result) do

        if typeof(offer) ~= "table" then
            continue
        end

        local offerId = offer.OfferId
        local packName = offer.PackName
        local mutation = offer.Mutation

        print(
            "Offer:",
            packName,
            mutation,
            offerId
        )

        AddLog(
            "Offer: "
            .. tostring(packName)
            .. " | "
            .. tostring(mutation)
        )

        if AllowedPacks[packName] then

            AddLog(
                "Buying: "
                .. tostring(packName)
                .. " | "
                .. tostring(mutation)
            )

            local buySuccess, buyError = pcall(function()

                BuyPack:FireServer(
                    packName,
                    mutation,
                    offerId
                )

            end)

            if not buySuccess then

                warn(
                    "BuyPack lỗi:",
                    buyError
                )

                AddLog("ERROR: BuyPack")

                return

            end

            AddLog(
                "Bought: "
                .. tostring(packName)
            )

            task.wait(0.5)

            local rollSuccess, rollError = pcall(function()

                SetRecoverPack:FireServer(
                    offerId
                )

            end)

            if not rollSuccess then

                warn(
                    "SetRecoverPack lỗi:",
                    rollError
                )

                AddLog("ERROR: SetRecoverPack")

            else

                print(
                    "Đã Roll:",
                    packName,
                    offerId
                )

                AddLog(
                    "ROLLED: "
                    .. tostring(packName)
                    .. " | "
                    .. tostring(mutation)
                )

            end

            return

        end

    end

    AddLog("Skipped: Pack không được chọn")

end

--==================================================
-- LOOP
--==================================================

task.spawn(function()

    while true do

        if Running then

            BuyAndRoll()

            task.wait(Delay)

        else

            task.wait(0.2)

        end

    end

end)

--==================================================
-- START / STOP
--==================================================

Toggle.MouseButton1Click:Connect(function()

    Running = not Running

    if Running then

        Toggle.Text = "STOP"

        Toggle.BackgroundColor3 =
            Color3.fromRGB(150, 50, 50)

        Status.Text = "Status: RUNNING"

        Status.TextColor3 =
            Color3.fromRGB(80, 255, 100)

        AddLog("Auto Farm STARTED")

    else

        Toggle.Text = "START"

        Toggle.BackgroundColor3 =
            Color3.fromRGB(45, 45, 45)

        Status.Text = "Status: OFF"

        Status.TextColor3 =
            Color3.fromRGB(255, 80, 80)

        AddLog("Auto Farm STOPPED")

    end

end)
