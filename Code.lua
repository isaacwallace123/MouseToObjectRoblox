local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")

local Main = script.Parent.Parent.Parent
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

function DrawPath(StartPoint, EndPoint)
	local Line = Instance.new("Frame")

	Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Line.ZIndex = 0
	Line.BorderSizePixel = 0
	Line.AnchorPoint = Vector2.new(0.5, 0.5)
	Line.Parent = Main

	return Line
end

function CreateWhiteSquare(Name)
	local Frame = Instance.new("Frame")

	Frame.BorderSizePixel = 0
	Frame.ZIndex = 1
	Frame.Parent = Main
	Frame.Name = Name
	Frame.AnchorPoint = Vector2.new(0.5, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.Size = UDim2.fromOffset(10,10)

	return Frame
end

local MousePoint = CreateWhiteSquare("MousePoint")
MousePoint.Visible = false

local EndPoint = CreateWhiteSquare("EndPoint")
EndPoint.Rotation = 45
EndPoint.Transparency = 1

local Highlight = Instance.new("Highlight")
Highlight.FillColor = Color3.fromRGB(255, 250, 211)
Highlight.FillTransparency = 0.8
Highlight.OutlineColor = Color3.fromRGB(255, 255, 240)
Highlight.OutlineTransparency = 0.3
Highlight.Enabled = false

local UIStroke = Instance.new("UIStroke",EndPoint)
UIStroke.Color = Color3.fromRGB(255,255,255)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Enabled = false

local UIConer = Instance.new("UICorner", EndPoint)
UIConer.CornerRadius = UDim.new(0.1,0)

local InsideSquare = Instance.new("Frame",EndPoint)
InsideSquare.Size = UDim2.fromScale(0.5,0.5)
InsideSquare.Position = UDim2.fromScale(0.5,0.5)
InsideSquare.AnchorPoint = Vector2.new(0.5,0.5)
InsideSquare.BorderSizePixel = 0
InsideSquare.Transparency = 1
InsideSquare.BackgroundColor3 = Color3.fromRGB(255,255,255)

local Path = DrawPath(MousePoint, EndPoint)

function UpdateOrientation(Part, startX, startY, endX, endY)
	Part.Rotation = math.atan2(endY - startY, endX - startX) * (180 / math.pi)
end

function UpdatePath()
	local startX, startY = MousePoint.Position.X.Offset, MousePoint.Position.Y.Offset + 5
	local endX, endY = EndPoint.Position.X.Offset, EndPoint.Position.Y.Offset + 5

	Path.Size = UDim2.new(0, ((endX - startX) ^ 2 + (endY - startY) ^ 2) ^ 0.5, 0, 2) 
	Path.Position = UDim2.new(0, (startX + endX) / 2, 0, (startY + endY) / 2) 
	UpdateOrientation(Path, startX, startY, endX, endY)
	UpdateOrientation(EndPoint, startX, startY, endX, endY)
end

function ChangeDisplay(Transparency, Item)
	Tween:Create(Path, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = Transparency}):Play()
	Tween:Create(InsideSquare, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = Transparency}):Play()
	
	UIStroke.Enabled = Item and true or false
	Highlight.Parent = Item and Item.Parent or nil
	Highlight.Enabled = Item and true or false
end

return function(Item, InDistance)
	if Item and InDistance then
		local Vector = game.Workspace.CurrentCamera:WorldToScreenPoint(Item.Position)
		local ScreenPoint = UDim2.fromOffset(Vector.X, Vector.Y)
		local MousePosition = UDim2.fromOffset(Mouse.X, Mouse.Y)

		UpdatePath()

		MousePoint.Position = MousePosition + UDim2.fromOffset(0, 35)
		EndPoint.Position = ScreenPoint + UDim2.fromOffset(0, 35)
		
		ChangeDisplay(0, Item)
	else
		ChangeDisplay(1)
	end
end