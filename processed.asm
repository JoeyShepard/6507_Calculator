 PAGE $0
 ORG $1FFC
 FDB main
 ORG $0
 ORG $20
 
dummy:
 DFS $1
 
ret_val:
 DFS $2
 
screen_ptr:
 DFS $2
 
R0:
 DFS $9
 
R1:
 DFS $9
 
R2:
 DFS $9
 
R3:
 DFS $9
 
R4:
 DFS $9
 
R5:
 DFS $9
 
R6:
 DFS $9
 
R7:
 DFS $9

STACK_END:
 ORG $130
 
global_error:
 DFS $1
 
input_buff_begin:
 DFS $1
 
input_buff_end:
 DFS $1
 
input_buff:
 DFS $40
 
new_word_len:
 DFS $1
 
new_word_buff:
 DFS $13
 
new_stack_item:
 DFS $9
 
font_inverted:
 DFS $1
 
stack_count:
 DFS $1
 
test_count:
 DFS $1
 ORG $C000
 
DebugText:
 LDY #$0
 .loop:
 LDA ($A),Y ;msg
 BEQ .done
 STA $FFE7
 INY
 JMP .loop
 .done:
 RTS
 
halt_test:
 LDA dummy
 CMP test_count
 BNE .done
 BRK
 BRK
 .done:
 RTS
 
InputTest:
 LDY #$0
 .loop:
 LDA ($3),Y ;input
 BEQ .loop_done
 CMP #$2D
 BNE .not_minus
 LDA #$63
 .not_minus:
 STA new_word_buff,Y
 INY
 JMP .loop
 .loop_done:
 STY new_word_len
 JSR CheckData
 LDY #$0
 STY $8 ;calculated_index
 STY $7 ;output_index
 .check_loop:
 LDY $7 ;output_index
 LDA ($5),Y ;output
 CMP #$41
 BCS .letter
 SEC
 SBC #$30
 JMP .letter_done
 .letter:
 SEC
 SBC #$37
 .letter_done:
 ASL
 ASL
 ASL
 ASL
 STA $9 ;value
 INY
 LDA ($5),Y ;output
 CMP #$41
 BCS .letter2
 SEC
 SBC #$30
 JMP .letter_done2
 .letter2:
 SEC
 SBC #$37
 .letter_done2:
 ORA $9 ;value
 STA $9 ;value
 INY
 STY $7 ;output_index
 LDY $8 ;calculated_index
 LDA new_stack_item,Y
 CMP $9 ;value
 BNE .failed
 INY
 STY $8 ;calculated_index
 LDY $7 ;output_index
 LDA ($5),Y ;output
 BNE .continue
 JMP .done
 .continue:
 INY
 STY $7 ;output_index
 JMP .check_loop
 .failed:
 JMP .._53.str_skip
 .._53.str_addr:
 FCB "\\rTest ",$0
 .._53.str_skip:
 LDA # (.._53.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._53.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 LDX test_count+$1
 LDA test_count
 STA $FFEA
 JMP .._77.str_skip
 .._77.str_addr:
 FCB ": FAILED!\\n",$0
 .._77.str_skip:
 LDA # (.._77.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._77.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 JMP .._101.str_skip
 .._101.str_addr:
 FCB "   Expected: ",$0
 .._101.str_skip:
 LDA # (.._101.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._101.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 LDA $5 ;output
 STA $A ;DebugText.msg
 LDA $6 ;output
 STA $B ;DebugText.msg
 JSR DebugText
 JMP .._153.str_skip
 .._153.str_addr:
 FCB "\\n   Found:    ",$0
 .._153.str_skip:
 LDA # (.._153.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._153.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 LDY #$0
 STY $8 ;calculated_index
 LDY #$2
 STY $7 ;output_index
 .fail_loop:
 LDY $8 ;calculated_index
 LDA new_stack_item,Y
 STA $FFE8
 LDA #$20
 STA $FFE7
 INY
 STY $8 ;calculated_index
 LDY $7 ;output_index
 LDA ($5),Y ;output
 BEQ .fail_done
 INY
 INY
 INY
 STY $7 ;output_index
 JMP .fail_loop
 .fail_done:
 BRK
 BRK
 LDA new_stack_item
 JMP .failed
 .done:
 JMP .._178.str_skip
 .._178.str_addr:
 FCB "\\gTest ",$0
 .._178.str_skip:
 LDA # (.._178.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._178.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 LDX test_count+$1
 LDA test_count
 STA $FFEA
 JMP .._202.str_skip
 .._202.str_addr:
 FCB ": passed\\n",$0
 .._202.str_skip:
 LDA # (.._202.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._202.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 INC test_count
 BNE .._223.no_carry
 INC test_count+$1
 .._223.no_carry:
 RTS
 
tests:
 LDA #$1
 STA test_count
 JMP .._232.str_skip
 .._232.str_addr:
 FCB "5",$0
 .._232.str_skip:
 LDA # (.._232.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._232.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._241.str_skip
 .._241.str_addr:
 FCB "01 00 00 00 00 00 50 00 00",$0
 .._241.str_skip:
 LDA # (.._241.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._241.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._259.str_skip
 .._259.str_addr:
 FCB "500",$0
 .._259.str_skip:
 LDA # (.._259.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._259.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._268.str_skip
 .._268.str_addr:
 FCB "01 00 00 00 00 00 50 02 00",$0
 .._268.str_skip:
 LDA # (.._268.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._268.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._286.str_skip
 .._286.str_addr:
 FCB "500",$0
 .._286.str_skip:
 LDA # (.._286.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._286.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._295.str_skip
 .._295.str_addr:
 FCB "01 00 00 00 00 00 50 02 00",$0
 .._295.str_skip:
 LDA # (.._295.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._295.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._313.str_skip
 .._313.str_addr:
 FCB "500.0",$0
 .._313.str_skip:
 LDA # (.._313.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._313.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._322.str_skip
 .._322.str_addr:
 FCB "01 00 00 00 00 00 50 02 00",$0
 .._322.str_skip:
 LDA # (.._322.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._322.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._340.str_skip
 .._340.str_addr:
 FCB "500.00",$0
 .._340.str_skip:
 LDA # (.._340.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._340.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._349.str_skip
 .._349.str_addr:
 FCB "01 00 00 00 00 00 50 02 00",$0
 .._349.str_skip:
 LDA # (.._349.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._349.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._367.str_skip
 .._367.str_addr:
 FCB "5e0",$0
 .._367.str_skip:
 LDA # (.._367.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._367.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._376.str_skip
 .._376.str_addr:
 FCB "01 00 00 00 00 00 50 00 00",$0
 .._376.str_skip:
 LDA # (.._376.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._376.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._394.str_skip
 .._394.str_addr:
 FCB "500e0",$0
 .._394.str_skip:
 LDA # (.._394.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._394.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._403.str_skip
 .._403.str_addr:
 FCB "01 00 00 00 00 00 50 02 00",$0
 .._403.str_skip:
 LDA # (.._403.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._403.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._421.str_skip
 .._421.str_addr:
 FCB "500e2",$0
 .._421.str_skip:
 LDA # (.._421.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._421.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._430.str_skip
 .._430.str_addr:
 FCB "01 00 00 00 00 00 50 04 00",$0
 .._430.str_skip:
 LDA # (.._430.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._430.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._448.str_skip
 .._448.str_addr:
 FCB "500e997",$0
 .._448.str_skip:
 LDA # (.._448.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._448.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._457.str_skip
 .._457.str_addr:
 FCB "01 00 00 00 00 00 50 99 09",$0
 .._457.str_skip:
 LDA # (.._457.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._457.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._475.str_skip
 .._475.str_addr:
 FCB "500e998",$0
 .._475.str_skip:
 LDA # (.._475.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._475.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._484.str_skip
 .._484.str_addr:
 FCB "04",$0
 .._484.str_skip:
 LDA # (.._484.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._484.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._502.str_skip
 .._502.str_addr:
 FCB "-5",$0
 .._502.str_skip:
 LDA # (.._502.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._502.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._511.str_skip
 .._511.str_addr:
 FCB "01 00 00 00 00 00 50 00 80",$0
 .._511.str_skip:
 LDA # (.._511.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._511.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._529.str_skip
 .._529.str_addr:
 FCB "-500",$0
 .._529.str_skip:
 LDA # (.._529.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._529.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._538.str_skip
 .._538.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._538.str_skip:
 LDA # (.._538.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._538.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._556.str_skip
 .._556.str_addr:
 FCB "-500e997",$0
 .._556.str_skip:
 LDA # (.._556.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._556.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._565.str_skip
 .._565.str_addr:
 FCB "01 00 00 00 00 00 50 99 89",$0
 .._565.str_skip:
 LDA # (.._565.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._565.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._583.str_skip
 .._583.str_addr:
 FCB "0.05",$0
 .._583.str_skip:
 LDA # (.._583.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._583.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._592.str_skip
 .._592.str_addr:
 FCB "01 00 00 00 00 00 50 02 40",$0
 .._592.str_skip:
 LDA # (.._592.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._592.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._610.str_skip
 .._610.str_addr:
 FCB "0.05e2",$0
 .._610.str_skip:
 LDA # (.._610.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._610.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._619.str_skip
 .._619.str_addr:
 FCB "01 00 00 00 00 00 50 00 00",$0
 .._619.str_skip:
 LDA # (.._619.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._619.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._637.str_skip
 .._637.str_addr:
 FCB "0.05e1",$0
 .._637.str_skip:
 LDA # (.._637.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._637.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._646.str_skip
 .._646.str_addr:
 FCB "01 00 00 00 00 00 50 01 40",$0
 .._646.str_skip:
 LDA # (.._646.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._646.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._664.str_skip
 .._664.str_addr:
 FCB "0.05e3",$0
 .._664.str_skip:
 LDA # (.._664.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._664.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._673.str_skip
 .._673.str_addr:
 FCB "01 00 00 00 00 00 50 01 00",$0
 .._673.str_skip:
 LDA # (.._673.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._673.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._691.str_skip
 .._691.str_addr:
 FCB "0.05e-2",$0
 .._691.str_skip:
 LDA # (.._691.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._691.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._700.str_skip
 .._700.str_addr:
 FCB "01 00 00 00 00 00 50 04 40",$0
 .._700.str_skip:
 LDA # (.._700.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._700.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._718.str_skip
 .._718.str_addr:
 FCB "5e-0",$0
 .._718.str_skip:
 LDA # (.._718.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._718.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._727.str_skip
 .._727.str_addr:
 FCB "01 00 00 00 00 00 50 00 00",$0
 .._727.str_skip:
 LDA # (.._727.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._727.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._745.str_skip
 .._745.str_addr:
 FCB "5e-2",$0
 .._745.str_skip:
 LDA # (.._745.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._745.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._754.str_skip
 .._754.str_addr:
 FCB "01 00 00 00 00 00 50 02 40",$0
 .._754.str_skip:
 LDA # (.._754.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._754.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._772.str_skip
 .._772.str_addr:
 FCB "0.05e-997",$0
 .._772.str_skip:
 LDA # (.._772.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._772.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._781.str_skip
 .._781.str_addr:
 FCB "01 00 00 00 00 00 50 99 49",$0
 .._781.str_skip:
 LDA # (.._781.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._781.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._799.str_skip
 .._799.str_addr:
 FCB "0.05e-998",$0
 .._799.str_skip:
 LDA # (.._799.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._799.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._808.str_skip
 .._808.str_addr:
 FCB "04",$0
 .._808.str_skip:
 LDA # (.._808.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._808.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._826.str_skip
 .._826.str_addr:
 FCB "0.05e101",$0
 .._826.str_skip:
 LDA # (.._826.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._826.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._835.str_skip
 .._835.str_addr:
 FCB "01 00 00 00 00 00 50 99 00",$0
 .._835.str_skip:
 LDA # (.._835.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._835.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._853.str_skip
 .._853.str_addr:
 FCB "0.05e99",$0
 .._853.str_skip:
 LDA # (.._853.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._853.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._862.str_skip
 .._862.str_addr:
 FCB "01 00 00 00 00 00 50 97 00",$0
 .._862.str_skip:
 LDA # (.._862.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._862.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._880.str_skip
 .._880.str_addr:
 FCB "500e99",$0
 .._880.str_skip:
 LDA # (.._880.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._880.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._889.str_skip
 .._889.str_addr:
 FCB "01 00 00 00 00 00 50 01 01",$0
 .._889.str_skip:
 LDA # (.._889.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._889.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._907.str_skip
 .._907.str_addr:
 FCB "500e97",$0
 .._907.str_skip:
 LDA # (.._907.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._907.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._916.str_skip
 .._916.str_addr:
 FCB "01 00 00 00 00 00 50 99 00",$0
 .._916.str_skip:
 LDA # (.._916.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._916.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._934.str_skip
 .._934.str_addr:
 FCB "500e98",$0
 .._934.str_skip:
 LDA # (.._934.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._934.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._943.str_skip
 .._943.str_addr:
 FCB "01 00 00 00 00 00 50 00 01",$0
 .._943.str_skip:
 LDA # (.._943.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._943.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._961.str_skip
 .._961.str_addr:
 FCB "0.05e102",$0
 .._961.str_skip:
 LDA # (.._961.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._961.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._970.str_skip
 .._970.str_addr:
 FCB "01 00 00 00 00 00 50 00 01",$0
 .._970.str_skip:
 LDA # (.._970.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._970.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._988.str_skip
 .._988.str_addr:
 FCB "1.23456789012",$0
 .._988.str_skip:
 LDA # (.._988.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._988.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._997.str_skip
 .._997.str_addr:
 FCB "01 12 90 78 56 34 12 00 00",$0
 .._997.str_skip:
 LDA # (.._997.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._997.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1015.str_skip
 .._1015.str_addr:
 FCB "12345.6789012",$0
 .._1015.str_skip:
 LDA # (.._1015.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1015.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1024.str_skip
 .._1024.str_addr:
 FCB "01 12 90 78 56 34 12 04 00",$0
 .._1024.str_skip:
 LDA # (.._1024.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1024.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1042.str_skip
 .._1042.str_addr:
 FCB "1.23456789012e10",$0
 .._1042.str_skip:
 LDA # (.._1042.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1042.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1051.str_skip
 .._1051.str_addr:
 FCB "01 12 90 78 56 34 12 10 00",$0
 .._1051.str_skip:
 LDA # (.._1051.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1051.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1069.str_skip
 .._1069.str_addr:
 FCB "e",$0
 .._1069.str_skip:
 LDA # (.._1069.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1069.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1078.str_skip
 .._1078.str_addr:
 FCB "04",$0
 .._1078.str_skip:
 LDA # (.._1078.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1078.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1096.str_skip
 .._1096.str_addr:
 FCB ".",$0
 .._1096.str_skip:
 LDA # (.._1096.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1096.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1105.str_skip
 .._1105.str_addr:
 FCB "04",$0
 .._1105.str_skip:
 LDA # (.._1105.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1105.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1123.str_skip
 .._1123.str_addr:
 FCB ".e",$0
 .._1123.str_skip:
 LDA # (.._1123.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1123.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1132.str_skip
 .._1132.str_addr:
 FCB "04",$0
 .._1132.str_skip:
 LDA # (.._1132.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1132.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1150.str_skip
 .._1150.str_addr:
 FCB "-500",$0
 .._1150.str_skip:
 LDA # (.._1150.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1150.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1159.str_skip
 .._1159.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1159.str_skip:
 LDA # (.._1159.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1159.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1177.str_skip
 .._1177.str_addr:
 FCB "-500",$0
 .._1177.str_skip:
 LDA # (.._1177.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1177.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1186.str_skip
 .._1186.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1186.str_skip:
 LDA # (.._1186.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1186.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1204.str_skip
 .._1204.str_addr:
 FCB "-500",$0
 .._1204.str_skip:
 LDA # (.._1204.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1204.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1213.str_skip
 .._1213.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1213.str_skip:
 LDA # (.._1213.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1213.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1231.str_skip
 .._1231.str_addr:
 FCB "-500",$0
 .._1231.str_skip:
 LDA # (.._1231.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1231.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1240.str_skip
 .._1240.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1240.str_skip:
 LDA # (.._1240.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1240.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1258.str_skip
 .._1258.str_addr:
 FCB "-500",$0
 .._1258.str_skip:
 LDA # (.._1258.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1258.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1267.str_skip
 .._1267.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1267.str_skip:
 LDA # (.._1267.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1267.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1285.str_skip
 .._1285.str_addr:
 FCB "-500",$0
 .._1285.str_skip:
 LDA # (.._1285.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1285.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1294.str_skip
 .._1294.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1294.str_skip:
 LDA # (.._1294.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1294.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1312.str_skip
 .._1312.str_addr:
 FCB "-500",$0
 .._1312.str_skip:
 LDA # (.._1312.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1312.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1321.str_skip
 .._1321.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1321.str_skip:
 LDA # (.._1321.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1321.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1339.str_skip
 .._1339.str_addr:
 FCB "-500",$0
 .._1339.str_skip:
 LDA # (.._1339.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1339.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1348.str_skip
 .._1348.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1348.str_skip:
 LDA # (.._1348.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1348.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1366.str_skip
 .._1366.str_addr:
 FCB "-500",$0
 .._1366.str_skip:
 LDA # (.._1366.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1366.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1375.str_skip
 .._1375.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1375.str_skip:
 LDA # (.._1375.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1375.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1393.str_skip
 .._1393.str_addr:
 FCB "-500",$0
 .._1393.str_skip:
 LDA # (.._1393.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1393.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1402.str_skip
 .._1402.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1402.str_skip:
 LDA # (.._1402.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1402.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1420.str_skip
 .._1420.str_addr:
 FCB "-500",$0
 .._1420.str_skip:
 LDA # (.._1420.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1420.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1429.str_skip
 .._1429.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1429.str_skip:
 LDA # (.._1429.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1429.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1447.str_skip
 .._1447.str_addr:
 FCB "-500",$0
 .._1447.str_skip:
 LDA # (.._1447.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1447.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1456.str_skip
 .._1456.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1456.str_skip:
 LDA # (.._1456.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1456.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1474.str_skip
 .._1474.str_addr:
 FCB "-500",$0
 .._1474.str_skip:
 LDA # (.._1474.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1474.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1483.str_skip
 .._1483.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1483.str_skip:
 LDA # (.._1483.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1483.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1501.str_skip
 .._1501.str_addr:
 FCB "-500",$0
 .._1501.str_skip:
 LDA # (.._1501.str_addr) # $100
 STA $3 ;InputTest.input
 LDA # (.._1501.str_addr)/$100
 STA $4 ;InputTest.input
 JMP .._1510.str_skip
 .._1510.str_addr:
 FCB "01 00 00 00 00 00 50 02 80",$0
 .._1510.str_skip:
 LDA # (.._1510.str_addr) # $100
 STA $5 ;InputTest.output
 LDA # (.._1510.str_addr)/$100
 STA $6 ;InputTest.output
 JSR InputTest
 JMP .._1528.str_skip
 .._1528.str_addr:
 FCB "\\n\\gAll tests passed",$0
 .._1528.str_skip:
 LDA # (.._1528.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._1528.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 JMP .._1547.str_skip
 .._1547.str_addr:
 FCB "\\n\\lSize of code: ",$0
 .._1547.str_skip:
 LDA # (.._1547.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._1547.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 LDX # (code_end-code_begin)/$100
 LDA # (code_end-code_begin)#$100
 STA $FFEA
 JMP .._1566.str_skip
 .._1566.str_addr:
 FCB " bytes",$0
 .._1566.str_skip:
 LDA # (.._1566.str_addr) # $100
 STA $A ;DebugText.msg
 LDA # (.._1566.str_addr)/$100
 STA $B ;DebugText.msg
 JSR DebugText
 RTS
 ORG $900
 
code_begin:
 JMP main
 
font_table:
 FCB $0,$0,$0,$0,$0,$0,$0,$0
 FCB $30,$78,$78,$30,$30,$0,$30,$0
 FCB $6C,$6C,$6C,$0,$0,$0,$0,$0
 FCB $6C,$6C,$FE,$6C,$FE,$6C,$6C,$0
 FCB $30,$7C,$C0,$78,$C,$F8,$30,$0
 FCB $0,$C6,$CC,$18,$30,$66,$C6,$0
 FCB $38,$6C,$38,$76,$DC,$CC,$76,$0
 FCB $60,$60,$C0,$0,$0,$0,$0,$0
 FCB $18,$30,$60,$60,$60,$30,$18,$0
 FCB $60,$30,$18,$18,$18,$30,$60,$0
 FCB $0,$66,$3C,$FF,$3C,$66,$0,$0
 FCB $0,$30,$30,$FC,$30,$30,$0,$0
 FCB $0,$0,$0,$0,$0,$30,$30,$60
 FCB $0,$0,$0,$FC,$0,$0,$0,$0
 FCB $0,$0,$0,$0,$0,$30,$30,$0
 FCB $6,$C,$18,$30,$60,$C0,$80,$0
 FCB $7C,$C6,$CE,$DE,$F6,$E6,$7C,$0
 FCB $30,$70,$30,$30,$30,$30,$FC,$0
 FCB $78,$CC,$C,$38,$60,$CC,$FC,$0
 FCB $78,$CC,$C,$38,$C,$CC,$78,$0
 FCB $1C,$3C,$6C,$CC,$FE,$C,$1E,$0
 FCB $FC,$C0,$F8,$C,$C,$CC,$78,$0
 FCB $38,$60,$C0,$F8,$CC,$CC,$78,$0
 FCB $FC,$CC,$C,$18,$30,$30,$30,$0
 FCB $78,$CC,$CC,$78,$CC,$CC,$78,$0
 FCB $78,$CC,$CC,$7C,$C,$18,$70,$0
 FCB $0,$30,$30,$0,$0,$30,$30,$0
 FCB $0,$30,$30,$0,$0,$30,$30,$60
 FCB $18,$30,$60,$C0,$60,$30,$18,$0
 FCB $0,$0,$FC,$0,$0,$FC,$0,$0
 FCB $60,$30,$18,$C,$18,$30,$60,$0
 FCB $78,$CC,$C,$18,$30,$0,$30,$0
 FCB $7C,$C6,$DE,$DE,$DE,$C0,$78,$0
 FCB $30,$78,$CC,$CC,$FC,$CC,$CC,$0
 FCB $FC,$66,$66,$7C,$66,$66,$FC,$0
 FCB $3C,$66,$C0,$C0,$C0,$66,$3C,$0
 FCB $F8,$6C,$66,$66,$66,$6C,$F8,$0
 FCB $FE,$62,$68,$78,$68,$62,$FE,$0
 FCB $FE,$62,$68,$78,$68,$60,$F0,$0
 FCB $3C,$66,$C0,$C0,$CE,$66,$3E,$0
 FCB $CC,$CC,$CC,$FC,$CC,$CC,$CC,$0
 FCB $78,$30,$30,$30,$30,$30,$78,$0
 FCB $1E,$C,$C,$C,$CC,$CC,$78,$0
 FCB $E6,$66,$6C,$78,$6C,$66,$E6,$0
 FCB $F0,$60,$60,$60,$62,$66,$FE,$0
 FCB $C6,$EE,$FE,$FE,$D6,$C6,$C6,$0
 FCB $C6,$E6,$F6,$DE,$CE,$C6,$C6,$0
 FCB $38,$6C,$C6,$C6,$C6,$6C,$38,$0
 FCB $FC,$66,$66,$7C,$60,$60,$F0,$0
 FCB $78,$CC,$CC,$CC,$DC,$78,$1C,$0
 FCB $FC,$66,$66,$7C,$6C,$66,$E6,$0
 FCB $78,$CC,$E0,$70,$1C,$CC,$78,$0
 FCB $FC,$B4,$30,$30,$30,$30,$78,$0
 FCB $CC,$CC,$CC,$CC,$CC,$CC,$FC,$0
 FCB $CC,$CC,$CC,$CC,$CC,$78,$30,$0
 FCB $C6,$C6,$C6,$D6,$FE,$EE,$C6,$0
 FCB $C6,$C6,$6C,$38,$38,$6C,$C6,$0
 FCB $CC,$CC,$CC,$78,$30,$30,$78,$0
 FCB $FE,$C6,$8C,$18,$32,$66,$FE,$0
 FCB $78,$60,$60,$60,$60,$60,$78,$0
 FCB $C0,$60,$30,$18,$C,$6,$2,$0
 FCB $78,$18,$18,$18,$18,$18,$78,$0
 FCB $10,$38,$6C,$C6,$0,$0,$0,$0
 FCB $0,$0,$0,$0,$0,$0,$0,$FF
 FCB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 FCB $8,$18,$38,$78,$38,$18,$8,$0
 FCB $0,$0,$0,$0,$FF,$FF,$FF,$FF
 FCB $0,$1E,$0,$0,$0,$0,$0,$0
 FCB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 FCB $0,$0,$EE,$88,$EE,$88,$EE,$0
 
setup:
 SEI
 CLD
 LDX #$0
 STX stack_count
 LDA #$0
 STA font_inverted
 LDA #$4
 STA $FFE1
 LDA #$5
 STA $FFE2
 RTS
 
ReadKey:
 LDA $FFE4
 RTS
 
LCD_clrscr:
 LDA #$0
 STA screen_ptr
 LDA #$40
 STA screen_ptr+$1
 LDA #$80
 STA $3 ;counter
 LDA #$2A
 LDY #$0
 .loop:
 STA (screen_ptr),Y
 INY
 BNE .loop
 INC screen_ptr+$1
 DEC $3 ;counter
 BNE .loop
 LDA #$0
 STA screen_ptr
 LDA #$40
 STA screen_ptr+$1
 RTS
 
LCD_char:
 LDA $8 ;c_out
 CMP #$20
 BCC .._1668.skip
 JMP .if0
 .._1668.skip:
 RTS
 .if0:
 CMP #$66
 BCS .._1673.skip
 JMP .if1
 .._1673.skip:
 RTS
 .if1:
 SEC
 SBC #$20
 STA $9 ;pixel_ptr
 LDA #$0
 STA $A ;pixel_ptr
 ASL $9 ;pixel_ptr
 ASL $9 ;pixel_ptr
 ROL $A ;pixel_ptr
 ASL $9 ;pixel_ptr
 ROL $A ;pixel_ptr
 LDA #font_table # $100
 ADC $9 ;pixel_ptr
 STA $9 ;pixel_ptr
 LDA #font_table/$100
 ADC $A ;pixel_ptr
 STA $A ;pixel_ptr
 LDA #$0
 STA $B ;pixel_index
 LDA #$8
 STA $D ;lc1
 .loop:
 LDA #$8
 STA $E ;lc2
 LDY $B ;pixel_index
 INC $B ;pixel_index
 LDA ($9),Y ;pixel_ptr
 EOR font_inverted
 STA $C ;pixel
 LDY #$0
 .loop.inner:
 ROL $C ;pixel
 LDA #$0
 BCS .color
 LDA #$2A
 .color:
 STA (screen_ptr),Y
 INC screen_ptr+$1
 STA (screen_ptr),Y
 INY
 STA (screen_ptr),Y
 DEC screen_ptr+$1
 STA (screen_ptr),Y
 INY
 DEC $E ;lc2
 BNE .loop.inner
 INC screen_ptr+$1
 INC screen_ptr+$1
 DEC $D ;lc1
 BNE .loop
 CLC
 LDA screen_ptr
 ADC #$10
 STA screen_ptr
 SEC
 LDA screen_ptr+$1
 SBC #$10
 STA screen_ptr+$1
 RTS
 
LCD_print:
 LDA #$0
 STA $15 ;index
 .loop:
 LDY $15 ;index
 LDA ($13),Y ;source
 BEQ .done
 STA $16 ;arg
 LDA $16 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 INC $15 ;index
 JMP .loop
 .done:
 RTS
 
MemCopy:
 LDY #$0
 .loop:
 LDA ($3),Y ;source
 STA ($5),Y ;dest
 INY
 CPY $7 ;count
 BNE .loop
 RTS
 
BCD_Reverse:
 LDY #$0
 PHP
 SED
 SEC
 .loop:
 LDA #$0
 SBC ($15),Y ;source
 STA ($15),Y ;source
 INY
 DEC $17 ;count
 BNE .loop
 PLP
 RTS
 
DigitHigh:
 LDA $3 ;digit
 LSR
 LSR
 LSR
 LSR
 CLC
 ADC #$30
 STA $3 ;digit
 LDA $3 ;digit
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 RTS
 
DigitLow:
 LDA $3 ;digit
 AND #$F
 CLC
 ADC #$30
 STA $3 ;digit
 LDA $3 ;digit
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 RTS
 
DrawFloat:
 LDA $13 ;source
 STA $3 ;MemCopy.source
 LDA $14 ;source
 STA $4 ;MemCopy.source
 LDA # (R0) # $100
 STA $5 ;MemCopy.dest
 LDA # (R0)/$100
 STA $6 ;MemCopy.dest
 LDA #$9
 STA $7 ;MemCopy.count
 JSR MemCopy
 LDA #$20
 STA $17 ;sign
 LDY #$8
 LDA ($13),Y ;source
 AND #$80
 BEQ .positive
 LDA #$63
 STA $17 ;sign
 .positive:
 LDA $17 ;sign
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDY #$6
 LDA R0,Y
 STA $16 ;arg
 LDA $16 ;arg
 STA $3 ;DigitHigh.digit
 JSR DigitHigh
 LDA #$2E
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA $16 ;arg
 STA $3 ;DigitLow.digit
 JSR DigitLow
 LDA #$5
 STA $15 ;index
 .loop:
 LDY $15 ;index
 LDA R0,Y
 STA $16 ;arg
 LDA $16 ;arg
 STA $3 ;DigitHigh.digit
 JSR DigitHigh
 LDA $16 ;arg
 STA $3 ;DigitLow.digit
 JSR DigitLow
 DEC $15 ;index
 LDA $15 ;index
 CMP #$2
 BNE .loop
 LDA #$2B
 STA $17 ;sign
 LDY #$8
 LDA ($13),Y ;source
 AND #$40
 BEQ .positive_e
 LDA #$63
 STA $17 ;sign
 .positive_e:
 LDA $17 ;sign
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDY #$8
 LDA R0,Y
 STA $16 ;arg
 LDA $16 ;arg
 STA $3 ;DigitLow.digit
 JSR DigitLow
 LDY #$7
 LDA R0,Y
 STA $16 ;arg
 LDA $16 ;arg
 STA $3 ;DigitHigh.digit
 JSR DigitHigh
 LDA $16 ;arg
 STA $3 ;DigitLow.digit
 JSR DigitLow
 RTS
 
HexHigh:
 LDA $6 ;digit
 LSR
 LSR
 LSR
 LSR
 CMP #$A
 BCC .print_digit
 CLC
 ADC #$37
 STA $7 ;arg
 JMP .done
 .print_digit:
 CLC
 ADC #$30
 STA $7 ;arg
 .done:
 LDA $7 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 RTS
 
HexLow:
 LDA $6 ;digit
 AND #$F
 CMP #$A
 BCC .print_digit
 CLC
 ADC #$37
 STA $7 ;arg
 JMP .done
 .print_digit:
 CLC
 ADC #$30
 STA $7 ;arg
 .done:
 LDA $7 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 RTS
 
DrawHex:
 LDA #$24
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDY #$2
 LDA ($3),Y ;source
 STA $5 ;arg
 LDA $5 ;arg
 STA $6 ;HexHigh.digit
 JSR HexHigh
 LDA $5 ;arg
 STA $6 ;HexLow.digit
 JSR HexLow
 LDY #$1
 LDA ($3),Y ;source
 STA $5 ;arg
 LDA $5 ;arg
 STA $6 ;HexHigh.digit
 JSR HexHigh
 LDA $5 ;arg
 STA $6 ;HexLow.digit
 JSR HexLow
 RTS
 
DrawString:
 LDA #$22
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA #$1
 STA $6 ;index
 .loop:
 LDY $6 ;index
 LDA ($3),Y ;source
 BEQ .done
 STA $5 ;arg
 LDA $5 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 INC $6 ;index
 LDA $6 ;index
 CMP #$9
 BNE .loop
 .done:
 LDA #$22
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 RTS
 
DrawStack:
 TXA
 CLC
 ADC #$24
 STA $11 ;address
 LDA #$0
 STA $12 ;address
 JSR LCD_clrscr
 JMP .._2409.str_skip
 .._2409.str_addr:
 FCB "RAD",$0
 .._2409.str_skip:
 LDA # (.._2409.str_addr) # $100
 STA $13 ;LCD_print.source
 LDA # (.._2409.str_addr)/$100
 STA $14 ;LCD_print.source
 JSR LCD_print
 LDA #$35
 STA $F ;character
 LDA #$5
 STA $10 ;counter
 .loop:
 LDA #$0
 STA screen_ptr
 LDA screen_ptr+$1
 CLC
 ADC #$10
 STA screen_ptr+$1
 LDA $F ;character
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA #$3A
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 DEC $10 ;counter
 LDA $10 ;counter
 CMP stack_count
 BCS .no_item
 LDY #$0
 LDA ($11),Y ;address
 CMP #$1
 BNE .not_float
 LDA $11 ;address
 STA $13 ;DrawFloat.source
 LDA $12 ;address
 STA $14 ;DrawFloat.source
 JSR DrawFloat
 JMP .item_done
 .not_float:
 CMP #$2
 BNE .not_str
 LDA $11 ;address
 STA $3 ;DrawString.source
 LDA $12 ;address
 STA $4 ;DrawString.source
 JSR DrawString
 JMP .item_done
 .not_str:
 CMP #$3
 BNE .not_hex
 LDA $11 ;address
 STA $3 ;DrawHex.source
 LDA $12 ;address
 STA $4 ;DrawHex.source
 JSR DrawHex
 JMP .item_done
 .not_hex:
 .item_done:
 .no_item:
 LDA $11 ;address
 SEC
 SBC #$9
 STA $11 ;address
 DEC $F ;character
 LDA $10 ;counter
 BNE .loop
 LDA #$0
 STA screen_ptr
 LDA screen_ptr+$1
 CLC
 ADC #$14
 STA screen_ptr+$1
 LDY #$0
 LDA #$0
 .loop_line:
 STA (screen_ptr),Y
 INC screen_ptr+$1
 STA (screen_ptr),Y
 DEC screen_ptr+$1
 INY
 BNE .loop_line
 RTS
 
ERROR_MSG_INPUT:
 FCB "INPUT ERROR ",$0
 
ERROR_MSG_WORD_TOO_LONG:
 FCB "INPUT SIZE  ",$0
 
ERROR_MSG_STRING:
 FCB "STRING ERROR",$0
 
ERROR_MSG_STACK_OVERFLOW:
 FCB "STACK OVERF ",$0
 
ERROR_MSG_STACK_UNDERFLOW:
 FCB "STACK UNDERF",$0
 
ERROR_TABLE:
 FDB ERROR_MSG_INPUT
 FDB ERROR_MSG_WORD_TOO_LONG
 FDB ERROR_MSG_STRING
 FDB ERROR_MSG_STACK_OVERFLOW
 FDB ERROR_MSG_STACK_UNDERFLOW
 
ErrorMsg:
 LDY $3 ;error_code
 LDA ERROR_TABLE-$2,Y
 STA $4 ;msg
 LDA ERROR_TABLE-$1,Y
 STA $5 ;msg
 LDA #$20
 STA screen_ptr
 LDA #$60
 STA screen_ptr+$1
 JMP .._2584.str_skip
 .._2584.str_addr:
 FCB "bbbbbbbbbbbb",$0
 .._2584.str_skip:
 LDA # (.._2584.str_addr) # $100
 STA $13 ;LCD_print.source
 LDA # (.._2584.str_addr)/$100
 STA $14 ;LCD_print.source
 JSR LCD_print
 LDA #$20
 STA screen_ptr
 LDA #$70
 STA screen_ptr+$1
 LDA #$FF
 STA font_inverted
 LDA $4 ;msg
 STA $13 ;LCD_print.source
 LDA $5 ;msg
 STA $14 ;LCD_print.source
 JSR LCD_print
 LDA #$20
 STA screen_ptr
 LDA #$80
 STA screen_ptr+$1
 JMP .._2638.str_skip
 .._2638.str_addr:
 FCB "bbbbbbbbbbbb",$0
 .._2638.str_skip:
 LDA # (.._2638.str_addr) # $100
 STA $13 ;LCD_print.source
 LDA # (.._2638.str_addr)/$100
 STA $14 ;LCD_print.source
 JSR LCD_print
 LDA #$0
 STA font_inverted
 .loop:
 JSR ReadKey
 CMP #$D
 BNE .loop
 RTS
 RTS
 
InitForth:
 LDA #$0
 STA input_buff_begin
 STA input_buff_end
 STA new_word_len
 RTS
 
special_chars:
 FCB 'e',$22
 FCB " .$m"
 
ReadLine:
 LDA #$0
 STA $3 ;cursor
 STA $6 ;index
 STA screen_ptr
 LDA #$AC
 STA screen_ptr+$1
 JMP .._2689.str_skip
 .._2689.str_addr:
 FCB "a               ",$0
 .._2689.str_skip:
 LDA # (.._2689.str_addr) # $100
 STA $13 ;LCD_print.source
 LDA # (.._2689.str_addr)/$100
 STA $14 ;LCD_print.source
 JSR LCD_print
 LDA $FFE6
 STA $4 ;cursor_timer
 .loop:
 LDA #$0
 STA $5 ;arg
 JSR ReadKey
 BNE .key_read
 JMP .no_key
 .key_read:
 CMP #$D
 BNE .not_enter
 LDA $6 ;index
 BEQ .loop
 LDA #$0
 STA input_buff_begin
 LDA $6 ;index
 STA input_buff_end
 RTS
 .not_enter:
 CMP #$8
 BNE .not_backspace
 LDA $6 ;index
 BEQ .backspace_done
 DEC $6 ;index
 CMP #$10
 BCS .backspace_scroll
 LDA #$20
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA screen_ptr
 SEC
 SBC #$20
 STA screen_ptr
 PHA
 LDA #$61
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 PLA
 STA screen_ptr
 JMP .draw_done
 .backspace_scroll:
 LDY $6 ;index
 DEY
 JMP .scroll_buffer
 .backspace_done:
 JMP .no_key
 .not_backspace:
 LDY #$0
 .special_loop:
 CMP special_chars,Y
 BNE .special_next
 STA $5 ;arg
 CMP #$6D
 BNE .key_done
 LDA #$63
 STA $5 ;arg
 JMP .key_done
 .special_next:
 INY
 CPY #$6
 BNE .special_loop
 CMP #$30
 BCC .not_num
 CMP #$3A
 BCS .not_num
 STA $5 ;arg
 JMP .key_done
 .not_num:
 CMP #$41
 BCC .not_upper
 CMP #$5B
 BCS .not_upper
 STA $5 ;arg
 JMP .key_done
 .not_upper:
 CMP #$61
 BCC .not_lower
 CMP #$7B
 BCS .not_lower
 SEC
 SBC #$20
 STA $5 ;arg
 .not_lower:
 .key_done:
 LDA $5 ;arg
 BEQ .not_valid
 LDY $6 ;index
 CPY #$40
 BCS .buffer_full
 STA input_buff,Y
 INC $6 ;index
 CPY #$F
 BCS .scroll_buffer
 LDA $5 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA screen_ptr
 PHA
 LDA #$61
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 PLA
 STA screen_ptr
 JMP .draw_done
 .scroll_buffer:
 LDA #$0
 STA screen_ptr
 TYA
 SEC
 SBC #$E
 STA $7 ;str_index
 .scroll_loop:
 LDY $7 ;str_index
 INC $7 ;str_index
 LDA input_buff,Y
 STA $5 ;arg
 LDA $5 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA $6 ;index
 CMP $7 ;str_index
 BNE .scroll_loop
 LDA screen_ptr
 PHA
 LDA #$61
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 PLA
 STA screen_ptr
 .draw_done:
 .buffer_full:
 .not_valid:
 .no_key:
 LDA $FFE6
 CMP $4 ;cursor_timer
 BEQ .cursor_done
 STA $4 ;cursor_timer
 LDA $3 ;cursor
 BEQ .draw_blank
 LDA #$0
 STA $3 ;cursor
 LDA #$20
 JMP .draw
 .draw_blank:
 LDA #$FF
 STA $3 ;cursor
 LDA #$61
 .draw:
 STA $5 ;arg
 LDA $5 ;arg
 STA $8 ;LCD_char.c_out
 JSR LCD_char
 LDA screen_ptr
 SEC
 SBC #$10
 STA screen_ptr
 .cursor_done:
 JMP .loop
 RTS
 
LineWord:
 LDA #$0
 STA ret_val
 LDA #$0
 STA new_word_len
 LDY input_buff_begin
 CPY input_buff_end
 BNE .chars_left
 RTS
 .chars_left:
 .loop:
 LDY input_buff_begin
 LDA input_buff,Y
 INC input_buff_begin
 CMP #$20
 BNE .not_space
 LDA new_word_len
 BEQ .chars_left2
 RTS
 .not_space:
 LDY new_word_len
 STA new_word_buff,Y
 INY
 STY new_word_len
 CPY #$13
 BNE .word_size_good
 LDA #$4
 STA ret_val
 RTS
 .word_size_good:
 .chars_left2:
 LDA input_buff_begin
 CMP input_buff_end
 BEQ .found
 JMP .loop
 .found:
 RTS
 RTS
 
FindWord:
 LDA # (FORTH_WORDS) # $100
 STA ret_val
 LDA # (FORTH_WORDS)/$100
 STA ret_val+$1
 .loop:
 LDY #$0
 LDA (ret_val),Y
 CMP new_word_len
 BNE .loop_next
 INY
 .str_loop:
 LDA (ret_val),Y
 CMP new_word_buff-$1,Y
 BNE .no_match
 CPY new_word_len
 BEQ .word_found
 INY
 JMP .str_loop
 .no_match:
 .loop_next:
 LDY #$0
 LDA (ret_val),Y
 TAY
 INY
 LDA (ret_val),Y
 PHA
 INY
 LDA (ret_val),Y
 STA ret_val+$1
 PLA
 STA ret_val
 ORA ret_val+$1
 BNE .loop
 STA ret_val
 RTS
 .word_found:
 LDY #$0
 LDA (ret_val),Y
 TAY
 INY
 INY
 INY
 LDA (ret_val),Y
 STA ret_val
 RTS
 
CheckData:
 LDA #$4
 STA new_stack_item
 LDA new_word_len
 BNE .not_zero_len
 RTS
 .not_zero_len:
 LDY #$8
 LDA #$0
 .zero_loop:
 STA new_stack_item,Y
 DEY
 BNE .zero_loop
 LDY #$0
 LDA new_word_buff
 CMP #$22
 BNE .not_string
 LDA new_word_len
 CMP #$1
 BNE .not_single_quote
 RTS
 .not_single_quote:
 DEC new_word_len
 .loop_str:
 LDA new_word_buff+$1,y
 CMP #$22
 BEQ .str_done
 CPY #$8
 BEQ .string_too_long
 STA new_stack_item+$1,Y
 INY
 CPY new_word_len
 BEQ .string_unterminated
 BNE .loop_str
 .string_too_long:
 .string_unterminated:
 RTS
 .str_done:
 INY
 CPY new_word_len
 BNE .str_return
 LDA #$2
 STA new_stack_item
 .str_return:
 RTS
 .not_string:
 CMP #$24
 BNE .not_hex
 LDA new_word_len
 CMP #$1
 BEQ .hex_error
 CMP #$6
 BCS .hex_error
 DEC new_word_len
 LDY #$0
 .loop_hex:
 LDA new_word_buff+$1,Y
 CMP #$30
 BCC .hex_error
 CMP #$3A
 BCS .not_digit
 SEC
 SBC #$30
 JSR .hex_rotate
 ORA new_stack_item+$1
 STA new_stack_item+$1
 JMP .hex_char_next
 .not_digit:
 CMP #$41
 BCC .hex_error
 CMP #$47
 BCS .hex_error
 SEC
 SBC #$37
 JSR .hex_rotate
 ORA new_stack_item+$1
 STA new_stack_item+$1
 .hex_char_next:
 INY
 CPY new_word_len
 BEQ .hex_done
 CPY #$4
 BNE .loop_hex
 .hex_done:
 LDA #$3
 STA new_stack_item
 RTS
 .hex_error:
 RTS
 .not_hex:
 LDA #$6
 STA $C ;index
 LDA #$0
 STA $D ;which_digit
 STA $E ;negative
 STA $F ;exp_negative
 STA $10 ;exp_count
 STA $14 ;digit_count
 STA $13 ;nonzero_found
 STA $12 ;dec_found
 STA $11 ;exp_found
 LDA new_word_buff
 CMP #$63
 BNE .float_no_neg
 LDA #$FF
 STA $E ;negative
 INY
 JMP .float_first_done
 .float_no_neg:
 CMP #$65
 BNE .float_not_exp
 RTS
 .float_not_exp:
 .float_first_done:
 .loop_float:
 LDA new_word_buff,Y
 JSR .digit
 BCC .float_not_digit
 PHA
 LDA $13 ;nonzero_found
 BNE .digit_good
 PLA
 PHA
 BEQ .digit_zero
 LDA #$FF
 STA $13 ;nonzero_found
 BNE .digit_good
 .digit_zero:
 PLA
 LDA $11 ;exp_found
 BNE .float_next
 LDA $12 ;dec_found
 BNE .dec_exp_count
 LDA #$0
 STA $10 ;exp_count
 .dec_exp_count:
 DEC $10 ;exp_count
 JMP .float_next
 .digit_good:
 LDA $11 ;exp_found
 BNE .exp_digit
 LDA $14 ;digit_count
 CMP #$C
 BNE .digit_ok
 PLA
 RTS
 .digit_ok:
 LDA $12 ;dec_found
 BNE .no_dec_yet
 INC $10 ;exp_count
 .no_dec_yet:
 PLA
 JSR .add_digit
 .float_next:
 INY
 CPY new_word_len
 BEQ .float_done
 JMP .loop_float
 .exp_digit:
 LDA $14 ;digit_count
 CMP #$3
 BNE .exp_digit_ok
 PLA
 RTS
 .exp_digit_ok:
 PLA
 STY $B ;y_buff
 LDY #$4
 .exp_loop:
 ASL new_stack_item+$7
 ROL new_stack_item+$8
 DEY
 BNE .exp_loop
 LDY $B ;y_buff
 ORA new_stack_item+$7
 STA new_stack_item+$7
 INC $C ;index
 INC $14 ;digit_count
 JMP .float_next
 .float_not_digit:
 CMP #$2E
 BNE .not_decimal_point
 LDA $12 ;dec_found
 BEQ .decimal_good
 RTS
 .decimal_good:
 LDA $11 ;exp_found
 BEQ .exp_good
 RTS
 .exp_good:
 LDA #$FF
 STA $12 ;dec_found
 BNE .float_next
 .not_decimal_point:
 CMP #$65
 BNE .not_exp
 LDA $11 ;exp_found
 BEQ .first_exp
 RTS
 .first_exp:
 LDA #$0
 STA $C ;index
 STA $D ;which_digit
 STA $14 ;digit_count
 STA $13 ;nonzero_found
 LDA #$FF
 STA $11 ;exp_found
 BNE .float_next
 .not_exp:
 CMP #$63
 BNE .not_minus
 LDA $11 ;exp_found
 EOR #$FF
 ORA $C ;index
 ORA $F ;exp_negative
 BEQ .minus_good
 RTS
 .minus_good:
 LDA #$FF
 STA $F ;exp_negative
 BNE .float_next
 .not_minus:
 RTS
 .float_done:
 LDA $F ;exp_negative
 BEQ .exp_positive
 LDA # (new_stack_item+$7) # $100
 STA $15 ;BCD_Reverse.source
 LDA # (new_stack_item+$7)/$100
 STA $16 ;BCD_Reverse.source
 LDA #$2
 STA $17 ;BCD_Reverse.count
 JSR BCD_Reverse
 .exp_positive:
 SED
 LDA #$0
 LDY $10 ;exp_count
 BMI .exp_count_neg
 DEY
 BEQ .exp_count_done
 .exp_pos_loop:
 CLC
 ADC #$1
 DEY
 BNE .exp_pos_loop
 JMP .exp_count_done
 .exp_count_neg:
 .exp_min_loop:
 SEC
 SBC #$1
 INY
 BNE .exp_min_loop
 .exp_count_done:
 STA $10 ;exp_count
 LDY #$99
 CMP #$50
 BCS .exp_count_neg2
 LDY #$0
 .exp_count_neg2:
 STY $C ;index
 CLC
 ADC new_stack_item+$7
 STA new_stack_item+$7
 LDA $C ;index
 ADC new_stack_item+$8
 STA new_stack_item+$8
 CLD
 LDA #$0
 LDY new_stack_item+$8
 CPY #$50
 BCC .exp_positive2
 LDA # (new_stack_item+$7) # $100
 STA $15 ;BCD_Reverse.source
 LDA # (new_stack_item+$7)/$100
 STA $16 ;BCD_Reverse.source
 LDA #$2
 STA $17 ;BCD_Reverse.count
 JSR BCD_Reverse
 LDA #$FF
 .exp_positive2:
 STA $F ;exp_negative
 LDA new_stack_item+$8
 CMP #$10
 BNE .no_exp_overflow
 RTS
 .no_exp_overflow:
 LDA $F ;exp_negative
 BEQ .exp_no_neg_bit
 LDA new_stack_item+$8
 ORA #$40
 STA new_stack_item+$8
 .exp_no_neg_bit:
 LDA $E ;negative
 BEQ .positive
 LDA new_stack_item+$8
 ORA #$80
 STA new_stack_item+$8
 .positive:
 LDA #$1
 STA new_stack_item
 RTS
 .hex_rotate:
 STY $B ;y_buff
 LDY #$4
 .hex_rot_loop:
 ASL new_stack_item+$1
 ROL new_stack_item+$2
 DEY
 BNE .hex_rot_loop
 LDY $B ;y_buff
 RTS
 .digit:
 CMP #$3A
 BCS .is_digit_no
 CMP #$30
 BCC .is_digit_no
 SBC #$30
 RTS
 .is_digit_no:
 CLC
 RTS
 .add_digit:
 PHA
 STY $B ;y_buff
 LDY $C ;index
 INC $14 ;digit_count
 LDA $D ;which_digit
 EOR #$FF
 STA $D ;which_digit
 BEQ .second_digit
 PLA
 ASL
 ASL
 ASL
 ASL
 STA new_stack_item,Y
 LDY $B ;y_buff
 RTS
 .second_digit:
 PLA
 ORA new_stack_item,Y
 STA new_stack_item,Y
 DEC $C ;index
 LDY $B ;y_buff
 RTS
 RTS
 
ExecToken:
 LDA #$0
 STA ret_val
 LDY $3 ;token
 LDA JUMP_TABLE,Y
 STA $6 ;address
 LDA JUMP_TABLE+$1,Y
 STA $7 ;address
 LDY #$0
 LDA ($6),Y ;address
 BEQ .no_flags
 STA $4 ;flags
 AND #$3
 STA $5 ;temp
 LDA stack_count
 CMP $5 ;temp
 BCS .no_underflow
 LDA #$A
 STA ret_val
 RTS
 .no_underflow:
 LDA $4 ;flags
 AND #$4
 BEQ .no_add_item
 LDA #$7
 CMP stack_count
 BCS .no_overflow
 LDA #$8
 STA ret_val
 RTS
 .no_overflow:
 JSR StackAddItem
 .no_add_item:
 .no_flags:
 LDA $7 ;address
 PHA
 LDA $6 ;address
 PHA
 RTS
 RTS
 
StackAddItem:
 TXA
 SEC
 SBC #$9
 TAX
 INC stack_count
 RTS
 
FORTH_WORDS:
 
WORD_DUP:
 FCB $3,"DUP"
 FDB WORD_SWAP
 FCB $2
 
CODE_DUP:
 FCB $5
 LDY #$9
 TXA
 PHA
 .dup_loop:
 LDA $9,X
 STA $0,X
 INX
 DEY
 BNE .dup_loop
 PLA
 TAX
 RTS
 
WORD_SWAP:
 FCB $4,"SWAP"
 FDB WORD_DROP
 FCB $4
 
CODE_SWAP:
 FCB $2
 LDY #$9
 TXA
 PHA
 .swap_loop:
 LDA $9,X
 PHA
 LDA $0,X
 STA $9,X
 PLA
 STA $0,X
 INX
 DEY
 BNE .swap_loop
 PLA
 TAX
 RTS
 
WORD_DROP:
 FCB $4,"DROP"
 FDB WORD_OVER
 FCB $6
 
CODE_DROP:
 FCB $1
 TXA
 CLC
 ADC #$9
 TAX
 DEC stack_count
 RTS
 
WORD_OVER:
 FCB $4,"OVER"
 FDB WORD_ROT
 FCB $8
 
CODE_OVER:
 FCB $6
 LDY #$9
 TXA
 PHA
 .over_loop:
 LDA $12,X
 STA $0,X
 INX
 DEY
 BNE .over_loop
 PLA
 TAX
 RTS
 
WORD_ROT:
 FCB $3,"ROT"
 FDB WORD_MIN_ROT
 FCB $A
 
CODE_ROT:
 FCB $3
 LDY #$9
 TXA
 PHA
 .rot_loop:
 LDA $12,X
 PHA
 LDA $9,X
 PHA
 LDA $0,X
 STA $9,X
 PLA
 STA $12,X
 PLA
 STA $0,X
 INX
 DEY
 BNE .rot_loop
 PLA
 TAX
 RTS
 
WORD_MIN_ROT:
 FCB $4,"-ROT"
 FDB WORD_CLEAR
 FCB $C
 
CODE_MIN_ROT:
 FCB $3
 LDY #$9
 TXA
 PHA
 .min_rot_loop:
 LDA $12,X
 PHA
 LDA $9,X
 PHA
 LDA $0,X
 STA $12,X
 PLA
 STA $0,X
 PLA
 STA $9,X
 INX
 DEY
 BNE .min_rot_loop
 PLA
 TAX
 RTS
 
WORD_CLEAR:
 FCB $5,"CLEAR"
 FDB $0
 FCB $E
 
CODE_CLEAR:
 FCB $0
 LDX #$0
 STX stack_count
 RTS
 
JUMP_TABLE:
 FDB $0
 FDB CODE_DUP
 FDB CODE_SWAP
 FDB CODE_DROP
 FDB CODE_OVER
 FDB CODE_ROT
 FDB CODE_MIN_ROT
 FDB CODE_CLEAR
 
main:
 LDX #$2F
 TXS
 JSR setup
 JSR tests
 .input_loop:
 JSR DrawStack
 JSR ReadLine
 .process_loop:
 JSR LineWord
 LDA new_word_len
 BEQ .input_loop
 JSR FindWord
 LDA ret_val
 BEQ .not_found
 LDA ret_val
 STA $3 ;ExecToken.token
 JSR ExecToken
 LDA ret_val
 BEQ .no_exec_error
 STA $2 ;arg
 LDA $2 ;arg
 STA $3 ;ErrorMsg.error_code
 JSR ErrorMsg
 JMP .input_loop
 .no_exec_error:
 JMP .process_loop
 .not_found:
 JSR CheckData
 LDA new_stack_item
 CMP #$4
 BNE .input_good
 LDA #$2
 STA $3 ;ErrorMsg.error_code
 JSR ErrorMsg
 JMP .input_loop
 .input_good:
 LDA #$7
 CMP stack_count
 BCS .no_overflow
 LDA #$8
 STA $3 ;ErrorMsg.error_code
 JSR ErrorMsg
 JMP .input_loop
 .no_overflow:
 JSR StackAddItem
 STX $0 ;dest
 LDA #$0
 STA $1 ;dest
 LDA # (new_stack_item) # $100
 STA $3 ;MemCopy.source
 LDA # (new_stack_item)/$100
 STA $4 ;MemCopy.source
 LDA $0 ;dest
 STA $5 ;MemCopy.dest
 LDA $1 ;dest
 STA $6 ;MemCopy.dest
 LDA #$9
 STA $7 ;MemCopy.count
 JSR MemCopy
 JMP .process_loop
 RTS
 
code_end:


EEPROM set *

	OUTRADIX 10

AddCommas MACRO num
comma_ret set "\{num}"
	IF num<1000
		EXITM
	ELSE
comma_ret set "\{substr(comma_ret,0,strlen(comma_ret)-3)},\{substr(comma_ret,strlen(comma_ret)-3,strlen(comma_ret))}"
	ENDIF
	ENDM

;Display memory usage in console
;===============================
	MESSAGE " "
	MESSAGE "Memory usage"
	MESSAGE "============"
	AddCommas EEPROM-$900
	MESSAGE "ROM size:	\{comma_ret} bytes (\{100*(EEPROM-$900)/$2000}%) of 8k ROM"
	;AddCommas GENRAM-$200
	;MESSAGE "RAM size:	\{comma_ret} bytes (\{100*(GENRAM-$200)/($4000-$200)}%) of 15.8k bank"
	;Tell script that prints assembler output to stop outputting
	;Eliminates double output (because of multiple passes???)
	MESSAGE "END"