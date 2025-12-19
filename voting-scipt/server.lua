local voteOptions = {}
local votes = {}
local votingActive = false

RegisterCommand("startvote", function(source, args)
    if #args < 2 then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "Usage: /startvote <option1> <option2> ..." } })
        return
    end

    if votingActive then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "A vote is already in progress!" } })
        return
    end

    voteOptions = args
    votes = {}
    votingActive = true

    TriggerClientEvent("vote:start", -1, voteOptions)
    print("[VOTE] Voting started with options: " .. table.concat(voteOptions, ", "))
end, false)

RegisterNetEvent("vote:cast")
AddEventHandler("vote:cast", function(optionIndex)
    local src = source
    if not votingActive then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1SYSTEM", "No active vote right now." } })
        return
    end

    if votes[src] then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1SYSTEM", "You have already voted!" } })
        return
    end

    if optionIndex < 1 or optionIndex > #voteOptions then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1SYSTEM", "Invalid option number." } })
        return
    end

    votes[src] = optionIndex
    TriggerClientEvent("chat:addMessage", src, { args = { "^2SYSTEM", "Vote recorded for: " .. voteOptions[optionIndex] } })
end)

RegisterCommand("endvote", function(source)
    if not votingActive then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "No active vote to end." } })
        return
    end

    local counts = {}
    for i = 1, #voteOptions do counts[i] = 0 end
    for _, choice in pairs(votes) do counts[choice] = counts[choice] + 1 end

    local winnerIndex, maxVotes = 1, 0
    for i, count in ipairs(counts) do
        if count > maxVotes then
            winnerIndex, maxVotes = i, count
        end
    end

    TriggerClientEvent("vote:end", -1, voteOptions, counts, winnerIndex)
    votingActive = false
end, true)
