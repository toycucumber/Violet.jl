module Violet

using Reactive

include("types.jl")
include("utils.jl")

include("config.jl")

include("PortAudio.jl")
using Violet.PortAudio

Violet.PortAudio.initialize()
atexit(Violet.PortAudio.terminate)

include("ecs.jl")
include("ui.jl")

include("control.jl")
include("event.jl")
include("node.jl")
include("audio.jl")
include("engine.jl")
include("oscillators.jl")
include("envelopes.jl")
include("swapper.jl")

include("exports.jl")

end # module
