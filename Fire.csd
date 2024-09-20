<Cabbage>
form caption("Fire Simulation") size(400, 550), colour(25, 25, 25), pluginId("fire")
label bounds(10, 10, 380, 20), text("Fire"), fontColour(255, 255, 255), font("default", 16)
button bounds(160, 40, 80, 25) channel("ONOFF") text("OFF", "ON")
hslider bounds(10, 80, 380, 40) channel("Amplitude") range(0, 1, 0.5, 1, 0.01) text("Amplitude") trackerColour("red")
hslider bounds(10, 130, 380, 40) channel("Crackle") range(0, 1, 1, 1, 0.01) text("Crackle") trackerColour("yellow")
hslider bounds(10, 180, 380, 40) channel("Sizzle") range(0, 1, 1, 1, 0.01) text("Sizzle") trackerColour("lightblue")
hslider bounds(10, 230, 380, 40) channel("Rumble") range(0, 1, 1, 1, 0.01) text("Rumble") trackerColour("green")
hslider bounds(10, 280, 380, 40) channel("Pops") range(0, 1, 1, 1, 0.01) text("Pops") trackerColour("blue")
hslider bounds(10, 330, 380, 40) channel("Intensity") range(0, 1, 0, 1, 0.01) text("Intensity") trackerColour("purple")
signaldisplay bounds(10, 380, 380, 160), colour("orange") displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-odac --displays
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1024
nchnls = 2
0dbfs = 1

instr DetectTriggers
    kOnOff chnget "ONOFF"
    if changed(kOnOff) == 1 then
        if kOnOff == 1 then
            event "i", "Fire", 0, -1
        else
            turnoff2 "Fire", 0, 0
        endif
    endif
endin

instr Fire
    kAmp chnget "Amplitude"
    kCrackle chnget "Crackle"
    kSizzle chnget "Sizzle"
    kRumble chnget "Rumble"
    kPops chnget "Pops"
    kIntensity chnget "Intensity" ; Get intensity value
    
    iAttack = 0.1 
    iDecay = 1  
    iSustain = 1  
    iRelease = 1 

    ; Define central frequencies and scaling factors
    iWooshFreq = 1200
    iCrackleFreq = 4000
    iSizzleFreq = 15000
    iPopsFreq = 6000
    iRumbleFreq = 80
    
    kWooshScaling = 0.0004
    kCrackleScaling = 0.1
    kSizzleScaling = 0.3
    kRumbleScaling = 0.0007
    kPopScaling = 0.8
    kMasterScaling = 0.1

    kCrackleFreq = iCrackleFreq + randi(-100, 500, 1)
    kSizzleFreq = iSizzleFreq + randi(-100, 500, 1)
    kPopsFreq = iPopsFreq + randi(-100, 500, 1)
    kRumbleFreq = iRumbleFreq + randi(-30, 100, 1)  ; Ensure Rumble doesn't go below 50Hz

    aCrackle dust2 kCrackle * kAmp * kCrackleScaling, 50
    aCrackleFilter reson aCrackle, kCrackleFreq, 1000, 0.9

    aSizzle dust2 kSizzle * kAmp * kSizzleScaling, 150
    aSizzleFilter reson aSizzle, kSizzleFreq, 500, 0.9

    aPops dust2 kPops * kAmp * kPopScaling, 5
    aPopsFilter reson aPops, kPopsFreq, 300, 0.9

    aRumble pinkish kRumble * kAmp * kRumbleScaling
    aRumbleFilter reson aRumble, kRumbleFreq, 60, 0.7
    
    aEnv madsr iAttack, iDecay, iSustain, iRelease
     
    ; Combine all components with their filters
    aOut = (aCrackleFilter + aSizzleFilter + aRumbleFilter + aPopsFilter) * kMasterScaling * aEnv

    ; Apply warm saturation using tanh function and increase based on intensity
    aOut = tanh(aOut * (1 + kIntensity * 3)) ; Saturation increases with intensity
    
    ; Scale the overall amplitude based on intensity
    aOut = aOut * (0.5 + kIntensity * 0.5) ; Amplitude grows with intensity

    outs aOut, aOut
    
    display aOut, .1, 1
endin

</CsInstruments>
<CsScore>
i "DetectTriggers" 0 z ; Run indefinitely for testing
</CsScore>
</CsoundSynthesizer>
