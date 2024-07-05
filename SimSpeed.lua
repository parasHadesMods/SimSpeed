local config = {
    TargetSimSpeed = 0.5
}

local RealAdjustSimulationSpeed = AdjustSimulationSpeed
local AdjustedSimSpeed = config.TargetSimSpeed
local LerpFinishesAtTime = nil

AdjustSimulationSpeed = function(args)
    AdjustedSimSpeed = args.Fraction * config.TargetSimSpeed

    if args.LerpTime then
        LerpFinishesAtTime = _worldTime + args.LerpTime
    else
        LerpFinishesAtTime = nil
    end
    RealAdjustSimulationSpeed({
        Fraction = AdjustedSimSpeed,
        LerpTime = args.LerpTime
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
            if LerpFinishesAtTime ~= nil then
                if AdjustedSimSpeed ~= config.TargetSimSpeed then
                    print("Refresh with active adjustment:", AdjustedSimSpeed)
                end
                -- No active lerp; refresh to ensure the timer doesn't run out
                RealAdjustSimulationSpeed({
                    Fraction = AdjustedSimSpeed,
                    LerpTime = 0
                })
            end
            wait(.1)
        end
    end
}
