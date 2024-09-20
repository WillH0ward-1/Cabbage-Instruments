<Cabbage>
form caption("AcousticSim") size(400, 300), guiMode("queue") pluginId("def1")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1

a1, a2 ins

aSig = (a1 + a2) * 0.5

outs aSig, aSig

endin

</CsInstruments>
<CsScore>
f0 z 
i1 0 z
</CsScore>
</CsoundSynthesizer>