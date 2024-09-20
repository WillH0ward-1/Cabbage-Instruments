<Cabbage>
form caption("Flute"), size(400, 805), colour(25, 25, 25), pluginId("flut")
label bounds(10, 10, 380, 20), text("Flute"), fontColour(255, 255, 255), font("default", 16)

button bounds(160, 35, 80, 25), channel("ONOFF"), text("OFF", "ON"), latched(1)

button bounds(55, 98, 40, 25), channel("C"), identChannel("id_note_C"), text("C"), colour("black"), latched(0)
button bounds(98, 98, 40, 25), channel("D"), identChannel("id_note_D"), text("D"), colour("black"), latched(0)
button bounds(141, 98, 40, 25), channel("E"), identChannel("id_note_E"), text("E"), colour("black"), latched(0)
button bounds(184, 98, 40, 25), channel("F"), identChannel("id_note_F"), text("F"), colour("black"), latched(0)
button bounds(227, 98, 40, 25), channel("G"), identChannel("id_note_G"), text("G"), colour("black"), latched(0)
button bounds(270, 98, 40, 25), channel("A"), identChannel("id_note_A"), text("A"), colour("black"), latched(0)
button bounds(313, 98, 40, 25), channel("B"), identChannel("id_note_B"), text("B"), colour("black"), latched(0)

button bounds(80, 73, 30, 20), channel("Cs"), identChannel("id_note_Cs"), text("C#"), colour("black"), latched(0)
button bounds(123, 73, 30, 20), channel("Ds"), identChannel("id_note_Ds"), text("D#"), colour("black"), latched(0)
button bounds(210, 73, 30, 20), channel("Fs"), identChannel("id_note_Fs"), text("F#"), colour("black"), latched(0)
button bounds(253, 73, 30, 20), channel("Gs"), identChannel("id_note_Gs"), text("G#"), colour("black"), latched(0)
button bounds(296, 73, 30, 20), channel("As"), identChannel("id_note_As"), text("A#"), colour("black"), latched(0)

hslider bounds(10, 125, 380, 30), channel("Strength"), range(0, 1, 1, 1, 0.01), text("Strength"), trackerColour("blue")
hslider bounds(10, 160, 380, 30), channel("Harmonics"), range(0, 1, 1, 1, 0.01), text("Harmonics"), trackerColour("blue")
hslider bounds(10, 195, 380, 30), channel("LFODepth"), range(0, 1, 1, 1, 0.01), text("LFO Depth"), trackerColour("blue")
hslider bounds(10, 230, 380, 30), channel("LFOSpeed"), range(0, 1, 1, 1, 0.01), text("LFO Speed"), trackerColour("blue")
hslider bounds(10, 265, 380, 30), channel("Octave"), range(0, 4, 2, 1, 1), text("Octave"), trackerColour("blue")
hslider bounds(10, 300, 380, 30), channel("Stability"), range(0, 1, 1, 1, 0.01), text("Stability"), trackerColour("blue")
hslider bounds(10, 335, 380, 30), channel("Breath"), range(0, 0.1, 0.03, 1, 0.001), text("Breath"), trackerColour("blue")

hslider bounds(10, 370, 380, 30), channel("gkBaseFreq"), range(65.407, 2093.04, 261.630, 1, 0.001), text("BaseFreq"), trackerColour("green")
hslider bounds(10, 405, 380, 30), channel("gkFreq"), range(65.407, 2093.04, 261.630, 1, 0.001), text("Frequency"), trackerColour("green")

groupbox bounds(10, 440, 380, 165), text("Amp ADSR"), outlineThickness(2)
hslider bounds(20, 465, 350, 40), channel("AmpAttack"), range(0.05, 10, 0.1, 1, 0.01), text("Attack"), trackerColour("blue")
hslider bounds(20, 500, 350, 40), channel("AmpSustain"), range(0.2, 1, 0.75, 1, 0.01), text("Sustain"), trackerColour("blue")
hslider bounds(20, 535, 350, 40), channel("AmpDecay"), range(0.2, 1, 1, 1, 0.01), text("Decay"), trackerColour("blue")
hslider bounds(20, 570, 350, 40), channel("AmpRelease"), range(0.05, 5, 0.1, 1, 0.01), text("Release"), trackerColour("blue")

signaldisplay bounds(10, 615, 380, 180), colour("green") displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")
</Cabbage>


<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>
<CsInstruments>

ksmps = 1024
nchnls = 2
0dbfs = 1

giSine ftgen 1, 0, 16384, 10, 1

gkBaseFreq init 261.63  ; Middle C, Octave 2
gkFreq init 261.63  ; Middle C, Octave 2

gkMinFreq init 65.407 ; Low C, Octave 0
gkMaxFreq init 2093.04 ; High C, Octave 4
 
instr CheckNotes

    kManual chnget "MANUAL"
    kC chnget "C"
    kCs chnget "Cs"
    kD chnget "D"
    kDs chnget "Ds"
    kE chnget "E"
    kF chnget "F"
    kFs chnget "Fs"
    kG chnget "G"
    kGs chnget "Gs"
    kA chnget "A"
    kAs chnget "As"
    kB chnget "B"
    
    kFreqSlider chnget "gkBaseFreq"

    kFreq = kFreqSlider

    if changed(kC) == 1 && kC == 1 then
        kFreq = 261.63  ; C4
    elseif changed(kCs) == 1 && kCs == 1 then
        kFreq = 277.18  ; C#4/Db4
    elseif changed(kD) == 1 && kD == 1 then
        kFreq = 293.66  ; D4
    elseif changed(kDs) == 1 && kDs == 1 then
        kFreq = 311.13  ; D#4/Eb4
    elseif changed(kE) == 1 && kE == 1 then
        kFreq = 329.63  ; E4
    elseif changed(kF) == 1 && kF == 1 then
        kFreq = 349.23  ; F4
    elseif changed(kFs) == 1 && kFs == 1 then
        kFreq = 369.99  ; F#4/Gb4
    elseif changed(kG) == 1 && kG == 1 then
        kFreq = 392.00  ; G4
    elseif changed(kGs) == 1 && kGs == 1 then
        kFreq = 415.30  ; G#4/Ab4
    elseif changed(kA) == 1 && kA == 1 then
        kFreq = 440.00  ; A4
    elseif changed(kAs) == 1 && kAs == 1 then
        kFreq = 466.16  ; A#4/Bb4
    elseif changed(kB) == 1 && kB == 1 then
        kFreq = 493.88  ; B4
    endif

    gkBaseFreq = kFreq
    
    chnset gkBaseFreq, "gkBaseFreq"

endin

instr DetectTriggers

    iAmpRelease chnget "AmpRelease"
    
    kToggleFlute chnget "ONOFF"
    kToggleLatchFlute chnget "ONOFFLatch"
    
    kTrigFlute changed kToggleFlute 
    
    if kTrigFlute == 1 then
        if kToggleFlute == 1 || kToggleLatchFlute == 1 then
            event "i", "Flute", 0, -1 
        elseif kToggleFlute == 0 || kToggleLatchFlute = 0 then
             turnoff2 "Flute", 0, iAmpRelease 
        endif
    endif
    
endin

instr Flute

    kOnOff chnget "ONOFF"
    kFluteStrength chnget "Strength"
    kFluteHarmonics chnget "Harmonics"
    kLFODepth chnget "LFODepth"
    kLFOSpeed chnget "LFOSpeed"
    kStability chnget "Stability"
    kOctave chnget "Octave"
    kBreath chnget "Breath"

    iAmpAttack chnget "AmpAttack"
    iAmpDecay chnget "AmpDecay"
    iAmpSustain chnget "AmpSustain"
    iAmpRelease chnget "AmpRelease"

    ; Amplitude Envelope
    aAmpEnv madsr iAmpAttack, iAmpDecay, iAmpSustain, iAmpRelease

    ; Generate random pitch & amplitude fluctuations based on 'Stability' parameter
    kPitchFluctuation randi kStability * 50, kLFOSpeed  ; Frequency Fluctuation 
    kAmpFluctuation randi kStability * 10, kLFOSpeed   ; Amplitude Fluctuation

    ; LFO for vibrato effect, modulated by Stability
    kLFOSpeedModulated = kLFOSpeed + (kLFOSpeed * kPitchFluctuation * 0.2)  ; Multiplier is depth
    kLFODepthModulated = kLFODepth + (kLFODepth * kAmpFluctuation * 3)    ; Adjust depth as needed
    kLFO lfo kLFODepthModulated, kLFOSpeedModulated, 1

    ; Octave Calculation
    kOctaveMultiplier = pow(2, kOctave - 4) * 4 
    kAdjustedFreq = gkBaseFreq * kOctaveMultiplier

    chnset kAdjustedFreq, "gkFreq"
    
    ; Generate tone
    aTone oscil kFluteStrength, kAdjustedFreq + kLFO, giSine
    
    kScaledHarmonics = kFluteHarmonics * 0.001

    ; Resonant harmonics
    aRes1 = reson(aTone, kAdjustedFreq * 2, 20) * kScaledHarmonics  ; 2nd harmonic
    aRes2 = reson(aTone, kAdjustedFreq * 3, 20) * kScaledHarmonics  ; 3rd harmonic
    aRes3 = reson(aTone, kAdjustedFreq * 4, 20) * kScaledHarmonics  ; 4th harmonic
    aRes4 = reson(aTone, kAdjustedFreq * 5, 20) * kScaledHarmonics   ; 5th harmonic
    aRes5 = reson(aTone, kAdjustedFreq * 6, 20) * kScaledHarmonics   ; 6th harmonic
    aRes6 = reson(aTone, kAdjustedFreq * 7, 20) * kScaledHarmonics   ; 7th harmonic
    
    
    kFreqRatio = (kAdjustedFreq - gkMinFreq) / (gkMaxFreq - gkMinFreq)
    kAmplitudeAdjustment = (1 - kFreqRatio * 1.8) + (1 - kFreqRatio) * 0.25  ; Boost lower frequencies, reduce higher

    if kAmplitudeAdjustment < 0 then
        kAmplitudeAdjustment = 0  
    endif

    ; Combine resonant filters for the enhanced tone
    aEnhancedTone = aTone + aRes1 + aRes2 + aRes3 + aRes4 + aRes5 + aRes6 
    aEnhancedTone = aEnhancedTone * kAmplitudeAdjustment
    
    ; White noise for breath sound
    aBreathNoise noise 0.5, 0

    ; Center frequency and bandwidth for the breath's filter
    kBreathFreq = kAdjustedFreq * 4 / 2 ; Center frequency for breath characteristics
    kBw = 20  ; Bandwidth for the breath filter

    ; Filter the breath noise to simulate breath characteristics
    aBreathFiltered = reson(aBreathNoise, kBreathFreq, kBw) * kBreath * 0.1 

    ; Combine resonant filters for the enhanced tone and breath sound
    aSound = aEnhancedTone + aBreathFiltered

    ; High pass filter
    aFilteredHPSound butterhp aSound, 1000

    ; Apply the amplitude envelope to the filtered sound, with the octave-based amplitude adjustment
    aOut = aFilteredHPSound * aAmpEnv 

    ; Output 
    outs aOut, aOut

    display aOut, .1, 1

endin

</CsInstruments>
<CsScore>
i "DetectTriggers" 0 z
i "CheckNotes" 0 z
</CsScore>
</CsoundSynthesizer>