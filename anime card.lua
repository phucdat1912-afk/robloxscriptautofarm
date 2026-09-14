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
LogFrame.ScrollBarThickness = 6
LogFrame.ScrollingDirection = Enum.ScrollingDirection.Y
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.Active = true
LogFrame.Parent = Main

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 7)
LogCorner.Parent = LogFrame

--==================================================
-- LOG CONTENT
--==================================================

local LogContent = Instance.new("Frame")
LogContent.Size = UDim2.new(1, -5, 0, 0)
LogContent.Position = UDim2.new(0, 0, 0, 0)
LogContent.BackgroundTransparency = 1
LogContent.Parent = LogFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 1)
LogLayout.Parent = LogContent

--==================================================
-- LOG SYSTEM
--==================================================

local Logs = {}
local LogLabels = {}

-- Chỉ giữ 5 dòng log
local MAX_LOGS = 5

local function UpdateCanvas()

    task.defer(function()

        local height = LogLayout.AbsoluteContentSize.Y + 10

        LogContent.Size = UDim2.new(
            1,
            -5,
            0,
            height
        )

        LogFrame.CanvasSize = UDim2.new(
            0,
            0,
            0,
            height
        )

        -- Tự động kéo xuống log mới nhất
        LogFrame.CanvasPosition = Vector2.new(
            0,
            math.max(
                0,
                height - LogFrame.AbsoluteSize.Y
            )
        )

    end)

end

local function ClearLogs()

    table.clear(Logs)

    for _, label in ipairs(LogLabels) do

        if label and label.Parent then
            label:Destroy()
        end

    end

    table.clear(LogLabels)

    UpdateCanvas()

end

local function AddLog(message)

    local time = os.date("%H:%M:%S")

    local line = string.format(
        "[%s] %s",
        time,
        tostring(message)
    )

    -- Nếu đã đủ 5 dòng thì xóa dòng cũ nhất
    if #Logs >= MAX_LOGS then

        table.remove(Logs, 1)

        local OldLabel = table.remove(LogLabels, 1)

        if OldLabel and OldLabel.Parent then
            OldLabel:Destroy()
        end

    end

    -- Thêm log mới
    table.insert(Logs, line)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(
        1,
        -10,
        0,
        20
    )

    Label.BackgroundTransparency = 1

    Label.Text = line

    Label.TextColor3 = Color3.new(1, 1, 1)

    Label.TextSize = 12

    Label.Font = Enum.Font.Code

    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.TextYAlignment = Enum.TextYAlignment.Center

    Label.TextTruncate = Enum.TextTruncate.AtEnd

    Label.LayoutOrder = #Logs

    Label.Parent = LogContent

    table.insert(LogLabels, Label)

    UpdateCanvas()

end
