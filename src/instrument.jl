type Instrument
  a::Time
  d::Time
  s::Amplitude
  r::Time
  poly::Int
  c::Int
  start_dur_freq::Tuple
  dsp::Function
  function Instrument(osc::Function, a::Time, d::Time, s::Amplitude, r::Time, poly::Int=8)
    @assert poly > 0
    k = 1.0/poly
    control = ntuple(poly) do _
      ([Inf, Inf], [0.0, 0.0], [0.0, 0.0])
    end
    dsp = mapreduce(+, 1:poly) do i
      k*adsr(control[i][1], control[i][2], a, d, s, r)*osc(control[i][3])
    end
    new(a, d, s, r, poly, 1, control, dsp)
  end
end

function next_slot(inst::Instrument)
  s = inst.start_dur_freq[inst.c]
  inst.c = mod1(inst.c + 1, inst.poly)
  s
end

function _playnote(engine::Engine, inst::Instrument, time::Time, pitch::Pitch, dur::Time)
  slot = next_slot(inst)
  fill!(slot[1], time)
  fill!(slot[2], dur)
  fill!(slot[3], pitch_to_freq(pitch))
  time
end

function playnote₀(engine::Engine, inst::Instrument, time::Time, pitch::Pitch, dur::Time)
  schedule₀(engine, time, _playnote, [engine, inst, time, pitch, dur])
end

function playnote(engine::Engine, inst::Instrument, time::Time, pitch::Pitch, dur::Time)
  playnote₀(engine, inst, now(engine) + time, pitch, dur)
end
