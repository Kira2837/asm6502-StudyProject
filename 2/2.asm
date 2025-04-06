
tmp = $0200 ; Переменная по адрессу $0200
sum_res = $0201 ; a + b
sub_res = $0202 ; a - b

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
; --- Сложение (5 + 3) ---
    LDA #5        	; A = 5
    PHA             ; Сохраняем 5 в стек (SP = $FE)
    LDA #3        	; A = 3
    PHA             ; Сохраняем 3 в стек (SP = $FD)
	
    PLA             ; Достаём 3 из стека (A = 3, SP = $FE)
    STA tmp         ; Сохраняем в tmp
    PLA             ; Достаём 5 из стека (A = 5, SP = $FF)
    CLC             ; Сбрасываем флаг переноса (С = 0)
    ADC tmp       ; A = 5 + tmp(3) = 8
    STA sum_res		; Сохраняем в sum_res
; --- Вычитание (5 - 3) ---
    LDA #5        	; A = 5
    PHA             ; Сохраняем 5 в стек (SP = $FE)
    LDA #3        	; A = 3
    PHA             ; Сохраняем 3 в стек (SP = $FD)
	
    PLA             ; Достаём 3 (A = 3, SP = $FE)
    STA tmp         ; Сохраняем в tmp
    PLA             ; Достаём 5 (A = 5, SP = $FF)
    SEC             ; Устанавливаем флаг переноса (С = 1)
    SBC tmp         ; A = 5 - tmp(3) = 2
    STA sub_res            ; Сохраняем результат в sub_res
	
; --- Бесконечный цикл ---
loop:
    jmp loop	
NMI:
IRQ:
	RTI