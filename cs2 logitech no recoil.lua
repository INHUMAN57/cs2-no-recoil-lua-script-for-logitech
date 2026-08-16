-- ============================================================
-- USER SETTINGS
-- ============================================================
local ingamesensitivity = 3.4
local dpi = 400

local selectedOperator = "off"

local operatorStats = {
    off = {
        stages = { { 0, 0 } }
    },

    ak47 = {
        stages = {
            {0, 5}, {0, 5}, {0, 5}, {0, 10}, {0, 10},
            {1.7, 8}, {1.7, 8}, {8, 8}, {0, 0}, {-4, 4},
            {-13, 0}, {-6, 3}, {0, 4}, {0, 0}, {-3, 1},
            {-7, 1}, {-3, 0}, {-7, 0}, {25, 0}, {3, 0},
            {5, 0}, {5, 0}, {5, 0}, {5, 0}, {5, 0},
            {5, 0}, {-7, 0}, {-7, 0}, {-7, 0}, {7, 0},
            {7, 0}, {-10, 0}, {-10, 0}, {-10, 0}, {-5, 0},
            {0, 0}, {0, 0}, {0, 0}
        }
    }
}


function PrintBoxedTitle(title)
    local line = string.rep("=", #title + 4)

    OutputLogMessage("+%s+\n", line)
    OutputLogMessage("|  %s  |\n", title)
    OutputLogMessage("+%s+\n", line)
end

function PrintSeparator()
    OutputLogMessage("+%s+\n", string.rep("-", 46))
end

function PrintStatus()
    ClearLog()

    PrintBoxedTitle(" RECOIL SCRIPT v1.0 ")
    OutputLogMessage("\n")

    PrintSeparator()

    local weaponName =
        (selectedOperator == "off")
        and "OFF (Recoil Disabled)"
        or "AK-47"

    OutputLogMessage("|  WEAPON   :  %-25s |\n", weaponName)
    OutputLogMessage("|  SENSITIV :  %-25s |\n", ingamesensitivity .. " (in-game)")
    OutputLogMessage("|  DPI      :  %-25s |\n", dpi)
    OutputLogMessage("|  AUTHOR   :  %-25s |\n", "ITSinhuman")
    OutputLogMessage("|  VERSION  :  %-25s |\n", "Free Edition")
    OutputLogMessage("|  DISCORD  :  %-25s |\n", "https://discord.gg/866F6EJ6TK")

    PrintSeparator()

    OutputLogMessage("\n  Join Discord For Premium Version\n")
    OutputLogMessage("\n  Press Mouse 5 to toggle recoil ON/OFF\n")
    OutputLogMessage("  Hold Left Click to fire (recoil active)\n")
    OutputLogMessage("\n")
end


ClearLog()

PrintBoxedTitle("  LOGITECH RECOIL SCRIPT  ")
OutputLogMessage("\n")
OutputLogMessage("  • Loaded successfully\n")
OutputLogMessage("  • Made by ITSinhuman\n")
OutputLogMessage("  • Free version\n")
OutputLogMessage("  • Premium (more advanced options) at https://discord.gg/866F6EJ6TK\n")
OutputLogMessage("\n")

PrintStatus()


function RunRecoil(stats)
    Sleep(1)

    local stages = stats.stages
    local stageIndex = 1

    local stageStart = GetRunningTime()
    local lastMoveTime = stageStart

 
    local remainderX = 0
    local remainderY = 0

    while IsMouseButtonPressed(1) do
        local now = GetRunningTime()

        local moveX = 0
        local moveY = 0

        if stageIndex <= #stages then

            if now - stageStart >= 80 then
                stageIndex = stageIndex + 1
                stageStart = now
                lastMoveTime = now

           
            elseif now - lastMoveTime >= 10 then
                local stage = stages[stageIndex]

                moveX = stage[1]
                moveY = stage[2]

                lastMoveTime = now
            end
        end

        if stageIndex > #stages then
            break
        end

       
        local mult = 1 / ingamesensitivity

       
        local scaledX = (moveX * mult) + remainderX
        local scaledY = (moveY * mult) + remainderY

       
        local finalX = math.floor(scaledX + 0.5)
        local finalY = math.floor(scaledY + 0.5)

       
        remainderX = scaledX - finalX
        remainderY = scaledY - finalY

        if finalX ~= 0 or finalY ~= 0 then
            MoveMouseRelative(finalX, finalY)
        end
    end
end


function OnEvent(event, arg)
    EnablePrimaryMouseButtonEvents(true)

    if event == "MOUSE_BUTTON_PRESSED" then

       
        if arg == 5 then
            selectedOperator =
                (selectedOperator == "off")
                and "ak47"
                or "off"

            PrintStatus()

       
        elseif arg == 1 then
            local stats = operatorStats[selectedOperator]

            if stats then
                RunRecoil(stats)
            end
        end
    end
end
