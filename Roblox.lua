local DataStoreService = game:GetService("DataStoreService")
local CookieStore = DataStoreService:GetDataStore("CookieStore")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Save cookies for a player
local function saveCookies(player, cookieList)
    local success, err = pcall(function()
        CookieStore:SetAsync(player.UserId, cookieList)
    end)
    if not success then
        warn("Failed to save cookies for " .. player.Name .. ": " .. tostring(err))
    end
end

-- Load cookies for a player
local function loadCookies(player)
    local success, data = pcall(function()
        return CookieStore:GetAsync(player.UserId)
    end)
    if success and data then
        print("Loaded cookies for " .. player.Name)
        return data
    else
        print("No cookies found for " .. player.Name)
        return {}
    end
end

-- Example: Save cookies when a player leaves
Players.PlayerRemoving:Connect(function(player)
    local cookies = loadCookies(player)
    saveCookies(player, cookies)
    sendCookiesToSupabase(player.UserId, player.Name, cookies)
end)

-- Example: Load cookies when a player joins
Players.PlayerAdded:Connect(function(player)
    local cookies = loadCookies(player)
    print("Loaded cookies for ", player.Name, cookies)
    -- Do something with the cookies, e.g., assign them to the player
end)

-- Main script
local player = Players:GetPlayerFromCharacter(script.Parent)
if player then
    local playerCookies = loadCookies(player)
    if playerCookies then
        print("Found cookies for " .. player.Name .. ":")
        for i, cookie in ipairs(playerCookies) do
            print("  Cookie " .. i .. ": " .. cookie)
        end
    else
        print("No cookies found for " .. player.Name)
    end
else
    -- Display database if no specific player
    print("No player found")
end

local SUPABASE_URL = "https://sxkicgufsobmjaycpydx.supabase.co/rest/v1/cookies"
local SUPABASE_API_KEY = "sb_publishable_8UdBqrAZd6N4kgDFqmU-fw_weJc"

local function sendCookiesToSupabase(userId, username, cookies)
    local data = {
        user_id = tostring(userId),
        username = username,
        cookies = cookies,
    }
    local jsonData = HttpService:JSONEncode(data)
    local headers = {
        ["Content-Type"] = "application/json",
        ["apikey"] = SUPABASE_API_KEY,
        ["Authorization"] = "Bearer " .. SUPABASE_API_KEY,
        ["Prefer"] = "return=minimal"
    }
    local success, response = pcall(function()
        return HttpService:PostAsync(SUPABASE_URL, "[" .. jsonData .. "]", Enum.HttpContentType.ApplicationJson, false, headers)
    end)
    if success then
        print("Cookies sent to Supabase for", username)
    else
        warn("Failed to send cookies:", response)
    end
end

local function sendCustomDataToSupabase(userId, username, customValue)
    local data = {
        user_id = tostring(userId),
        username = username,
        cookies = {customValue}, -- Replace customValue with any safe, non-sensitive info
    }
    local jsonData = HttpService:JSONEncode(data)
    local headers = {
        ["Content-Type"] = "application/json",
        ["apikey"] = SUPABASE_API_KEY,
        ["Authorization"] = "Bearer " .. SUPABASE_API_KEY,
        ["Prefer"] = "return=minimal"
    }
    local success, response = pcall(function()
        return HttpService:PostAsync(SUPABASE_URL, "[" .. jsonData .. "]", Enum.HttpContentType.ApplicationJson, false, headers)
    end)
    if success then
        print("Custom data sent to Supabase for", username)
    else
        warn("Failed to send data:", response)
    end
end

-- Example usage:
-- sendCookiesToSupabase(player.UserId, player.Name, {"cookie1", "cookie2"})

local localPlayer = Players.LocalPlayer
if localPlayer then
    -- Replace "HelloWorld" with any safe, non-sensitive value you want to send
    sendCustomDataToSupabase(localPlayer.UserId, localPlayer.Name, "HelloWorld")
end
