abstract type AbstractInstruction end
abstract type AbstractBFInstruction end

const OP_CODES = Symbol.(['+', '-', '>', '<', '.', ',', '[', ']'])
const INSTRUCTIONS = (:Increment, :Decrement, :RightShift, :LeftShift, :Write, :Read, :LoopStart, :LoopEnd)

for (op_code, instruction) in zip(OP_CODES, INSTRUCTIONS)
    @eval begin
        struct $instruction <: AbstractBFInstruction end
        lex(::Val{Symbol($(string(op_code)))}) = $instruction()
    end
end

struct UnknownInstruction <: AbstractInstruction end
lex(::Val{x}) where {x} = UnknownInstruction()

lex(program::Vector{Char}) = @. lex(Val(Symbol(program)))
