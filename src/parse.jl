function parse_instructions(instructions::Vector{AbstractBFInstruction})
    expressions = Vector{Expr}()
    loops = Vector{Expr}()
    for (index, instruction) in enumerate(instructions)
        if instruction isa LoopEnd
            isempty(loops) && error("Loop close at $index does not have matching loop opening")
            expression = pop!(loops)
        else
            expression = parse(instruction)
        end
        if instruction isa LoopStart
            push!(loops, expression)
        elseif isempty(loops)
            push!(expressions, expression)
        else
            push!(last(last(loops).args).args, expression)
        end
    end
    return expressions
end

Base.parse(::Increment) = :(memory[index] += one(UInt8))
Base.parse(::Decrement) = :(memory[index] -= one(UInt8))
Base.parse(::RightShift) = :(index += 1)
Base.parse(::LeftShift) = :(index -= 1)
Base.parse(::Write) = :(print(output, Char(memory[index])))
Base.parse(::Read) = :(memory[index] = eof(characters) ? memory[index] : first(read(characters, 1)))
Base.parse(::LoopStart) = :(while !iszero(memory[index]) end)
