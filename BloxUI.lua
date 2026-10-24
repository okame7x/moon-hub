--[[
	Moon Hub - Blox Fruits UI
	Clones the game's own SettingsMenu and reuses its rows as elements.
--]]

-- Services.
local playersService = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

local localPlayer = playersService.LocalPlayer

-- The game's button colors: { base, top bevel }.
local COLORS = {
	on = { Color3.fromRGB(50, 185, 65), Color3.fromRGB(76, 214, 90) },
	off = { Color3.fromRGB(255, 79, 79), Color3.fromRGB(255, 125, 125) },
	idle = { Color3.fromRGB(158, 158, 158), Color3.fromRGB(191, 191, 191) },
}

local Library = { windows = {} }
Library.__index = Library

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local function paint(button, colors)
	button.BackgroundColor3 = colors[1]
	local bevel = button:FindFirstChild("Trans")
	if bevel then
		bevel.BackgroundColor3 = colors[2]
	end
end

local function call(callback, ...)
	if type(callback) ~= "function" then
		return
	end
	local ok, result = pcall(callback, ...)
	if not ok then
		warn("[Moon Hub] " .. tostring(result))
	end
end

-- Clone without the game's scripts so nothing of theirs runs inside our copy.
local function cloneClean(instance)
	local copy = instance:Clone()
	for _, descendant in ipairs(copy:GetDescendants()) do
		if descendant:IsA("LuaSourceContainer") then
			descendant:Destroy()
		end
	end
	return copy
end

function Library:CreateWindow(options)
	options = options or {}
	local source = localPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("SettingsMenu")

	local self = setmetatable({}, Window)
	self.flags = {}
	self.order = 0
	self.toggleKey = options.ToggleKey or Enum.KeyCode.RightShift

	self.gui = Instance.new("ScreenGui")
	self.gui.Name = "MoonHub_" .. tostring(math.random(10000, 99999))
	self.gui.ResetOnSpawn = false
	self.gui.IgnoreGuiInset = true
	self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.gui.DisplayOrder = 9999

	self.frame = cloneClean(source)
	self.frame.Name = "MoonHub"
	self.frame.Visible = true
	self.frame.Parent = self.gui
	self.frame.Title.TextLabel.Text = options.Title or "Moon Hub"

	-- Keep one row of each kind as a template, then empty the list.
	self.list = self.frame.Content.ScrollingFrame
	self.templates = {
		header = self.list.AudioHeader,
		toggle = self.list.BackgroundMusic,
		toggleHint = self.list.CameraShake,
		button = self.list.Redeem,
	}
	for _, child in ipairs(self.list:GetChildren()) do
		if child:IsA("GuiObject") then
			child.Parent = nil
		end
	end

	self.frame.Title.Close.MouseButton1Click:Connect(function()
		self:SetVisible(false)
	end)
	self.inputConnection = userInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.toggleKey then
			self:Toggle()
		end
	end)

	if not pcall(function()
		self.gui.Parent = gethui()
	end) then
		self.gui.Parent = game:GetService("CoreGui")
	end

	table.insert(Library.windows, self)
	return self
end

function Library:Destroy()
	for _, window in ipairs(Library.windows) do
		window.inputConnection:Disconnect()
		window.gui:Destroy()
	end
	table.clear(Library.windows)
end

function Window:SetVisible(state)
	self.frame.Visible = state
end

function Window:Toggle()
	self:SetVisible(not self.frame.Visible)
end

function Window:add(row, options, control)
	self.order = self.order + 1
	row.LayoutOrder = self.order
	row.Parent = self.list
	if options and options.Flag then
		self.flags[options.Flag] = control
	end
	return control
end

-- The game's menu has no tabs, so each tab opens with its own header.
function Window:AddTab(config)
	if type(config) == "string" then
		config = { Name = config }
	end
	local tab = setmetatable({ window = self }, Tab)
	tab:AddSection(config.Name or "Tab")
	return tab
end

function Tab:AddSection(text)
	local header = cloneClean(self.window.templates.header)
	header.Name = text
	header.Text = text
	return self.window:add(header, nil, { instance = header })
end

Tab.AddLabel = Tab.AddSection

function Tab:AddToggle(options)
	local hasHint = type(options.Description) == "string" and options.Description ~= ""
	local row = cloneClean(hasHint and self.window.templates.toggleHint or self.window.templates.toggle)
	row.Name = options.Name or "Toggle"
	row.TitleName.Text = options.Name or "Toggle"
	if hasHint then
		row.Hint.Text = options.Description
	end

	local control = { instance = row, value = false }

	function control:Set(state, silent)
		self.value = state == true
		paint(row.FirstButton, self.value and COLORS.on or COLORS.idle)
		paint(row.SecondButton, self.value and COLORS.idle or COLORS.off)
		if not silent then
			call(options.Callback, self.value)
		end
	end

	row.FirstButton.MouseButton1Click:Connect(function()
		control:Set(true)
	end)
	row.SecondButton.MouseButton1Click:Connect(function()
		control:Set(false)
	end)

	control:Set(options.Default == true, true)
	return self.window:add(row, options, control)
end

function Tab:AddButton(options)
	local row = cloneClean(self.window.templates.button)
	row.Name = options.Name or "Button"
	row.TitleName.Text = options.Name or "Button"
	row.RedeemButton.TextLabel.Text = options.ButtonText or "Run"

	row.RedeemButton.MouseButton1Click:Connect(function()
		call(options.Callback)
	end)

	return self.window:add(row, options, { instance = row })
end

return Library
