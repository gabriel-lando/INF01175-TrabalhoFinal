

 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /memoria_output_tb/status
      waveform add -signals /memoria_output_tb/memoria_output_synth_inst/bmg_port/CLKA
      waveform add -signals /memoria_output_tb/memoria_output_synth_inst/bmg_port/ADDRA
      waveform add -signals /memoria_output_tb/memoria_output_synth_inst/bmg_port/DINA
      waveform add -signals /memoria_output_tb/memoria_output_synth_inst/bmg_port/WEA
      waveform add -signals /memoria_output_tb/memoria_output_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
