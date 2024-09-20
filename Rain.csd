<Cabbage>
form caption("Rain Generator") size(400, 800), colour(25, 25, 25), pluginId("rain")
label bounds(10, 10, 380, 20), text("Rain Generator"), fontColour(255, 255, 255), font("default", 16)
button bounds(160, 40, 80, 25) channel("RainDropTrigger"), text("RainDrop"), identChannel("rainDropTriggerID"), latched(0)
button bounds(70, 40, 80, 25) channel("RainNoiseTrigger"), text("RainNoiseON", "RainNoiseOFF"), identChannel("rainNoiseTriggerID"), latched(1)
button bounds(250, 40, 80, 25) channel("AutoTrigger"), text("AutoOFF", "AutoON"), identChannel("autoTriggerID")
hslider bounds(10, 80, 380, 40) channel("RainStrength") range(0, 1, 0.5, 1, 0.01) text("Rain Strength") trackerColour("blue")

; Amp ADSR
groupbox bounds(10, 130, 380, 165) text("Amp ADSR") outlineThickness(2)
hslider bounds(20, 160, 350, 40) channel("AmpAttack") range(0.05, 0.1, 0.05, 1, 0.01) text("Attack") trackerColour("blue")
hslider bounds(20, 210, 350, 40) channel("AmpDecay") range(0.2, 1, 0.2, 1, 0.01) text("Decay") trackerColour("blue")
hslider bounds(20, 260, 350, 40) channel("AmpRelease") range(0.05, 0.1, 0.1, 1, 0.01) text("Release") trackerColour("blue")

; Env ADSR
groupbox bounds(10, 300, 380, 165) text("Env ADSR") outlineThickness(2)
hslider bounds(20, 330, 350, 40) channel("EnvAttack") range(0.001, 0.01, 0.01, 1, 0.01) text("Attack") trackerColour("blue")
hslider bounds(20, 380, 350, 40) channel("EnvDecay") range(0.01, 0.2, 0.05, 1, 0.01) text("Decay") trackerColour("blue")
hslider bounds(20, 430, 350, 40) channel("EnvRelease") range(0.01, 1, 0.1, 1, 0.01) text("Release") trackerColour("blue")

; The rest of the controls are shifted down to accommodate the new ADSR controls
hslider bounds(10, 480, 380, 40) channel("LFO") range(0.1, 1, 0.5, 1, 0.01) text("LFO Speed") trackerColour("blue")
hslider bounds(10, 510, 380, 40) channel("LFODepth") range(0.1, 1, 0.5, 1, 0.01) text("LFO Depth") trackerColour("blue")
hslider bounds(10, 540, 380, 40) channel("Pitch") range(0.1, 1, 0.5, 1, 0.01) text("Pitch") trackerColour("blue")
hslider bounds(10, 570, 380, 40) channel("PWM") range(0.1, 1, 0.5, 1, 0.01) text("PWM") trackerColour("blue")
hslider bounds(10, 600, 380, 40) channel("HPF") range(0.1, 1, 0.5, 1, 0.01) text("HPF") trackerColour("blue")


signaldisplay bounds(10, 630, 380, 160), colour("green") displayType("waveform"), backgroundColour(0, 0, 0), zoom(-1), signalVariable("aOut"), channel("display")
</Cabbage>



<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>

<CsInstruments>
; Global variables
ksmps = 1024
nchnls = 2
0dbfs = 1

; Initialization instrument to set default states
instr Init
    chnset 0, "AutoTrigger"
endin

; Instrument to detect button presses and manage triggers
instr DetectTriggers
    kRainDropTrigger chnget "RainDropTrigger"
    if changed(kRainDropTrigger) == 1 && kRainDropTrigger == 1 then
        event "i", "RainSound", 0, 0.1, 0  ; Mode 0 for OneShot
        event "i", "SetOneShotColourON", 0, 0
        event "i", "SetOneShotColourOFF", 0.1, 0.1
    endif
    
    kRainNoiseTrigger chnget "RainNoiseTrigger"
    if changed(kRainNoiseTrigger) == 1 && kRainNoiseTrigger == 1 then
        event "i", "RainNoise", 0, 0.1, 0  ; Mode 0 for OneShot
        event "i", "SetOneShotColourON", 0, 0
        event "i", "SetOneShotColourOFF", 0.1, 0.1
    endif
    
endin

giMetroRate init 0.5  ; Initial metronome rate, will be updated dynamically


; Instrument for automatic, periodic triggering with immediate start
instr AutoTrigger
    kAutoTrigger chnget "AutoTrigger"
    
    ; Static variable to keep track of whether the initial sound has been triggered
    kInitSoundTriggered init 0
    
    ; Trigger the first RainSound event immediately if not already done
    if kAutoTrigger == 1 && kInitSoundTriggered == 0 then
        iRandDelay = 0.1 + rnd(0.5)  ; Random initial delay
        event "i", "RainSound", 0, iRandDelay, 1  ; Mode 1 for Auto
        event "i", "SetAutoColourON", 0, 0  ; Optionally set color to indicate ON state
        kInitSoundTriggered = 1  ; Mark that initial sound has been triggered
    endif
    
    ; Use a metronome to trigger subsequent RainSound events
    if kAutoTrigger == 1 then
        kMetro metro (giMetroRate)  ; Adjust the rate as needed
        if kMetro == 1 then
            iRandDelay = 0.1 + rnd(0.5)  ; Random delay for subsequent triggers
            event "i", "RainSound", 0, iRandDelay, 1  ; Mode 1 for Auto
        endif
    else
        kInitSoundTriggered = 0  ; Reset the trigger flag when AutoTrigger is turned off
        event "i", "SetAutoColourOFF", 0, 0  ; Optionally reset color to indicate OFF state
    endif
endin

; Instrument to generate raindrop sound
instr RainSound
    iMode = p4  ; Mode: 0 for OneShot, 1 for Auto
    iAmpAttack chnget "AmpAttack"
    iAmpDecay chnget "AmpDecay"
    iAmpRelease chnget "AmpRelease"
    
    iEnvAttack chnget "EnvAttack"
    iEnvDecay chnget "EnvDecay"
    iEnvRelease chnget "EnvRelease"
    
    kRainStrength chnget "RainStrength"
    kPitch chnget "Pitch"
    kPWM chnget "PWM"
    iHPF chnget "HPF"
    
    giMetroRate = 2 + rnd(3)  ; Update metronome rate for the next trigger
    
    ; AMP ADSR
    aAmpEnv madsr iAmpAttack, iAmpDecay, 0.1, iAmpRelease  
    
    ; Pitch Envelope ADSR - This envelope will directly influence the pitch modulation
    aPitchEnv madsr iEnvAttack, iEnvDecay, 0.5, iEnvRelease
  
    ; Base frequency for the pitch of the raindrop
    kBaseFreq = cpspch(8.00)
    
    ; Calculate pitch modulation
    kPitchModulation = (1 + (aPitchEnv - 1) * kPitch * 10)  ; Modulate pitch using the pitch envelope
    
    ; Oscillator for the tonal component of the raindrop, modulated by pitch envelope
    aTonal oscili aAmpEnv, kBaseFreq * kPitchModulation
    
    ; Mix tonal and noise components
    iHPF = 3000
    iHPFactor = 500
    
    kHPFFreq = iHPF * iHPFactor
    aHPF butterhp aTonal, kHPFFreq
    
    aOut = aTonal * kRainStrength * aHPF
    
    outs aOut, aOut
endin

instr RainNoise

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
i "Init" 0 1
i "DetectTriggers" 0 z
i "AutoTrigger" 0 z  ; This could be activated/deactivated based on the AutoTrigger button state
</CsScore>
</CsoundSynthesizer>
