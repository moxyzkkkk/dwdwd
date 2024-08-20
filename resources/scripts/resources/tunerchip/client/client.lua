local handlingData = { "handlingName", "fMass", "fInitialDragCoeff", "fPercentSubmerged", "vecCentreOfMassOffset", "vecInertiaMultiplier", "fDriveBiasFront", "nInitialDriveGears", "fInitialDriveForce", "fDriveInertia", "fClutchChangeRateScaleUpShift", "fClutchChangeRateScaleDownShift", "fInitialDriveMaxFlatVel", "fBrakeForce", "fBrakeBiasFront", "fHandBrakeForce", "fSteeringLock", "fTractionCurveMax", "fTractionCurveMin", "fTractionCurveLateral", "fTractionSpringDeltaMax", "fLowSpeedTractionLossMult", "fCamberStiffnesss", "fTractionBiasFront", "fTractionLossMult", "fSuspensionForce", "fSuspensionCompDamp", "fSuspensionReboundDamp", "fSuspensionUpperLimit", "fSuspensionLowerLimit", "fSuspensionRaise", "fSuspensionBiasFront", "fTractionCurveMax", "fAntiRollBarForce", "fAntiRollBarBiasFront", "fRollCentreHeightFront", "fRollCentreHeightRear", "fCollisionDamageMult", "fWeaponDamageMult", "fDeformationDamageMult", "fEngineDamageMult", "fPetrolTankVolume", "fOilVolume", "fSeatOffsetDistX", "fSeatOffsetDistY", "fSeatOffsetDistZ", "nMonetaryValue", "strModelFlags", "strHandlingFlags", "strDamageFlags", "AIHandling", "fThrust", "fThrustFallOff", "fThrustVectoring", "fYawMult", "fYawStabilise", "fSideSlipMult", "fRollMult", "fRollStabilise", "fPitchMult", "fPitchStabilise", "fFormLiftMult", "fAttackLiftMult", "fAttackDiveMult", "fGearDownDragV", "fGearDownLiftMult", "fWindMult", "fMoveRes", "vecTurnRes", "vecSpeedRes", "fGearDoorFrontOpen", "fGearDoorRearOpen", "fGearDoorRearOpen2", "fGearDoorRearMOpen", "fTurublenceMagnitudeMax", "fTurublenceForceMulti", "fTurublenceRollTorqueMulti", "fTurublencePitchTorqueMulti", "fBodyDamageControlEffectMult", "fInputSensitivityForDifficulty", "fOnGroundYawBoostSpeedPeak", "fOnGroundYawBoostSpeedCap", "fEngineOffGlideMulti", "handlingType", "fThrustFallOff", "fThrustFallOff", "fBackEndPopUpCarImpulseMult", "fBackEndPopUpBuildingImpulseMult", "fBackEndPopUpMaxDeltaSpeed", "fLeanFwdCOMMult", "fLeanFwdForceMult", "fLeanBakCOMMult", "fLeanBakForceMult", "fMaxBankAngle", "fFullAnimAngle", "fDesLeanReturnFrac", "fStickLeanMult", "fBrakingStabilityMult", "fInAirSteerMult", "fWheelieBalancePoint", "fStoppieBalancePoint", "fWheelieSteerMult", "fRearBalanceMult", "fFrontBalanceMult", "fBikeGroundSideFrictionMult", "fBikeWheelGroundSideFrictionMult", "fBikeOnStandLeanAngle", "fBikeOnStandSteerAngle", "fJumpForce", }

local function SetVehicleHandlingData(vehicle, data, value)
    if DoesEntityExist(vehicle) and data and value then
        for k, v in pairs(handlingData) do 
            if v == data then
                local int, float, str, vec = string.find(v, 'n'), string.find(v, 'f'), string.find(v, 'str'), string.find(v, 'vec')

                if int ~= nil and int == 1 then 
                    SetVehicleHandlingInt(vehicle, 'CHandlingData', data, value)
                elseif float ~= nil and float == 1 then
                    local value = tonumber(value) + .0
                    SetVehicleHandlingFloat(vehicle, 'CHandlingData', data, value)
                elseif str ~= nil and str == 1 then
                    SetVehicleHandlingField(vehicle, 'CHandlingData', data, value)
                elseif vec ~= nil and vec == 1 then
                    SetVehicleHandlingVector(vehicle, 'CHandlingData', data, value)
                else
                    SetVehicleHandlingField(vehicle, 'CHandlingData', data, value)
                end
            end
        end
    end
end

local function openTunerChip()
    if not cache.vehicle and cache.seat ~= -1 then 
        return Zen.Functions.Notify("You need to be in a vehicle", 'car', '#FF0000')
    end

    local data = json.decode(GetResourceKvpString("tunerchip_data")) or {}

    local input = lib.inputDialog('Car TunerChip', {
        { type = 'slider', label = 'Boost', min = 0, max = 100, step = 5, default = data[1] or 60 },
        { type = 'slider', label = 'Acceleration',min = 0, max = 2, step = 0.1, default = data[2] or 1.8 },
        { type = 'slider', label = 'Gear Change', min = 0, max = 100, step = 0.1, default = data[3] or 3.1 },
        { type = 'slider', label = 'Braking', min = 0, max = 1, step = 0.1, default = data[4] or 0.3 },
        { type = 'slider', label = 'Drive Train', min = 0.1, max = 0.9, step = 0.01, default = data[5] or 0.3 },
    })

    if not input then return end

    SetResourceKvp("tunerchip_data", json.encode(input))

    local vehicle = cache.vehicle

    SetVehicleHandlingData(vehicle, "fInitialDriveMaxFlatVel", input[1]) 
    SetVehicleHandlingData(vehicle, "fInitialDriveForce", input[2]) 
    SetVehicleHandlingData(vehicle, "fClutchChangeRateScaleUpShift", input[3]) 
    SetVehicleHandlingData(vehicle, "fClutchChangeRateScaleDownShift", input[3]) 
    SetVehicleHandlingData(vehicle, "fBrakeBiasFront", input[4]) 
    SetVehicleHandlingData(vehicle, "fTractionBiasFront", input[5]) 
end

RegisterNetEvent('tunerchip:use', openTunerChip)