using GalaxyBrain, Test

buffer = IOBuffer()

@testset "Hello World!" begin
    bf"""
    [This program prints "Hello World!\n" and requires no external input.]

    Set loop to 8 iterations
    ++++++++

    Add base character values
    [>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]

    Seek and print output
    >>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
    """(; output=buffer)

    @test String(take!(buffer)) == "Hello World!\n"
end

@testset "ROT13" begin
    rot13 = bf"""
    [This program enciphers ASCII input with an ROT13 cipher.]
    -,+[
        -[
            >>++++[>++++++++<-]
            <+<-[>+>+>-[>>>]<[[>+<-]>>+>]<<<<<-]
         ]
        >>>[-]+
        >--[-[<->+++[-]]]
        <[
            ++++++++++++
            <[>-[>+>>]>[+[<+>-]>+>>]<<<<<-]
            >>[<+>-]
            >[-[-<<[-]>>]<<[<<->>-]>>]
            <<[<<+>>-]
         ]
        <[-]
        <.[-]
        <-,+
    ]
    """

    rot13(; input="Sphinx of black quartz, judge my vow.", output=buffer)
    @test String(take!(buffer)) == "Fcuvak bs oynpx dhnegm, whqtr zl ibj."

    rot13(; input="Fcuvak bs oynpx dhnegm, whqtr zl ibj.", output=buffer)
    @test String(take!(buffer)) == "Sphinx of black quartz, judge my vow."
end

@testset "Interpreter" begin
    interpret = bf"""
        [
            This is a BF interpreter written in BF.

            It expects a string, where the first part is a BF program
            and the second part is that program's input. The two parts are then
            joined by an exclamation point.

            The first time this test passed, it utterly broke me.

            This interpreter was created by Daniel B Cristofani. You can find
            this program, and other BF programs, here:

            http://www.hevanet.com/cristofd/brainfuck/
        ]
        >>>+[[-]>>[-]++>+>+++++++[<++++>>++<-]++>>+>+>+++++[>++>++++++<<-]+>>>,<
        ++[[>[->>]<[>>]<<-]<[<]<+>>[>]>[<+>-[[<+>-]>]<[[[-]<]++<-[<+++++++++>[<-
        >-]>>]>>]]<<]<]<[[<]>[[>]>>[>>]+[<<]<[<]<+>>-]>[>]+[->>]<<<<[[<<]<[<]+<<
        [+>+<<-[>-->+<<-[>+<[>>+<<-]]]>[<+>-]<]++>>-->[>]>>[>>]]<<[>>+<[[<]<]>[[
        <<]<[<]+[-<+>>-[<<+>++>-[<->[<<+>>-]]]<[>+<-]>]>[>]>]>[>>]>>]<<[>>+>>+>>
        ]<<[->>>>>>>>]<<[>.>>>>>>>]<<[>->>>>>]<<[>,>>>]<<[>+>]<<[+<<]<]=(oh no)=
    """

    condensed_rot13 = replace("""-,+[-[>>++++[>++++++++<-]<+<-[>+>+>-[>>>]<[[>+<
                              -]>>+>]<<<<<-]]>>>[-]+>--[-[<->+++[-]]]<[+++++++++
                              +++<[>-[>+>>]>[+[<+>-]>+>>]<<<<<-]>>[<+>-]>[-[-<<[
                              -]>>]<<[<<->>-]>>]<<[<<+>>-]]<[-]<.[-]<-,+]""",
                              r"\s+" => "")

    encrypted_text = "Fcuvak bs oynpx dhnegm, whqtr zl ibj."

    interpret(; input="$(condensed_rot13)!$encrypted_text", output=buffer)
    @test String(take!(buffer)) == "Sphinx of black quartz, judge my vow."

end
