local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Simulated database to store cookies for Roblox accounts
local CookieDatabase = {
    ["Player1"] = {
        cookies = {"rbx_session_123abc", "preference_dark_mode", "analytics_token_xyz"},
        timestamp = os.time()
    },
    ["Player2"] = {
        cookies = {"rbx_session_456def", "preference_light_mode", "analytics_token_uvw"},
        timestamp = os.time()
    }
}

-- Function to get cookies for a specific player
local function getCookies(playerName)
    if CookieDatabase[playerName] then
        return CookieDatabase[playerName].cookies
    else
        return nil
    end
end

-- Function to add cookies to database
local function addCookies(playerName, cookieList)
    CookieDatabase[playerName] = {
        cookies = cookieList,
        timestamp = os.time()
    }
    print("Cookies added for " .. playerName)
end

-- Function to display all cookies
local function displayAllCookies()
    print("=== Roblox Account Cookie Database ===")
    for playerName, data in pairs(CookieDatabase) do
        print("\nPlayer: " .. playerName)
        print("Timestamp: " .. tostring(data.timestamp))
        print("Cookies:")
        for i, cookie in ipairs(data.cookies) do
            print("  [" .. i .. "] " .. cookie)
        end
    end
end

-- Main script
local player = Players:GetPlayerFromCharacter(script.Parent)
if player then
    local playerCookies = getCookies(player.Name)
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
    displayAllCookies()
end

-- Expose functions for external use if needed
_G.CookieDB = {}
_G.CookieDB.getCookies = getCookies
_G.CookieDB.addCookies = addCookies
_G.CookieDB.displayAll = displayAllCookies
