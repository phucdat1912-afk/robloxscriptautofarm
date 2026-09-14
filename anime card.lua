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
LogFrame.ScrollBarThickness = 8
LogFrame.ScrollingDirection = Enum.ScrollingDirection.Y
LogFrame.ScrollingEnabled = true
LogFrame.Active = true
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.Parent = Main

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 7)
LogCorner.Parent = LogFrame

--==================================================
-- LOG SYSTEM
--==================================================

local Logs = {}
local MAX_LOGS = 50
local LogLabels = {}

local function ClearLogs()

    table.clear(Logs)

    for _, label in ipairs(LogLabels) do
        if label then
            label:Destroy()
        end
    end

    table.clear(LogLabels)

    LogFrame.CanvasSize = UDim2.new(
        0,
        0,
        0,
        0
    )

    LogFrame.CanvasPosition = Vector2.new(
        0,
        0
    )
end

local function AddLog(message)

    local time = os.date("%H:%M:%S")

    local line = string.format(
        "[%s] %s",
        time,
        tostring(message)
    )

    -- Đủ 50 log thì clear toàn bộ
    if #Logs >= MAX_LOGS then
        ClearLogs()
    end

    table.insert(Logs, line)

    -- Tạo label riêng cho từng dòng
    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(
        1,
        -10,
        0,
        20
    )

    Label.Position = UDim2.new(
        0,
        5,
        0,
        (#LogLabels * 20) + 5
    )

    Label.BackgroundTransparency = 1
    Label.Text = line
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 12
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = LogFrame

    table.insert(LogLabels, Label)

    -- Cập nhật vùng scroll
    local totalHeight = (#LogLabels * 20) + 10

    LogFrame.CanvasSize = UDim2.new(
        0,
        0,
        0,
        totalHeight
    )

    -- Tự động kéo xuống log mới nhất
    task.defer(function()

        LogFrame.CanvasPosition = Vector2.new(
            0,
            math.max(
                0,
                totalHeight - LogFrame.AbsoluteSize.Y
            )
        )

    end)

end
