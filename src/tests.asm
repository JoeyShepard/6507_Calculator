;Unit tests
;==========
;Stored in extended RAM of emulator, not on calculator, so not size constrained


;Frameworks

	test_buff: DFS OBJ_SIZE-TYPE_SIZE+GR_OFFSET+1

	FUNC InputTest
		ARGS
			STRING input, output
		VARS
			BYTE output_index, calculated_index, value
		END
		
		LDY #0
		.loop:
			LDA (input),Y
			BEQ .loop_done
			;CMP #'-'
			;BNE .not_minus
			;	LDA #CHAR_MINUS
			;.not_minus:
			STA new_word_buff,Y
			INY
			JMP .loop
		.loop_done:
		STY new_word_len
		CALL CheckData
		
		LDY #0
		STY calculated_index
		STY output_index
		.check_loop:
			LDY output_index
			LDA (output),Y
			CMP #'A'
			BCS .letter
				SEC
				SBC #'0'
				JMP .letter_done
			.letter:
				SEC
				SBC #'A'-10
			.letter_done:
			ASL
			ASL
			ASL
			ASL
			STA value
			
			INY
			LDA (output),Y
			CMP #'A'
			BCS .letter2
				SEC
				SBC #'0'
				JMP .letter_done2
			.letter2:
				SEC
				SBC #'A'-10
			.letter_done2:
			ORA value
			STA value
			
			INY
			STY output_index
			
			LDY calculated_index
			LDA R_ans,Y
			CMP value
			BNE .failed
			INY
			STY calculated_index
			
			LDY output_index
			LDA (output),Y
			BNE .continue
				JMP .done
			.continue:
			INY
			STY output_index
			JMP .check_loop
		
			.failed:
				CALL DebugText, "\\rTest "
				LDX test_count+1
				LDA test_count
				STA DEBUG_DEC16
				CALL DebugText,": FAILED!\\n"
				CALL DebugText,"   Expected: "
				CALL DebugText,output
				CALL DebugText,"\\n   Found:    "
				LDY #0
				.fail_loop:
					LDA R_ans,Y
					STA DEBUG_HEX
					LDA #' '
					STA DEBUG
					INY
					CPY #9
					BNE .fail_loop
				halt
				
				JMP .failed
			
		.done:
		CALL DebugText, "\\gTest "
		LDX test_count+1
		LDA test_count
		STA DEBUG_DEC16
		CALL DebugText,": passed\\n"
		INC.W test_count
		
	END
	
	FUNC NewToR
		ARGS
			WORD Rx
		END
		
		LDY #1
		.loop:
			LDA R_ans,Y
			STA (Rx),Y
			INY
			CPY #9
			BNE .loop
	END

	FUNC CopyNew
		ARGS 
			STRING num1
		END
		
		LDY #0
		.loop:
			LDA (num1),Y
			BEQ .loop_done
			;CMP #'-'
			;BNE .not_minus
			;	LDA #CHAR_MINUS
			;.not_minus:
			STA new_word_buff,Y
			INY
			JMP .loop
		.loop_done:
		STY new_word_len
		CALL CheckData
	END

	FUNC DebugRans
		TXA
		PHA
		
		;CALL DebugText,"\\n"
		LDX #(DEC_COUNT/2)-1+GR_OFFSET
		.loop:
			LDA R_ans,X
			STA DEBUG_HEX
			DEX
			BNE .loop
		LDA #' '
		STA DEBUG
		
		;LDA R_ans		;GR
		;STA DEBUG_HEX
		
		CALL DebugText,"E"
		LDA R_ans+DEC_COUNT/2+2
		STA DEBUG_HEX
		LDA R_ans+DEC_COUNT/2+1
		STA DEBUG_HEX
		
		PLA
		TAX
	END

	FUNC DebugBuff
		TXA
		PHA
		
		;CALL DebugText,"\\n"
		LDX #(DEC_COUNT/2)-1+GR_OFFSET
		.loop:
			LDA test_buff,X
			STA DEBUG_HEX
			DEX
			BNE .loop
		LDA #' '
		STA DEBUG
		
		;LDA R_ans		;GR
		;STA DEBUG_HEX
		
		CALL DebugText,"E"
		LDA test_buff+DEC_COUNT/2+2
		STA DEBUG_HEX
		LDA test_buff+DEC_COUNT/2+1
		STA DEBUG_HEX
		
		PLA
		TAX
	END

	
	
	FUNC RansToBuff
		LDY #0
		.loop:
			LDA R_ans,Y
			STA test_buff,Y
			INY
			CPY #OBJ_SIZE
			BNE .loop
	END

	FUNC CompareRans
		LDY #8
		.loop:
			LDA R_ans,Y
			CMP test_buff,Y
			BNE .failed
			DEY
			BNE .loop
		CLC
		RTS
		
		.failed:
		SEC
	END


	FUNC TestFail
		ARGS
			STRING ans
		END
		
		.loop:
			CALL DebugText, "\\rTest "
			LDX test_count+1
			LDA test_count
			STA DEBUG_DEC16
			CALL DebugText,": FAILED!\\n"
			CALL DebugText,"   Expected: "
			CALL DebugText,ans
			CALL DebugText,"\\n   Found:    "
			;CALL DebugRans
			CALL DebugBuff
			CALL DebugText,"\\n\\n"
			
			halt
			
			JMP .loop
	END

	FUNC TestsPassed
		
		CALL DebugText, "\\gTest "
		LDX test_count+1
		LDA test_count
		STA DEBUG_DEC16
		CALL DebugText,": passed - "
		CALL DebugRans
		CALL DebugText,"\\n"
		INC.W test_count
	
	END

	FUNC AddTest
		ARGS
			STRING num1,num2,ans
		END
		
		CALL CopyNew,num1
		CALL NewToR, #R1
		CALL CopyNew,num2
		CALL NewToR, #R0
		CALL BCD_Add
		CALL RansToBuff
		CALL CopyNew,ans
		CALL CompareRans
		
		BCC .done
			CALL TestFail, ans
		.done:
		CALL TestsPassed
	END
	
	FUNC MultTest
		ARGS
			STRING num1,num2,ans
		END
		
		CALL CopyNew,num1
		CALL NewToR, #R1
		CALL CopyNew,num2
		CALL NewToR, #R0
		CALL BCD_Mult
		CALL RansToBuff
		CALL CopyNew,ans
		CALL CompareRans
		
		BCC .done
			CALL TestFail, ans
		.done:
		CALL TestsPassed
	END
	
	FUNC DivTest
		ARGS
			STRING num1,num2,ans
		END
		
		CALL CopyNew,num1
		CALL NewToR, #R1
		CALL CopyNew,num2
		CALL NewToR, #R0
		CALL BCD_Div
		CALL RansToBuff
		CALL CopyNew,ans
		CALL CompareRans
		
		BCC .done
			CALL TestFail, ans
		.done:
		CALL TestsPassed
	END
	
	TODO: move commented out tests to input.txt
	FUNC tests
		
		;Number input
		MOV.W #1,test_count
		
		;Moved to input.txt
		
		;CALL InputTest, "1234567890123456789", "01 12 90 78 56 34 12 18 00"
		;CALL InputTest, "9999999999999999999", "01 00 00 00 00 00 10 19 00"
		
		TODO: tests for hex arithmetic
		
		;Floating point add
		MOV.W #501,test_count
		
		;CALL AddTest, "12345", "0", "12345"
    	;CALL AddTest, "100000000000", "-0.04", "100000000000"
		;CALL AddTest, "9.99999999999e999","1e999","9.99999999999e999"
		;CALL AddTest, "-6e999","-6e999","-9.99999999999e999"
		;CALL AddTest, "-1.781e999","-9.e999","-9.99999999999e999"
				
		;Floating point mult
		MOV.W #601,test_count
		
		;CALL MultTest, "123456789012", "234567890123", "2.89589985199e22"
		;CALL MultTest, "-987654321098e17", "876543210987e23", "-8.65721689960e63"
		;CALL MultTest, "-9.87654321098e432", "8.76543210987e543", "-8.65721689960e976"
		;CALL MultTest, "12345", "0", "0"
		;CALL MultTest, "0", "12345", "0"
		;CALL MultTest, "1","1e-999","1e-999"
		;CALL MultTest, "7.048764e59","5.711220186e848","4.02570432432e908"
		
		;Floating point div
		MOV.W #701,test_count
		
		;CALL DivTest, "123456789023e12","234567890134e5","5263158.09689"
		;CALL DivTest, "122.00000000","3","40.6666666667"
		;CALL DivTest, "422.00000000","3","140.666666667"
		;CALL DivTest, "200000000001","2","100000000000"
		;CALL DivTest, "200000000002","2","100000000001"
		;CALL DivTest, "200000000003","2","100000000002"
		;CALL DivTest, "-5000","49","-102.040816327"
		;CALL DivTest, "123e456","234e-645","9.99999999999e999"
		;CALL DivTest, "1e-999","2","0"
		;CALL DivTest, "9e999","9e-999","9.99999999999e999"
		
		CALL DebugText, "\\n\\gAll specific tests passed"
		MOV.W #0,test_count
		
		MOV.W #$FFFF,test_count
		
	END 
	