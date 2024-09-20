<Cabbage>
form caption("Bugs"), size(400, 950), colour(25, 25, 25), pluginId("bugs")
label bounds(10, 10, 380, 20), text("Bugs"), fontColour(255, 255, 255), font("default", 16)

label bounds(10, 900, 380, 20), channel("TriggerID"), visible(0), text("Trigger ID Storage")

; On/Off and AutoTrigger buttons
button bounds(160, 35, 80, 25), channel("ONOFF"), text("OFF", "ON"), latched(1)
button bounds(260, 35, 80, 25), channel("AutoTrigger"), text("AUTO-OFF", "AUTO-ON"), identChannel("autoTriggerID")

; Piano keys
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


hslider bounds(10, 125, 380, 30), channel("Octave"), range(0, 2, 2, 1, 1), text("Octave"), trackerColour("blue")
hslider bounds(10, 160, 380, 30), channel("Stability"), range(0, 1, 1, 1, 0.01), text("Stability"), trackerColour("blue")
hslider bounds(10, 195, 380, 30), channel("gkFreq"), range(0, 5000, 0.03, 1, 0.001), text("GlobalFreq"), trackerColour("green")

; Modulation controls
hslider bounds(10, 230, 380, 30), channel("BPM"), range(5, 300, 120, 1, 1), text("BPM"), trackerColour("red")
hslider bounds(10, 265, 380, 30), channel("ModFrequency"), range(0.1, 300, 1, 1, 0.1), text("Mod Frequency"), trackerColour("orange")
hslider bounds(10, 300, 380, 30), channel("ModIntensity"), range(0, 1, 1, 1, 0.01), text("Mod Intensity"), trackerColour("yellow")
hslider bounds(10, 335, 380, 30), channel("Freq"), range(0, 5000, 500, 1, 1), text("Carrier Frequency"), trackerColour("red")
hslider bounds(10, 370, 380, 30), channel("ModBandwidth"), range(0, 5000, 500, 1, 1), text("Modulation Bandwidth"), trackerColour("red")
hslider bounds(10, 440, 380, 30), channel("AutoRandom"), range(0, 1, 0, 1, 0.01), text("AutoRandom"), trackerColour("purple")

; Waveform sliders
hslider bounds(10, 475, 180, 30), channel("BaseWave"), range(0, 1, 0, 1, 0.01), text("Base Waveform"), trackerColour("pink")
hslider bounds(200, 475, 180, 30), channel("ModWave"), range(0, 1, 0, 1, 0.01), text("Mod Waveform"), trackerColour("lightgreen")

; Pitch glide controls
hslider bounds(10, 510, 380, 30), channel("PitchGlide"), range(-1, 1, 0, 1, 0.01), text("Pitch Glide"), trackerColour("cyan")
hslider bounds(10, 545, 380, 30), channel("PitchGlideSpeed"), range(0.1, 1, 1, 1, 0.01), text("Pitch Glide Speed"), trackerColour("cyan")
hslider bounds(10, 580, 380, 30), channel("PitchGlideIntensity"), range(0, 1000, 500, 1, 1), text("Pitch Glide Intensity"), trackerColour("cyan")

; Amp ADSR controls
groupbox bounds(10, 615, 380, 165), text("Amp ADSR"), outlineThickness(2)
hslider bounds(20, 645, 350, 40), channel("AmpAttack"), range(0.01, 5, 0.1, 1, 0.01), text("Attack"), trackerColour("blue")
hslider bounds(20, 680, 350, 40), channel("AmpSustain"), range(0, 1, 0, 1, 0.01), text("Sustain"), trackerColour("blue")
hslider bounds(20, 715, 350, 40), channel("AmpDecay"), range(0.1, 1, 1, 1, 0.01), text("Decay"), trackerColour("blue")
hslider bounds(20, 750, 350, 40), channel("AmpRelease"), range(0.05, 5, 0.5, 1, 0.01), text("Release"), trackerColour("blue")

; Strength control
hslider bounds(10, 785, 380, 30), channel("Strength"), range(0, 1, 0.15, 1, 0.01), text("Strength"), trackerColour("purple")

; Signal display
signaldisplay bounds(10, 825, 380, 110), colour("green"), displayType("waveform"), backgroundColour(0, 0, 0), zoom(-0.5), signalVariable("aOut"), channel("display")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>
<CsInstruments>

; Global variables
ksmps = 512
nchnls = 2
0dbfs = 1

giSine ftgen 0, 0, 8192, 10, 1
giSaw ftgen 0, 0, 8192, 7, -1, 8192, 1
giSquare ftgen 0, 0, 8192, 7, 1, 4096, 1, 4096, -1
giTriangle ftgen 0, 0, 8192, 7, 1, 2048, 1, 4096, -1, 2048, -1


instr Init
    chnset 0, "AutoTrigger"
endin

instr CheckNotes
    ; Initialize button state variables
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
    
    ; Read the frequency from the slider
    kFreqSlider chnget "gkFreq"

    if kManual == 0 then  ; Manual mode is off, use note checker
        ; Update the global frequency based on which note button is pressed
        if changed(kC) == 1 && kC == 1 then
            gkFreq = 261.63  ; C4
        elseif changed(kCs) == 1 && kCs == 1 then
            gkFreq = 277.18  ; C#4/Db4
        elseif changed(kD) == 1 && kD == 1 then
            gkFreq = 293.66  ; D4
        elseif changed(kDs) == 1 && kDs == 1 then
            gkFreq = 311.13  ; D#4/Eb4
        elseif changed(kE) == 1 && kE == 1 then
            gkFreq = 329.63  ; E4
        elseif changed(kF) == 1 && kF == 1 then
            gkFreq = 349.23  ; F4
        elseif changed(kFs) == 1 && kFs == 1 then
            gkFreq = 369.99  ; F#4/Gb4
        elseif changed(kG) == 1 && kG == 1 then
            gkFreq = 392.00  ; G4
        elseif changed(kGs) == 1 && kGs == 1 then
            gkFreq = 415.30  ; G#4/Ab4
        elseif changed(kA) == 1 && kA == 1 then
            gkFreq = 440.00  ; A4
        elseif changed(kAs) == 1 && kAs == 1 then
            gkFreq = 466.16  ; A#4/Bb4
        elseif changed(kB) == 1 && kB == 1 then
            gkFreq = 493.88  ; B4
        endif
    else
        ; If manual mode is on, use a metronome to trigger the Bird instrument
        kBPM chnget "BPM"
        kMetro metro (60 / kBPM)
        if kMetro == 1 then
            event "i", "Bird", 0, 0.1  ; Trigger Bird instrument
        endif
    endif

    ; Always update the global frequency
    chnset gkFreq, "gkFreq"
endin

instr DetectTriggers

    iAmpRelease chnget "AmpRelease"
    
    kToggleFlute chnget "ONOFF"
    kTrigFlute changed kToggleFlute 
    
    if kTrigFlute == 1 then
        if kToggleFlute == 1 then
            event "i", 1, 0, -1 ; Start instr Bird indefinitely
        elseif kToggleFlute == 0 then
            turnoff2 1, 0, iAmpRelease ; Stop the Bird instrument
        endif
    endif
    
    kAutoTrigger chnget "AutoTrigger"
    if changed(kAutoTrigger) == 1 && kAutoTrigger == 1 then
        event "i", "AutoTrigger", 0, -1
    elseif changed(kAutoTrigger) == 1 && kAutoTrigger == 0 then
        turnoff2 "AutoTrigger", 0, 0.1
    endif
    
endin

giModFreq init 0  ; Initialize global modulation frequency


; Function table definitions
giSine     ftgen 0, 0, 8192, 10, 1
giSaw      ftgen 0, 0, 8192, 7, -1, 8192, 1
giSquare   ftgen 0, 0, 8192, 7, 1, 4096, 1, 4096, -1
giTriangle ftgen 0, 0, 8192, 7, 0, 2048, 1, 4096, -1, 2048, 0


instr 1

; Retrieve control values
kTriggerID chnget "TriggerID"  ; This should be a unique ID for each trigger
    
kOnOff chnget "ONOFF"
kStability chnget "Stability"
kOctave chnget "Octave"
kCarrierFreq chnget "Freq"
kModBandwidth chnget "ModBandwidth"
iModIntensity chnget "ModIntensity"
kBPM chnget "BPM"
kModFrequency chnget "ModFrequency"
kStrength chnget "Strength"
kPitchGlide chnget "PitchGlide"
kPitchGlideSpeed chnget "PitchGlideSpeed"

iAmpAttack chnget "AmpAttack"
iAmpDecay chnget "AmpDecay"
iAmpSustain chnget "iAmpSustain"
iAmpRelease chnget "AmpRelease"

; Generate amplitude envelope
aAmpEnv madsr iAmpAttack, iAmpDecay, iAmpSustain, iAmpRelease

; Generate random fluctuations based on Stability for pitch and amplitude modulation
kPitchFluctuation randi kStability * 20, kBPM

; Read global frequency (gkFreq)
kGlobalFreq chnget "gkFreq"

; Adjust octave range from 0-3 to 4-6
kAdjustedOctave = kOctave + 4

; Apply octave shift
kOctaveMultiplier = pow(2, kAdjustedOctave - 1) * 2
kAdjustedFreq = kGlobalFreq * kOctaveMultiplier

iModIntensity = iModIntensity * 50 + 10

if changed(kTriggerID) == 1 then
    ; Randomize modulation frequency and bandwidth once per trigger
    giModFreq = random(10, 50)  ; Recalculate only if there's a new trigger
    kRandomModFreq = giModFreq + (kStability * random(-giModFreq, giModFreq))
    chnset kRandomModFreq, "ModFrequency"  ; Update modulation frequency channel

    giBandWidth = random(1, giModFreq)  ; Ensure bandwidth is proportional to frequency
    kRandomModBandWidth = giBandWidth + (kStability * random(-giBandWidth, giBandWidth))
    chnset kRandomModBandWidth, "ModBandwidth"  ; Update modulation bandwidth channel
endif

; Select base waveform
kBaseWave chnget "BaseWave"
kBaseSineWeight = max(0, 1 - 4 * abs(kBaseWave - 0.125))
kBaseSawWeight = max(0, 1 - 4 * abs(kBaseWave - 0.375))
kBaseSquareWeight = max(0, 1 - 4 * abs(kBaseWave - 0.625))
kBaseTriangleWeight = max(0, 1 - 4 * abs(kBaseWave - 0.875))
kBaseSum = kBaseSineWeight + kBaseSawWeight + kBaseSquareWeight + kBaseTriangleWeight
kBaseSineWeight /= kBaseSum
kBaseSawWeight /= kBaseSum
kBaseSquareWeight /= kBaseSum
kBaseTriangleWeight /= kBaseSum

; Select modulation waveform
kModWave chnget "ModWave"
kModSineWeight = max(0, 1 - 4 * abs(kModWave - 0.125))
kModSawWeight = max(0, 1 - 4 * abs(kModWave - 0.375))
kModSquareWeight = max(0, 1 - 4 * abs(kModWave - 0.625))
kModTriangleWeight = max(0, 1 - 4 * abs(kModWave - 0.875))
kModSum = kModSineWeight + kModSawWeight + kModSquareWeight + kModTriangleWeight
kModSineWeight /= kModSum
kModSawWeight /= kModSum
kModSquareWeight /= kModSum
kModTriangleWeight /= kModSum

; Normalization factors to equalize perceived loudness
gkSawNormFactor = 0.5
gkSquareNormFactor = 0.5

; Generate FM modulation using global variables updated upon trigger change
aModSine poscil iModIntensity, kRandomModFreq, giSine
aModSaw poscil iModIntensity * gkSawNormFactor, kRandomModFreq, giSaw
aModSquare poscil iModIntensity * gkSquareNormFactor, kRandomModFreq, giSquare
aModTriangle poscil iModIntensity, kRandomModFreq, giTriangle
aModulator = aModSine * kModSineWeight + aModSaw * kModSawWeight + aModSquare * kModSquareWeight + aModTriangle * kModTriangleWeight

; Define a new control value for Pitch Glide Intensity
kPitchGlideIntensity chnget "PitchGlideIntensity"
; Apply pitch glide with intensity control
kGlideFreq = kPitchGlide * kPitchGlideIntensity  ; Scale glide amount
aGlide poscil kGlideFreq, kPitchGlideSpeed, giSaw  ; Use saw wave for linear pitch glide
kGlideAdjustedFreq = kAdjustedFreq + aGlide

; Generate the base waveforms with the adjusted frequency and modulation
aBaseSine poscil 1, kGlideAdjustedFreq + aModulator * kRandomModBandWidth, giSine
aBaseSaw poscil 1 * gkSawNormFactor, kGlideAdjustedFreq + aModulator * kRandomModBandWidth, giSaw
aBaseSquare poscil 1 * gkSquareNormFactor, kGlideAdjustedFreq + aModulator * kRandomModBandWidth, giSquare
aBaseTriangle poscil 1, kGlideAdjustedFreq + aModulator * kRandomModBandWidth, giTriangle
aCarrier = aBaseSine * kBaseSineWeight + aBaseSaw * kBaseSawWeight + aBaseSquare * kBaseSquareWeight + aBaseTriangle * kBaseTriangleWeight

; Apply high-pass and low-pass filters to reduce aliasing
aFilteredCarrier butterhp aCarrier, 20
aFilteredCarrier butterlp aFilteredCarrier, 14000

; Output the filtered FM sound
chnset kAdjustedFreq, "Freq"  ; Update modulation bandwidth channel

; Generate tone
aTone oscil 1, aFilteredCarrier, giSine

; Apply a high-pass filter at around 2000 Hz to the combined sound
aFilteredSound butterhp aFilteredCarrier, 10000

; Apply the amplitude envelope to the filtered sound
aOut = aFilteredSound * aAmpEnv * kStrength

; Output the combined audio signal
outs aOut, aOut

display aOut, .1, 1

endin

instr AutoTrigger
    kAutoTrigger chnget "AutoTrigger"
    kBPM chnget "BPM"
    kAutoRandom chnget "AutoRandom"
    kAmpRelease chnget "AmpRelease"

    ; Generate a unique trigger ID
    kUniqueID random 0, 100000
    chnset kUniqueID, "TriggerID"

    ; Correct base rate calculation for BPM to seconds conversion
    kBaseRate = 60 / kBPM   ; Correct calculation for seconds per beat

    ; Calculate the metronome rate with random deviation
    kDeviation = kBaseRate * kAutoRandom * (1 - 2 * rnd(1))  ; Deviation within +/- AutoRandom range
    kAdjustedRate = max(0.01, kBaseRate + kDeviation)  ; Ensure the adjusted rate is never negative or too low

    ; Trigger periodically if AutoTrigger is enabled
    if kAutoTrigger == 1 then
        kMetro metro kAdjustedRate  ; Use adjusted rate for metronome
        if kMetro == 1 then
            event "i", 1, 0, kAmpRelease  ; Trigger Bird instrument for the duration until the next trigger
        endif
    endif
endin

instr TerminateTrigger
    turnoff  ; Ensure this instrument can be used to stop others if needed
endin

</CsInstruments>
<CsScore>
; Always run the DetectTriggers and CheckNotes instruments to monitor the state
i "Init" 0 1
i "DetectTriggers" 0 z
i "CheckNotes" 0 z
i "AutoTrigger" 0 z  ; Run the AutoTrigger instrument
</CsScore>
</CsoundSynthesizer>
