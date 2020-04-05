module GalaxyBrain

include("lex.jl")
include("parse.jl")

export @bf_str

macro bf_str(program::String)
    instructions = filter((lex ∘ Vector{Char})(program)) do instruction
        return instruction isa AbstractBFInstruction
    end
    brainfuck_function = quote
        function (; input::Union{IO,AbstractString}="", output::IO=stdout,
                  index::Int=1, memory_size::Int=30000)
            memory = repeat([zero(UInt8)], memory_size)
            characters = input isa AbstractString ? IOBuffer(input) : input
        end
    end
    body = last(last(brainfuck_function.args).args).args
    append!(body, parse_instructions(Vector{AbstractBFInstruction}(instructions)))
    push!(body, :(return nothing))
    return esc(Base.remove_linenums!(brainfuck_function))
end

end
