local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local redeemCodeScreenGui = playerGui:WaitForChild("RedeemCodeScreenGui")
local closeButton = redeemCodeScreenGui:FindFirstChild("CloseButton", true)
local submitButton = redeemCodeScreenGui:FindFirstChild("SubmitButton", true)
local inputRedeemCode = redeemCodeScreenGui:FindFirstChild("InputRedeemCode", true)
local resultLabel = redeemCodeScreenGui:FindFirstChild("ResultLabel", true)
local SoundService = game:GetService("SoundService")
local selectionSound = SoundService:WaitForChild("selectionSound")
local clickSound = SoundService:WaitForChild("clickSound")
local redeemCodeRemoteEvent = ReplicatedStorage:WaitForChild("RedeemCodeRemoteEvent")

closeButton.MouseEnter:Connect(function()
	SoundService:PlayLocalSound(selectionSound)
end)

submitButton.MouseEnter:Connect(function()
	SoundService:PlayLocalSound(selectionSound)
end)

inputRedeemCode.MouseEnter:Connect(function()
	SoundService:PlayLocalSound(selectionSound)
end)

closeButton.MouseButton1Click:Connect(function()
	SoundService:PlayLocalSound(clickSound)
	redeemCodeScreenGui.Enabled = false
	resultLabel.Visible = false
end)

submitButton.MouseButton1Click:Connect(function()
	SoundService:PlayLocalSound(clickSound)
	redeemCodeRemoteEvent:FireServer(inputRedeemCode.Text)
end)

redeemCodeRemoteEvent.OnClientEvent:Connect(function(isValid)
	if isValid then
		resultLabel.Text = "Redeem code success!"
		resultLabel.TextColor3 = Color3.fromHex("#00aa00")
	else
		resultLabel.Text = "Failed to redeem code!"
		resultLabel.TextColor3 = Color3.fromHex("#aa0003")
	end
	inputRedeemCode.Text = ""
	resultLabel.Visible = true
end)