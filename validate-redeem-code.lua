local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local GAME_NAME = MarketplaceService:GetProductInfo(game.PlaceId)["Name"]
local ITEM_REDEEM_CODE = ServerStorage:FindFirstChild('item-redeem-code', false)
local redeemCodeRemoteEvent = ReplicatedStorage:WaitForChild("RedeemCodeRemoteEvent")

redeemCodeRemoteEvent.OnServerEvent:Connect(function(player, redeemCode)
	if ITEM_REDEEM_CODE then
		local backpack = player:WaitForChild("Backpack")
		local playerGui = player:WaitForChild("PlayerGui")
		local redeemCodeScreenGui = playerGui:WaitForChild("RedeemCodeScreenGui")
		local redeemCodeWindow = redeemCodeScreenGui:WaitForChild("RedeemCodeWindow")
		local body = redeemCodeWindow:WaitForChild("Body")
		local frameInputRedeemCode = body:WaitForChild("FrameInputRedeemCode")
		local inputRedeemCode = frameInputRedeemCode:WaitForChild("InputRedeemCode")
		local requestOption = {
			Url = "http://127.0.0.1:3001/validate-redeem-code",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = HttpService:JSONEncode({[GAME_NAME] = redeemCode})
		}
		local success, message = pcall(function()
			local response = HttpService:RequestAsync(requestOption)
			if response.Success then
				local responseRedeemCode = HttpService:JSONDecode(response.Body)
				if responseRedeemCode.status then
					local item = nil
					local descendants = ITEM_REDEEM_CODE:GetDescendants()
					for index, descendant in pairs(descendants) do
						if descendant:IsA("StringValue") then
							if descendant.Name == "redeem-code" then
								if descendant.Value == responseRedeemCode.payload then
									item = descendant.Parent:Clone()
									item:WaitForChild("redeem-code"):Destroy()
									item.Parent = backpack
								end
							end
						end
					end
					if item then
						redeemCodeRemoteEvent:FireClient(player, true)
					else
						redeemCodeRemoteEvent:FireClient(player, false)
					end
				else
					redeemCodeRemoteEvent:FireClient(player, false)
				end
			end
		end)

		if not success then
			warn("Http Request failed:", message)
			redeemCodeRemoteEvent:FireClient(player, false)
		end
	else
		warn("Please create folder item-redeem-code in ServerStorage.")
		redeemCodeRemoteEvent:FireClient(player, false)
	end
end)