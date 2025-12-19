RegisterNetEvent("vote:start")
AddEventHandler("vote:start", function(options)
    TriggerEvent("chat:addMessage", { args = { "^3VOTE", "Voting started! Use /vote <number> to vote." } })
    for i, opt in ipairs(options) do
        TriggerEvent("chat:addMessage", { args = { "^3VOTE", i .. ". " .. opt } })
    end
end)

RegisterNetEvent("vote:end")
AddEventHandler("vote:end", function(options, counts, winnerIndex)
    TriggerEvent("chat:addMessage", { args = { "^2VOTE", "Voting ended! Results:" } })
    for i, opt in ipairs(options) do
        TriggerEvent("chat:addMessage", { args = { "^2VOTE", opt .. ": " .. counts[i] .. " votes" } })
    end
    TriggerEvent("chat:addMessage", { args = { "^2VOTE", "Winner: " .. options[winnerIndex] } })
end)

RegisterCommand("vote", function(_, args)
    local choice = tonumber(args[1])
    if not choice then
        TriggerEvent("chat:addMessage", { args = { "^1SYSTEM", "Usage: /vote <number>" } })
        return
    end
    TriggerServerEvent("vote:cast", choice)
end)
