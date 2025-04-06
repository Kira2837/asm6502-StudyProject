
tmp = $0200 ; Переменная по адрессу $0200
sum_res = $0201 ; a + b
sub_res = $0203 ; a - b

; a * b
; a / b

.segment "HEADER"
    .byte "NES", $1A  ; Сигнатура файла
    .byte $02         ; 16KB PRG-ROM
    .byte $01         ; 8KB CHR-ROM

.segment "VECTORS" ; Обязательные вектора
    .word NMI    ; Вектор NMI
    .word RESET  ; Вектор сброса
    .word IRQ    ; Вектор IRQ
	
.segment "CODE"
RESET:
	SEI         ; Запретить прерывания
    CLD         ; Отключить десятичный режим (отсуствует в NES)
	
	LDX #$FF        ; Инициализация стека
    TXS             ; SP = $FF
	
main:
; --- Сложение ---
    LDA #5        	; A = 5
    PHA             ; Сохраняем 5 в стек (SP = $FE)
    LDA #253        ; A = 253
    PHA             ; Сохраняем 253 в стек (SP = $FD)
	
    PLA             ; Достаём 253 из стека (A = 3, SP = $FE)
    STA tmp         ; Сохраняем в tmp
    PLA             ; Достаём 5 из стека (A = 5, SP = $FF)
    CLC             ; Сбрасываем флаг переноса (С = 0)
    ADC tmp       	; A = 253 + tmp(5) = 258 (0000 0001 0000 0010)
	BCC no_overflow ; Если C = 0, переполнения не было
    STA sum_res		; Сохраняем в sum_res (учитываем переполнение)
	LDA #$01		; При переполнении помещаем переполненный разряд в следующую ячейку памяти
	LDX #1         	; Смещение = 1
	STA sum_res, X  ; Запись в sum_res + 1 = $0202
	JMP substruction
no_overflow:
	STA sum_res		; Сохраняем в sum_res (без переполнения)
	
substruction:
; --- Вычитание ---
    LDA #3        	; A = 3
    PHA             ; Сохраняем 3 в стек (SP = $FE)
    LDA #5        	; A = 5
    PHA             ; Сохраняем 5 в стек (SP = $FD)
	
    PLA             ; Достаём 5 (A = 5, SP = $FE)
    STA tmp         ; Сохраняем в tmp
    PLA             ; Достаём 3 (A = 3, SP = $FF)
    SEC             ; Устанавливаем флаг переноса (С = 1)
    SBC tmp         ; A = 3 - tmp(5) = -2 ( 1000 0010)
	BCS not_negative; Если C = 1, заема не было
	STA sub_res     ; Сохраняем результат в sub_res (отрицательное число)	
	JMP loop
not_negative:
	STA sub_res     ; Сохраняем результат в sub_res (положительное число)
	
; --- Бесконечный цикл ---
loop:
    jmp loop	
NMI:
IRQ:
	RTI