local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LivelyServerList"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
}
toggleGradient.Rotation = 45
toggleGradient.Parent = toggleBtn

local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(0.6, 0, 0.6, 0)
icon.Position = UDim2.new(0.2, 0, 0.2, 0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://3926305904"
icon.ImageRectOffset = Vector2.new(84, 204)
icon.ImageRectSize = Vector2.new(36, 36)
icon.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainContainer"
mainFrame.Size = UDim2.new(0, 280, 0, 450)
mainFrame.Position = UDim2.new(0.5, -140, 1.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(60, 60, 80)
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "SERVERS"
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 12)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local dragging, dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateInput(input)
	end
end)

local isVisible = false
local function toggleUI()
	isVisible = not isVisible
	if isVisible then
		mainFrame.Visible = true
		mainFrame.Position = UDim2.new(0.5, -140, 1.2, 0) 
		TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -140, 0.5, -225)
		}):Play()
	else
		local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -140, 1.5, 0)
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not isVisible then mainFrame.Visible = false end
		end)
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	TweenService:Create(toggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)}):Play()
	wait(0.1)
	TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 60, 0, 60)}):Play()
	toggleUI()
end)

closeBtn.MouseButton1Click:Connect(toggleUI)

local function createServerCard(name, players, ping, jobId)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -10, 0, 90)
	card.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	card.Parent = scroll

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 12)
	cardCorner.Parent = card
	
	local cardStroke = Instance.new("UIStroke")
	cardStroke.Thickness = 1
	cardStroke.Color = Color3.fromRGB(80, 80, 100)
	cardStroke.Parent = card

	local sName = Instance.new("TextLabel")
	sName.Text = name
	sName.Font = Enum.Font.GothamBold
	sName.TextSize = 16
	sName.TextColor3 = Color3.fromRGB(255, 255, 255)
	sName.BackgroundTransparency = 1
	sName.Position = UDim2.new(0, 15, 0, 10)
	sName.Size = UDim2.new(1, -30, 0, 20)
	sName.TextXAlignment = Enum.TextXAlignment.Left
	sName.Parent = card

	local sInfo = Instance.new("TextLabel")
	sInfo.Text = players .. "/20 Players  •  " .. ping .. "ms"
	sInfo.Font = Enum.Font.Gotham
	sInfo.TextSize = 14
	sInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
	sInfo.BackgroundTransparency = 1
	sInfo.Position = UDim2.new(0, 15, 0, 32)
	sInfo.Size = UDim2.new(1, -30, 0, 20)
	sInfo.TextXAlignment = Enum.TextXAlignment.Left
	sInfo.Parent = card
	
	local joinBtn = Instance.new("TextButton")
	joinBtn.Text = "JOIN SERVER"
	joinBtn.Size = UDim2.new(1, -30, 0, 30)
	joinBtn.Position = UDim2.new(0, 15, 1, -40)
	joinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	joinBtn.Font = Enum.Font.GothamBold
	joinBtn.TextSize = 14
	joinBtn.Parent = card
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = joinBtn
	
	joinBtn.MouseButton1Click:Connect(function()
		TweenService:Create(joinBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(0, 200, 100)}):Play()
		
		if jobId ~= "" then
			local success, err = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
			end)
			if not success then 
				joinBtn.Text = "FAILED"
				warn(err)
			else
				joinBtn.Text = "JOINING..."
			end
		else
			joinBtn.Text = "INVALID ID"
			wait(1)
			joinBtn.Text = "JOIN SERVER"
			TweenService:Create(joinBtn, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(0, 200, 100), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
	end)
end

for i = 1, 8 do
	local mockPing = math.random(40, 150)
	local mockPlayers = math.random(1, 19)
	createServerCard("Region: North America " .. i, mockPlayers, mockPing, "")
end

scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)