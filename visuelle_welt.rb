# Welcome to Sonic Pi v2.11.1

chrd_cutoff = 120
hh_total = 0
hh_vol = hh_total * 1*1
hh_open_vol = hh_total * 1*1
bd_vol = 0.5*1.5*0
rnd_high_vol = 0.4*1
pent_vol = 1*0
rnd_low_vol = 0
chrd_vol = 0
bass_vol = 2*0
piano_vol = 0.5*0
salvation_vol = 1.5*0
welt_vol = 1

high_synth_id = 1
high_synth = [:beep, :tri, :chipbass, :pretty_bell][high_synth_id]

salvation_break = true
slice_voice = true

rnd_high_release_rand_max = 0.5

use_bpm 120

with_fx :reverb, mix: 0.5, room: 0.5 do
  with_fx :flanger, mix: 0.5, delay: 0.5 do
    live_loop :random_walk do
      cue :bd
      use_synth :beep
      play_pattern_timed scale(:Cs3, :minor_pentatonic), 2*0.125, release: 0.05, amp: 0.5*pent_vol, attack: 0.04
    end
  end
end

live_loop :rnd_high do
  cue :bd
  use_synth high_synth
  with_fx :reverb, mix: 1, room: 1 do
    with_fx :flanger, mix: 0.4, delay: 0.5 do
      with_fx :echo, mix: 0.5, phase: 3.0/4.0, decay: 10 do
        8.times do
          if rnd_high_vol>0
            play chord(:E4, :major).choose, release: rrand(0,rnd_high_release_rand_max), amp: 1*rnd_high_vol, attack: 0.01
            play chord(:Cs5, :minor).choose, release: rrand(0,rnd_high_release_rand_max), amp: 1*rnd_high_vol, attack: 0.01
            play chord(:Gs4, :minor).choose, release: rrand(0,rnd_high_release_rand_max), amp: 1*rnd_high_vol, attack: 0.01
          end
          #sleep 1.0/3.0
          #sleep [0.25, 0.125, 1.0/3.0].choose
          sleep [1, 2,3.0].choose
        end
      end
    end
  end
end

live_loop :rnd_low do
  cue :bd
  use_synth :tri
  play chord(:E2, :major).choose, release: rrand(0,0.3), amp: 1*rnd_low_vol, attack: 0.01
  sleep 1.0/3.0
end

live_loop :bass do
  cue :bd
  use_synth :fm
  play [:Cs2, :E2].choose, release: 6, amp: 1.5*bass_vol, attack: 0
  sleep 6
  play :Ds2, release: 2, amp: 1.5*bass_vol, attack: 0
  sleep 2
  play [:Cs2, :E2].choose, release: 6, amp: 1.5*bass_vol, attack: 0
  sleep 5
  play :Ds2, release: 2, amp: 1*bass_vol, attack: 0
  sleep 3
  play :E2, release: 6, amp: 1.5*bass_vol, attack: 0
  sleep 6
  play :Ds2, release: 2, amp: 1.5*bass_vol, attack: 0
  sleep 2
  play :E2, release: 6, amp: 1*bass_vol, attack: 0
  sleep 5
  play [:Fs2, :Gs2].choose, release: 2, amp: 1*bass_vol, attack: 0
  sleep 3
end

with_fx :panslicer, mix: 0.3, rate: 1 do
  live_loop :chrd do
    cue :bd
    play chord(:Cs4, :minor), attack: 0, release: 10, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 8
    play chord(:Cs4, :minor), attack: 0, release: 10, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 6+2/4.0
    play chord(:E4, :major), attack: 0, release: 2, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 1+2/4.0
    play chord(:Cs4, :minor), attack: 0, release: 10, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 8
    play chord(:Cs4, :minor), attack: 0, release: 10, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 6.5
    play chord([:Gs4,:Fs4].choose, :minor), attack: 0, release: 2, cutoff: chrd_cutoff, amp: 1.0*chrd_vol
    sleep 1.5
  end
end


#with_fx :lpf, mix: 1, cutoff: 120 do
live_loop :bd do
  sample :bd_klub, amp: 5*bd_vol
  sleep 1
end
#end

with_fx :reverb, room: 0.1, mix: 0.5 do
  live_loop :hh do
    cue :bd
    1.times do
      sample :drum_cymbal_closed, amp: 0.7*hh_vol*rrand(0.9,1.1), attack: 0.01
      sleep 1/4.0+rrand(-0.01,0.01)
      sample :drum_cymbal_closed, amp: 0.8*hh_vol*rrand(0.9,1.1), attack: 0.01
      sleep 1/4.0+rrand(-0.01,0.01)
      sample :drum_cymbal_open, amp: 0.25*hh_open_vol*rrand(0.9,1.1), attack: 0.01
      sleep 1/4.0+rrand(-0.01,0.01)
      sample :drum_cymbal_closed, amp: 0.8*hh_vol*rrand(0.9,1.1), attack: 0.01
      sleep 1/4.0+rrand(-0.01,0.01)
    end
  end
end

live_loop :welt do
  cue :bd
  with_fx :reverb, mix: 0.4, room: 1 do
    with_fx :echo, mix: 0.2, decay: 10, phase: 8.0/4.0,max_phase: 20 do
      with_fx :panslicer, mix: 0.3, rate: 4 do
        with_fx :hpf, mix: 1, cutoff: 80 do
          sleep 64
          sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/visuelle_welt.wav", amp: 4*welt_vol
          sleep 64
        end
      end
    end
  end
end

with_fx :reverb, mix: 0.4, room: 1 do
  with_fx :panslicer, mix: 0.3, phase: 0.5 do
    live_loop :piano do
      sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/salvation_piano_4bars.wav", slice: rand_i(16), rate: -1, amp: 1.0*piano_vol
      sleep 1
    end
  end
end


with_fx :echo, mix: 0.8, phase: 3.0/4.0,  decay: 10 do
  live_loop :salvation do
    #slice_idx = rand_i(16)
    #sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/my_salvation.wav", slice: slice_idx
    # sleep 12
    if not salvation_break
      if slice_voice
        sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/my_salvation.wav", rate: -1, slice: rand_i(4), num_slices: 4, amp: 1.0*salvation_vol
      else
        with_fx :hpf, mix: 1, cutoff: 80 do
          sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/my_salvation.wav", rate: 1, amp: 1.0*salvation_vol
        end
        sleep 8
      end
    else
      with_fx :hpf, mix: 1, cutoff: 80 do
        if slice_voice
          sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/ouh.wav", rate: -1, slice: rand_i(5), num_slices: 5, amp: 1.0*salvation_vol
        else
          sample "/Users/bfmaier/Music/sonic_pi/diese_visuelle_welt/ouh.wav", rate: 1, amp: 1.0*salvation_vol
          sleep 8
        end
      end
    end
    sleep 8
  end
end