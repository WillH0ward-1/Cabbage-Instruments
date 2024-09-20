<Cabbage>
form caption("Thunder") size(400, 500), colour(25, 25, 25), pluginId("bolt")
label bounds(10, 10, 380, 20), text("Thunder"), fontColour(255, 255, 255), font("default", 16)
button bounds(160, 40, 80, 25) channel("OneShotTrigger"), text("Trigger", "Trigger"), identChannel("oneShotTriggerID")
hslider bounds(10, 80, 380, 40) channel("Amplitude") range(0, 1, 0.5, 1, 0.01) text("Amplitude") trackerColour("red")
hslider bounds(10, 130, 380, 40) channel("Aggression") range(0, 1, 1, 1, 0.01) text("Aggression") trackerColour("orange")
hslider bounds(10, 180, 380, 40) channel("Release") range(0, 1, 1, 1, 0.01) text("Release") trackerColour("yellow")
hslider bounds(10, 230, 380, 40) channel("FilterFreq") range(20, 20000, 5000, 1, 0.01) text("Filter Frequency") trackerColour("blue")
signaldisplay bounds(10, 280, 380, 160), colour("orange") displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")
</Cabbage>


<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1024
nchnls = 2
0dbfs = 1

instr DetectTriggers
    kOneShotTrigger chnget "OneShotTrigger"
    if changed(kOneShotTrigger) == 1 && kOneShotTrigger == 1 then
        event "i", "Thunder", 0, 0.1, 0  
        event "i", "SetOneShotColourON", 0, 0
        event "i", "SetOneShotColourOFF", 0.1, 0.1
    endif
    
endin

instr Thunder
    kAmp chnget "Amplitude"
    iAggression chnget "Aggression"
    iRelease chnget "Release"
    
    iAttack = 0.001 
    iDecay = 0.3  
    iSustain = 0  
    iRelease = 1 + iRelease * 4 
    
    ; Determine FilterFreq once per note event
    iThunderFreqMin = 1 + 300 * iAggression * 10
    iThunderFreqMax = iThunderFreqMin + 1 * iAggression * 20
    iFilterFreq = rnd(iThunderFreqMax - iThunderFreqMin) + iThunderFreqMin
    
    aNoise pinkish kAmp
    aEnv madsr iAttack, iDecay, iSustain, iRelease
    aExplosion = aNoise * aEnv
    
    aPreSaturated = aExplosion * (1 + iAggression * 15)  
    aSaturatedExplosion = tanh(aPreSaturated)  ; Use the tanh function for saturation
    
    ; Band-pass filter to boost mid to high frequencies based on kAggression
    iMidFreqMin = 20
    iMidFreqMax = 18000
    kMidFreq = iMidFreqMin + (iMidFreqMax - iMidFreqMin) * iAggression
    kBandwidth = 3000  ; Bandwidth of the band-pass filter
    aMidHighBoost butterbp aSaturatedExplosion, kMidFreq, kBandwidth
    aMidHighBoost = aMidHighBoost * iAggression
    
    ; Lowpass filter for additional control over the explosion's brightness
    aFinalExplosion butterlp (aSaturatedExplosion + aMidHighBoost), iFilterFreq
    
    outs aFinalExplosion, aFinalExplosion
    
    display aFinalExplosion, .1, 1
endin



instr SetOneShotColourOFF
    chnset "colour(0, 0, 0)", "oneShotTriggerID"
endin

instr SetOneShotColourON
    chnset "colour(0, 255, 0)", "oneShotTriggerID"
endin

instr SetAutoColourOFF
    chnset "colour(0, 0, 0)", "autoTriggerID"
endin

instr SetAutoColourON
    chnset "colour(0, 255, 0)", "autoTriggerID"
endin

</CsInstruments>
<CsScore>
i "DetectTriggers" 0 z
</CsScore>
</CsoundSynthesizer>
