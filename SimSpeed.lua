local config = {
    TargetSimSpeed = 0.1
}

local RealAdjustSimulationSpeed = AdjustSimulationSpeed
local AdjustedSimSpeed = config.TargetSimSpeed
local LerpFinishesAtTime = nil

AdjustSimulationSpeed = function(args)
    AdjustedSimSpeed = args.Fraction * config.TargetSimSpeed

    local adjustedLerpTime
    if args.LerpTime then
        adjustedLerpTime = args.LerpTime / config.TargetSimSpeed -- lerp for longer since we are running slower
        LerpFinishesAtTime = _worldTime + args.LerpTime
    else
        LerpFinishesAtTime = nil
    end
    print("Set sim speed", AdjustedSimSpeed, adjustedLerpTime)
    RealAdjustSimulationSpeed({
        Fraction = AdjustedSimSpeed,
        LerpTime = adjustedLerpTime
    })
end

OnAnyLoad {
    function ()
        AdjustedSimSpeed = config.TargetSimSpeed
        LerpFinishesAtTime = nil
        while true do
            if LerpFinishesAtTime ~= nil and _worldTime > LerpFinishesAtTime then
                LerpFinishesAtTime = nil
            end
            if LerpFinishesAtTime == nil then
                if AdjustedSimSpeed ~= config.TargetSimSpeed then
                    print("Refresh with active adjustment:", AdjustedSimSpeed)
                end
                -- No active lerp; refresh to ensure the timer doesn't run out
                --print("Reset sim speed", AdjustedSimSpeed, 0)
                RealAdjustSimulationSpeed({
                    Fraction = AdjustedSimSpeed,
                    LerpTime = 0
                })
            else
                print("Waiting:", _worldTime, LerpFinishesAtTime)
            end
            wait(0.5 * config.TargetSimSpeed)
        end
    end
}
