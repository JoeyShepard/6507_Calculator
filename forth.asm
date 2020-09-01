;Forth related functions
;=======================
	FUNC InitForth
		LDA #0
		STA input_buff_begin
		STA input_buff_end
		STA new_word_len
	END
	
	SPECIAL_CHARS_LEN = 6
	special_chars:
	FCB CHAR_EXP, CHAR_QUOTE		;2
	FCB " .$-"						;4
	
	;Can save space here by removing cursor draw after key
	FUNC ReadLine
		VARS
			BYTE cursor, cursor_timer
			BYTE arg
			BYTE index, str_index
		END
		
		LDA #0
		STA cursor
		STA index
		STA screen_ptr
		LDA #INPUT_Y
		STA screen_ptr+1
		CALL LCD_print,"a               "
		LDA TIMER_S
		STA cursor_timer
		
		.loop:
			LDA #0
			STA arg
			CALL ReadKey
			BNE .key_read
				JMP .no_key
			.key_read:
			
				;Enter key
				CMP #KEY_ENTER
				BNE .not_enter
					LDA index
					BEQ .loop
					LDA #0
					STA input_buff_begin
					LDA index
					STA input_buff_end
					RTS
				.not_enter:
			
				;Backspace
				CMP #KEY_BACKSPACE
				BNE .not_backspace
					LDA index
					BEQ .backspace_done
						DEC index
						CMP #CHAR_SCREEN_WIDTH
						BCS .backspace_scroll
							CALL LCD_char, #' '
							LDA screen_ptr
							SEC
							SBC #CHAR_WIDTH*2
							STA screen_ptr
							PHA
							CALL LCD_char, #CHAR_ARROW
							PLA
							STA screen_ptr
							JMP .draw_done
						.backspace_scroll:
							LDY index
							DEY
							JMP .scroll_buffer
						
					.backspace_done:
					JMP .no_key
				.not_backspace:
				
				;Special character
				LDY #0
				.special_loop:
					CMP special_chars,Y
					BNE .special_next
						STA arg
						JMP .key_done
					.special_next:
					INY
					CPY #SPECIAL_CHARS_LEN
					BNE .special_loop
				
				;Number
				CMP #'0'
				BCC .not_num
				CMP #'9'+1
				BCS .not_num
					STA arg
					JMP .key_done
				.not_num:
				
				;Uppercase
				CMP #'A'
				BCC .not_upper
				CMP #'Z'+1
				BCS .not_upper
					STA arg
					JMP .key_done
				.not_upper:
				
				;Lowercase
				CMP #'a'
				BCC .not_lower
				CMP #'z'+1
				BCS .not_lower
					;Convert to uppercase
					SEC
					SBC #$20
					STA arg
				.not_lower:
				
				.key_done:
				LDA arg
				BEQ .not_valid
					LDY index
					CPY #BUFF_SIZE
					BCS .buffer_full
						STA input_buff,Y
						INC index
						CPY #CHAR_SCREEN_WIDTH-1
						BCS .scroll_buffer
							CALL LCD_char, arg
							LDA screen_ptr
							PHA
							CALL LCD_char, #CHAR_ARROW
							PLA
							STA screen_ptr
							JMP .draw_done
						.scroll_buffer:
							LDA #0
							STA screen_ptr
							TYA
							SEC
							SBC #CHAR_SCREEN_WIDTH-2
							STA str_index
							.scroll_loop:
								LDY str_index
								INC str_index
								LDA input_buff,Y
								STA arg
								CALL LCD_char, arg
								LDA index
								CMP str_index
								BNE .scroll_loop
							LDA screen_ptr
							PHA
							CALL LCD_char, #CHAR_ARROW
							PLA
							STA screen_ptr
						.draw_done:
					.buffer_full:
				.not_valid:

			.no_key:
			LDA TIMER_S
			CMP cursor_timer
			BEQ .cursor_done
				STA cursor_timer
				LDA cursor
				BEQ .draw_blank
					LDA #0
					STA cursor
					LDA #' '
					JMP .draw
				.draw_blank:
					LDA #$FF
					STA cursor
					LDA #CHAR_ARROW
				.draw:
				STA arg
				CALL LCD_char, arg
				LDA screen_ptr
				SEC
				SBC #CHAR_WIDTH
				STA screen_ptr
			.cursor_done:
		JMP .loop
	END
	
	FUNC LineWord

		LDA #ERROR_NONE
		STA ret_val
		
		LDA #0
		STA new_word_len
		
		LDY input_buff_begin
		CPY input_buff_end
		BNE .chars_left
			;No characters left
			RTS
		.chars_left:
		
		.loop:
			LDY input_buff_begin
			LDA input_buff,Y
			INC input_buff_begin
			CMP #' '
			BNE .not_space
				LDA new_word_len
				BEQ .chars_left2
					;Word is non-zero in size
					RTS
			.not_space:
				LDY new_word_len
				STA new_word_buff,Y
				INY
				STY new_word_len
				CPY #WORD_MAX_SIZE
				BNE .word_size_good
					;Word too big to fit into 18 byte buffer
					LDA #ERROR_WORD_TOO_LONG
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
	END
	
	FUNC FindWord
		
		MOV.W #FORTH_WORDS,ret_val
		.loop:
			LDY #0
			LDA (ret_val),Y
			CMP new_word_len
			BNE .loop_next
				INY
				.str_loop:
					LDA (ret_val),Y
					CMP new_word_buff-1,Y	;offset by 1 since string starts one byte in
					BNE .no_match
						CPY new_word_len
						BEQ .word_found
							INY
							JMP .str_loop
					.no_match:
			.loop_next:
			LDY #0
			LDA (ret_val),Y
			TAY
			INY
			LDA (ret_val),Y
			PHA
			INY 
			LDA (ret_val),Y
			STA ret_val+1
			PLA
			STA ret_val			
			ORA ret_val+1
			BNE .loop
			;Done searching - zero ret_val
			STA ret_val
			RTS
		.word_found:
		LDY #0
		LDA (ret_val),Y
		TAY
		INY
		INY
		INY		;point past header
		LDA (ret_val),Y
		STA ret_val
	END
	
	FUNC CheckData
		VARS
			BYTE input_mode		;input mode for float - pre decimal, post decimal, or exponent
			BYTE y_buff			;temporary storage for y
			BYTE index			;generic index
			BYTE which_digit	;whether first or second digit of BCD byte
			BYTE negative		;whether float is negative number
			BYTE exp_negative	;whether exp is negative number
			BYTE exp_count		;offset from decimal place in float
			BYTE exp_found		;whether e encountered yet in float
			BYTE dec_found		;whether decimal point encountered yet in float
			BYTE nonzero_found	;whether non-zero encountered yet in float
			BYTE digit_count	;count of digits during float input
		END
		LDA #OBJ_ERROR
		STA new_stack_item
		
		LDA new_word_len
		BNE .not_zero_len
			;Zero length string
			RTS
		.not_zero_len:
		
		LDY #8
		LDA #0
		.zero_loop:
			STA new_stack_item,Y
			DEY
			BNE .zero_loop
		
		LDY #0
		LDA new_word_buff
		CMP #'"'
		BNE .not_string
			;string
			LDA new_word_len
			CMP #1
			BNE .not_single_quote
				;single quote - invalid string
				RTS
			.not_single_quote:
			;reduce by one so can compare to Y below
			DEC new_word_len
			.loop_str:
				LDA new_word_buff+1,y	;+1 to skip first quote
				CMP #'"'
				BEQ .str_done
				CPY #8
				BEQ .string_too_long
				STA new_stack_item+1,Y
				INY
				CPY new_word_len
				BEQ .string_unterminated
				BNE .loop_str
				.string_too_long:
				;string longer than 8!
				.string_unterminated:
				;no matching quote on end!
				
				;optional - could cut to save space
				;LDA #ERROR_STRING
				;STA global_error
				
				;item type already set to OBJ_ERROR
				RTS
			.str_done:
			;was closing quote also last character?
			INY
			CPY new_word_len
			BNE .str_return
			
			;all successful
			LDA #OBJ_STR
			STA new_stack_item
			.str_return:
			RTS
		.not_string:
		
		CMP #'$'
		BNE .not_hex
			;hex
			LDA new_word_len
			;single dollar sign - invalid hex
			CMP #1
			BEQ .hex_error
			;limit to 16 bits - 4 digits
			CMP #6
			BCS .hex_error
			
			;decrease to make easier to compare to Y below
			DEC new_word_len
			LDY #0
			.loop_hex:
				LDA new_word_buff+1,Y
				CMP #'0'
				BCC .hex_error
				CMP #'9'+1
				BCS .not_digit
					SEC
					SBC #'0'
					JSR .hex_rotate
					ORA new_stack_item+1
					STA new_stack_item+1
					JMP .hex_char_next
				.not_digit:
				
				CMP #'A'
				BCC .hex_error
				CMP #'F'+1
				BCS .hex_error
				SEC
				SBC #'A'-10
				JSR .hex_rotate
				ORA new_stack_item+1
				STA new_stack_item+1
				
				.hex_char_next:
				INY
				CPY new_word_len
				BEQ .hex_done
				CPY #4
				BNE .loop_hex
				
				;success
				.hex_done:
				LDA #OBJ_HEX
				STA new_stack_item
				RTS
			.hex_error:
			RTS
		.not_hex:
		
		;not string or hex, so must be float
		LDA #6
		STA index
		LDA #0
		STA which_digit
		STA negative
		STA exp_negative
		STA exp_count
		STA digit_count
		STA nonzero_found
		STA dec_found
		STA exp_found
		
		;first character is negative or digit?
		LDA new_word_buff
		CMP #'-'
		BNE .float_no_neg
			;neg sign
			LDA #$FF
			STA negative
			INY
		.float_no_neg:
		
		.loop_float:
			LDA new_word_buff,Y
			JSR .digit
			BCC .float_not_digit
				PHA
				LDA nonzero_found
				BNE .digit_good
					;no nonzero yet
					PLA
					PHA
					BEQ .digit_zero
						;non zero digit
						LDA #$FF
						STA nonzero_found
						BNE .digit_good
						
					.digit_zero:
					;only zeroes so far, so just count exponent
					PLA
					LDA exp_found
					BNE .float_next
						LDA dec_found
						BEQ .float_next
							DEC exp_count
							BNE .float_next
	
					.digit_good:
					LDA exp_found
					BNE .exp_digit
						LDA digit_count
						CMP #MAX_DIGITS
						BNE .digit_ok
							;max digits exceeded!
							PLA
							RTS
						.digit_ok:
						LDA dec_found
						BNE .no_dec_yet
							INC exp_count
						.no_dec_yet:
						
						PLA
						JSR .add_digit
						.float_next:
						INY
						CPY new_word_len
						BEQ .float_done
						JMP .loop_float
					.exp_digit:
						LDA digit_count
						CMP #3
						BNE .exp_digit_ok
							;max exp digits exceeded!
							PLA
							RTS
						.exp_digit_ok:
						
						PLA
						STY y_buff
						LDY #4
						.exp_loop:
							ASL new_stack_item+7
							ROL new_stack_item+8
							DEY
							BNE .exp_loop
						LDY y_buff
						ORA new_stack_item+7
						STA new_stack_item+7
						INC index
						INC digit_count
						JMP .float_next
			.float_not_digit:
			
			;not digit
			CMP #'.'
			BNE .not_decimal_point
				LDA dec_found
				BEQ .decimal_good
					;second decimal found!
					RTS
				.decimal_good:
				LDA exp_found
				BEQ .exp_good
					;decimal in exponent!
					RTS
				.exp_good:
				LDA #$FF
				STA dec_found
				BNE .float_next
			.not_decimal_point:
		
			CMP #'e'
			BNE .not_exp
				LDA exp_found
				BEQ .first_exp
					;second e found, error!
					RTS
				.first_exp:
				LDA #0
				STA index
				STA which_digit
				STA digit_count
				STA nonzero_found
				LDA #$FF
				STA exp_found
				BNE .float_next		
			.not_exp:
			
			CMP #'-'
			BNE .not_minus
				;only allowed if exp_found and at first character:
				LDA exp_found
				EOR #$FF
				ORA index
				ORA exp_negative
				BEQ .minus_good
					;minus in wrong place!
					RTS
				.minus_good:
				LDA #$FF
				STA exp_negative
				BNE .float_next
			.not_minus:
			
			;character not recognized - invalid input!
			RTS
		.float_done:
		
		;shift bytes if necessary
		
		
		;invert exponent bytes if necessary
		LDA exp_negative
		BEQ .exp_not_negative
			CALL BCD_Reverse, #new_stack_item+7, #2
		.exp_not_negative:
		
		;adjust exponent
		LDA exp_count
		;BMI .float_dec_exp
		
		
		
		
		LDA #OBJ_FLOAT
		STA new_stack_item
		
		RTS
		
		;helper routines
		.hex_rotate:
			STY y_buff
			LDY #4
			.hex_rot_loop:
				ASL new_stack_item+1
				ROL new_stack_item+2
				DEY
				BNE .hex_rot_loop
			LDY y_buff
			RTS
		
		;Carry set means digit
		.digit:
			CMP #'9'+1
			BCS .is_digit_no
			CMP #'0'
			BCC .is_digit_no
				;SEC
				SBC #'0'
				RTS
			.is_digit_no:
				CLC
				RTS
				
		.add_digit:
			PHA
			STY y_buff
			LDY index
			INC digit_count
			LDA which_digit
			EOR #$FF
			STA which_digit
			BEQ .second_digit
				;first digit
				PLA
				ASL
				ASL
				ASL
				ASL
				STA new_stack_item,Y
				LDY y_buff
				RTS
			.second_digit:
				PLA
				ORA new_stack_item,Y
				STA new_stack_item,Y
				DEC index
				LDY y_buff
				RTS
			
	END
	
	FUNC ExecToken
		ARGS
			BYTE token, flags
			BYTE temp
			WORD address
		END
		
		;No error unless set below
		LDA #ERROR_NONE
		STA ret_val
		
		LDY token
		LDA JUMP_TABLE,Y
		STA address
		LDA JUMP_TABLE+1,Y
		STA address+1
		LDY #0
		LDA (address),Y
		BEQ .no_flags
			STA flags
			
			;Check min stack size
			AND #MIN_3
			STA temp
			LDA stack_count
			CMP temp
			BCS .no_underflow
				LDA #ERROR_STACK_UNDERFLOW
				STA ret_val
				RTS
			.no_underflow:
			
			;Check max stack size
			LDA flags
			AND #ADD_1
			BEQ .no_add_item
				LDA #STACK_SIZE-1
				CMP stack_count
				BCS .no_overflow
					LDA #ERROR_STACK_OVERFLOW
					STA ret_val
					RTS
				.no_overflow:
				JSR StackAddItem
			.no_add_item:
		.no_flags:
		
		;INC.W address	;not necessary since RTS adds 1
		LDA address+1
		PHA
		LDA address
		PHA
		RTS 			;calls calculated jump
	END
	
	FUNC StackAddItem
		TXA
		SEC
		SBC #OBJ_SIZE
		TAX
		INC stack_count
	END
	
	
	;Word list
	FORTH_WORDS:
	
	WORD_DUP:
		FCB 3, "DUP" 		;Name
		FDB	WORD_SWAP		;Next word
		FCB 2				;ID
		CODE_DUP:
			FCB MIN_1|ADD_1	;Flags
			
			LDY #OBJ_SIZE
			TXA
			PHA
			.dup_loop:
				LDA OBJ_SIZE,X
				STA 0,X
				INX
				DEY
				BNE .dup_loop
			PLA
			TAX
			RTS
	
	WORD_SWAP:
		FCB 4, "SWAP" 		;Name
		FDB	WORD_DROP		;Next word
		FCB 4				;ID
		CODE_SWAP:
			FCB MIN_2		;Flags
			
			LDY #OBJ_SIZE
			TXA
			PHA
			.swap_loop:
				LDA OBJ_SIZE,X
				PHA
				LDA 0,X
				STA OBJ_SIZE,X
				PLA
				STA 0,X
				INX
				DEY
				BNE .swap_loop
			PLA
			TAX
			RTS	
	
	WORD_DROP:
		FCB 4, "DROP" 		;Name
		FDB	WORD_OVER		;Next word
		FCB 6				;ID
		CODE_DROP:
			FCB MIN_1		;Flags
			
			TXA
			CLC
			ADC #OBJ_SIZE
			TAX
			DEC stack_count
			RTS
	
	WORD_OVER:
		FCB 4, "OVER" 		;Name
		FDB	WORD_ROT		;Next word
		FCB 8				;ID
		CODE_OVER:
			FCB MIN_2|ADD_1	;Flags
			
			LDY #OBJ_SIZE
			TXA
			PHA
			.over_loop:
				LDA OBJ_SIZE*2,X
				STA 0,X
				INX
				DEY
				BNE .over_loop
			PLA
			TAX
			RTS
			
	WORD_ROT:
		FCB 3, "ROT" 		;Name
		FDB	WORD_MIN_ROT	;Next word
		FCB 10				;ID
		CODE_ROT:
			FCB MIN_3		;Flags
			
			LDY #OBJ_SIZE
			TXA
			PHA
			.rot_loop:
				LDA OBJ_SIZE*2,X
				PHA
				LDA OBJ_SIZE,X
				PHA
				LDA 0,X
				STA OBJ_SIZE,X
				PLA 
				STA OBJ_SIZE*2,X
				PLA 
				STA 0,X
				
				INX
				DEY
				BNE .rot_loop
			PLA
			TAX
			RTS
	
	WORD_MIN_ROT:
		FCB 4, "-ROT" 		;Name
		FDB	WORD_CLEAR		;Next word
		FCB 12				;ID
		CODE_MIN_ROT:
			FCB MIN_3		;Flags
			
			LDY #OBJ_SIZE
			TXA
			PHA
			.min_rot_loop:
				LDA OBJ_SIZE*2,X
				PHA
				LDA OBJ_SIZE,X
				PHA
				LDA 0,X
				STA OBJ_SIZE*2,X
				PLA 
				STA 0,X
				PLA 
				STA OBJ_SIZE,X
				
				INX
				DEY
				BNE .min_rot_loop
			PLA
			TAX
			RTS
	
	WORD_CLEAR:
		FCB 5,"CLEAR"
		FDB 0
		FCB 14
		CODE_CLEAR:
			FCB 0			;Flags
			LDX #0
			STX stack_count
			RTS
	
	
	JUMP_TABLE:
		FDB 0				;0 - reserved
		FDB CODE_DUP		;2
		FDB CODE_SWAP		;4
		FDB CODE_DROP		;6
		FDB CODE_OVER		;8
		FDB CODE_ROT		;10
		FDB CODE_MIN_ROT	;12
		FDB CODE_CLEAR		;14
		
		