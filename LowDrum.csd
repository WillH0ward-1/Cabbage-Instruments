<Cabbage>
form caption("Drums"), size(600, 625), colour(25, 25, 25), pluginId("drum")
label bounds(10, 10, 580, 20), text("Drums"), fontColour(255, 255, 255), font("default", 16)

button bounds(85, 35, 120, 25), channel("KICK"), text("KICKoff", "KICKon"), latched(0)
button bounds(240, 35, 120, 25), channel("SNARE"), text("SNAREoff", "SNAREon"), latched(0)
button bounds(395, 35, 120, 25), channel("HATS"), text("HATSoff", "HATSon"), latched(0)

groupbox bounds(10, 70, 180, 350), text("Kick"), outlineThickness(2)
hslider bounds(20, 100, 140, 30), channel("KickStrength"), range(0, 1, 1, 1, 0.01), text("Strength"), trackerColour("red")
hslider bounds(20, 140, 140, 30), channel("KickHarmonics"), range(0, 1, 0.5, 1, 0.01), text("Harmonics"), trackerColour("red")
hslider bounds(20, 180, 140, 30), channel("KickBaseFreq"), range(20, 80, 30, 1, 0.001), text("BaseFreq"), trackerColour("red")

vslider bounds(20, 220, 30, 120), channel("KickAmpAttack"), range(0.0001, 1, 0.0001, 1, 0.01), text("A"), trackerColour("red")
vslider bounds(60, 220, 30, 120), channel("KickAmpSustain"), range(0, 1, 0, 1, 0.01), text("S"), trackerColour("red")
vslider bounds(100, 220, 30, 120), channel("KickAmpDecay"), range(0.01, 1, 0.2, 1, 0.01), text("D"), trackerColour("red")
vslider bounds(140, 220, 30, 120), channel("KickAmpRelease"), range(0.05, 5, 0.1, 1, 0.01), text("R"), trackerColour("red")

groupbox bounds(205, 70, 180, 350), text("Snare"), outlineThickness(2)
hslider bounds(215, 100, 140, 30), channel("SnareStrength"), range(0, 1, 1, 1, 0.01), text("Strength"), trackerColour("green")
hslider bounds(215, 140, 140, 30), channel("SnareHarmonics"), range(0, 1, 1, 1, 0.01), text("Harmonics"), trackerColour("green")
hslider bounds(215, 180, 140, 30), channel("SnareBaseFreq"), range(40, 100, 40, 1, 0.001), text("BaseFreq"), trackerColour("green")

vslider bounds(215, 220, 30, 120), channel("SnareAmpAttack"), range(0.0001, 1, 0.0001, 1, 0.01), text("A"), trackerColour("green")
vslider bounds(255, 220, 30, 120), channel("SnareAmpSustain"), range(0, 1, 0, 1, 0.01), text("S"), trackerColour("green")
vslider bounds(295, 220, 30, 120), channel("SnareAmpDecay"), range(0, 1, 0.15, 1, 0.01), text("D"), trackerColour("green")
vslider bounds(335, 220, 30, 120), channel("SnareAmpRelease"), range(0.05, 5, 0.1, 1, 0.01), text("R"), trackerColour("green")

groupbox bounds(400, 70, 180, 350), text("Hats"), outlineThickness(2)
hslider bounds(410, 100, 140, 30), channel("HatsStrength"), range(0, 1, 1, 1, 0.01), text("Strength"), trackerColour("blue")
hslider bounds(410, 140, 140, 30), channel("HatsHarmonics"), range(0, 1, 1, 1, 0.01), text("Harmonics"), trackerColour("blue")
hslider bounds(410, 180, 140, 30), channel("HatsBaseFreq"), range(65.407, 2093.04, 261.630, 1, 0.001), text("BaseFreq"), trackerColour("blue")

vslider bounds(410, 220, 30, 120), channel("HatsAmpAttack"), range(0.0001, 1, 0.0001, 1, 0.01), text("A"), trackerColour("blue")
vslider bounds(450, 220, 30, 120), channel("HatsAmpSustain"), range(0, 1, 0, 1, 0.01), text("S"), trackerColour("blue")
vslider bounds(490, 220, 30, 120), channel("HatsAmpDecay"), range(0, 1, 0.05, 1, 0.01), text("D"), trackerColour("blue")
vslider bounds(530, 220, 30, 120), channel("HatsAmpRelease"), range(0.05, 5, 0.05, 1, 0.01), text("R"), trackerColour("blue")

signaldisplay bounds(10, 430, 580, 180), colour("green"), displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>
<CsInstruments>

ksmps = 1024
nchnls = 2
0dbfs = 1

gkBaseFreq init 440

instr DetectTriggers

    iKickAmpRelease chnget "KickAmpRelease"
    iSnareAmpRelease chnget "SnareAmpRelease"
    iHatsAmpRelease chnget "HatsAmpRelease"
    
    kToggleKick chnget "KICK"
    kToggleSnare chnget "SNARE"
    kToggleHats chnget "HATS"
    
    kTrigKick changed kToggleKick 
    kTrigSnare changed kToggleSnare
    kTrigHats changed kToggleHats 

    if kTrigKick == 1 then
        if kToggleKick == 1 then
            event "i", "Kick", 0, -1
            endif
    endif
    
    if kTrigSnare == 1 then
        if kToggleSnare == 1 then
            event "i", "Snare", 0, -1 
            endif
    endif
    
    if kTrigHats == 1 then
        if kToggleHats == 1 then
            event "i", "Hats", 0, -1 
            endif
    endif

endin

giSine ftgen 1, 0, 16384, 10, 1  ; Sine wave

instr Kick

    kKickStrength chnget "KickStrength"
    kKickHarmonics chnget "KickHarmonics"
    kKickBaseFreq chnget "KickBaseFreq"
    
    iAmpAttack chnget "KickAmpAttack"
    iAmpDecay chnget "KickAmpDecay"
    iAmpSustain chnget "KickAmpSustain"
    iAmpRelease chnget "KickAmpRelease"
    
    aAmpEnv madsr iAmpAttack, iAmpDecay, iAmpSustain, iAmpRelease

    aKickOsc oscili kKickStrength, kKickBaseFreq, giSine 
    aKickNoise noise 0.1, 0

    aRes1 = reson(aKickNoise, kKickBaseFreq, 20) * (kKickHarmonics * 0.001)
    aRes2 = reson(aKickNoise, kKickBaseFreq * 2, 40) * (kKickHarmonics * 0.001)

    aSound = aKickOsc + aRes1 + aRes2

    aFilteredSound butterlp aSound, 1000

    aOut = aFilteredSound * aAmpEnv

    outs aOut, aOut

    display aOut, .1, 1 

endin

instr Snare

    kSnareStrength chnget "SnareStrength"
    kSnareHarmonics chnget "SnareHarmonics"
    kSnareBaseFreq chnget "SnareBaseFreq"
    
    iAmpAttack chnget "SnareAmpAttack"
    iAmpDecay chnget "SnareAmpDecay"
    iAmpSustain chnget "SnareAmpSustain"
    iAmpRelease chnget "SnareAmpRelease"

    aAmpEnv madsr iAmpAttack, iAmpDecay, iAmpSustain, iAmpRelease

    aSnareNoise noise 0.5, 0

    aRes1 = reson(aSnareNoise, kSnareBaseFreq * 1, 150) * (kSnareHarmonics * 0.05)
    aRes2 = reson(aSnareNoise, kSnareBaseFreq * 2, 300) * (kSnareHarmonics * 0.05)
    aRes3 = reson(aSnareNoise, kSnareBaseFreq * 3, 450) * (kSnareHarmonics * 0.05)
    aRes4 = reson(aSnareNoise, kSnareBaseFreq * 4, 600) * (kSnareHarmonics * 0.05)
    aRes5 = reson(aSnareNoise, kSnareBaseFreq * 5, 750) * (kSnareHarmonics * 0.05)
    aRes6 = reson(aSnareNoise, kSnareBaseFreq * 6, 900) * (kSnareHarmonics * 0.1)
    aRes7 = reson(aSnareNoise, kSnareBaseFreq * 7, 1050) * (kSnareHarmonics * 0.1)
    aRes8 = reson(aSnareNoise, kSnareBaseFreq * 8, 1200) * (kSnareHarmonics * 1)

    aSound = (aSnareNoise * (1 - kSnareHarmonics)) + aRes1 + aRes2 + aRes3 + aRes4 + aRes5 + aRes6 + aRes7 + aRes8

    aLowBody butterlp aSound, 250 
    aLowBody = aLowBody * 0.3  
    
    aFilteredHPSound butterhp aSound, 3000 
    aFilteredHPSound = aFilteredHPSound * 1 

    aFullSound = aLowBody + aFilteredHPSound

    aOut = aFullSound * aAmpEnv

    aOut = aOut * 0.7
    
    outs aOut, aOut

    display aOut, .1, 1

endin




instr Hats

    kHatsStrength chnget "HatsStrength"
    kHatsHarmonics chnget "HatsHarmonics"
    kHatsBaseFreq chnget "HatsBaseFreq"
    
    iAmpAttack chnget "HatsAmpAttack"
    iAmpDecay chnget "HatsAmpDecay"
    iAmpSustain chnget "HatsAmpSustain"
    iAmpRelease chnget "HatsAmpRelease"

    aAmpEnv madsr iAmpAttack, iAmpDecay, iAmpSustain, iAmpRelease

    aHatsNoise noise 1, 0

    aRes1 = reson(aHatsNoise, kHatsBaseFreq * 2, 600) * (kHatsHarmonics * 0.1)
    aRes2 = reson(aHatsNoise, kHatsBaseFreq * 4, 1200) * (kHatsHarmonics * 0.1)

    aSound = (aHatsNoise * (1 - kHatsHarmonics)) + aRes1 + aRes2  

    aFilteredHPSound butterhp aSound, 4000

    aOut = aFilteredHPSound * aAmpEnv

    outs aOut, aOut

    display aOut, .1, 1

endin

</CsInstruments>
<CsScore>
i "DetectTriggers" 0 z
</CsScore>
</CsoundSynthesizer>