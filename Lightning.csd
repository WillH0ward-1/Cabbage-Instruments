<Cabbage>
form caption("Lightning") size(400, 500), colour(25, 25, 25), pluginId("bolt")
label bounds(10, 10, 380, 20), text("Lightning"), fontColour(255, 255, 255), font("default", 16)
button bounds(160, 40, 80, 25) channel("ONOFF") text("OFF", "ON")
hslider bounds(10, 80, 380, 40) channel("Amplitude") range(0, 1, 0.5, 1, 0.01) text("Amplitude") trackerColour("blue")
hslider bounds(10, 130, 380, 40) channel("Buzz") range(0, 1, 1, 1, 0.01) text("Buzz") trackerColour("cyan")
hslider bounds(10, 180, 380, 40) channel("Hiss") range(0, 1, 1, 1, 0.01) text("Hiss") trackerColour("blue")
hslider bounds(10, 230, 380, 40) channel("Pops") range(0, 1, 1, 1, 0.01) text("Pops") trackerColour("cyan")
hslider bounds(10, 280, 380, 40) channel("Agitation") range(0, 1, 1, 1, 0.01) text("Agitation") trackerColour("blue")
signaldisplay bounds(10, 330, 380, 160), colour("blue") displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-odac --displays
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 512
nchnls = 2
0dbfs = 1

instr DetectTriggers
    kOnOff chnget "ONOFF"
    if changed(kOnOff) == 1 then
        if kOnOff == 1 then
            event "i", "Lightning", 0, -1
        else
            turnoff2 "Lightning", 0, 0
        endif
    endif
endin

instr Lightning
    kAmp chnget "Amplitude"
    kBuzz chnget "Buzz"
    kHiss chnget "Hiss"
    kPops chnget "Pops"
    kAgitation chnget "Agitation"
    
    iBuzzScaling = 0.05
    iHissScaling = 0.2
    iPopsScaling = 0.2
    kBuzzFreq = 120
    
    kBuzzFilterFreqMin = 13000
    kBuzzFilterFreqMax = 20000
    kHissFilterFreqMin = 18000
    kHissFilterFreqMax = 20000
    kPopFilterFreqMin = 8000
    kPopFilterFreqMax = 10000
    
    kBuzzFilterFreq randi kBuzzFilterFreqMin, kBuzzFilterFreqMax, 1
    kHissFilterFreq randi kHissFilterFreqMin, kHissFilterFreqMax, 1
    kPopsFilterFreq randi kPopFilterFreqMin, kPopFilterFreqMax, 1
    
    ; Buzz component with resonant filter
    aBuzz vco2 kBuzz * kAmp * iBuzzScaling, kBuzzFreq, 0
    aBuzzFiltered reson aBuzz, kBuzzFilterFreq, 2000
    
    aBuzzMix = aBuzz + aBuzzFiltered
    
    ; Hiss component with resonant filter
    aHiss dust2 kHiss * kAmp * iHissScaling, 500
    aHissFiltered reson aHiss, kHissFilterFreq, 2000 
    
    ; Pops component with resonant filter
    aPops dust2 kPops * kAmp * iPopsScaling, 500
    aPopsFiltered reson aPops, kPopsFilterFreq, 1000 
    
    ; Mix components
    aOut = (aBuzzMix + aHissFiltered + aPopsFiltered) * kAmp
    outs aOut, aOut
    
    display aOut, .1, 1
endin

</CsInstruments>
<CsScore>
i "DetectTriggers" 0 z ; Run indefinitely for testing
</CsScore>
</CsoundSynthesizer>
