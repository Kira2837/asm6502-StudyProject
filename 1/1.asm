
tmp = $0200 ; Переменная по адрессу $0200

.segment "HEADER"
    .byte "NES", $1A  ; Сигнатура файла
    .byte $02         ; 16KB PRG-ROM
    .byte $01         ; 8KB CHR-ROM

.segment "VECTORS" ; Обязательные вектора
    .word NMI    ; Вектор NMI
    .word RESET  ; Вектор сброса
    .word IRQ    ; Вектор IRQ
	
.segment "CODE"
NMI:
IRQ:
	RTI 		 ; Возврат из прерывания 
RESET:
	SEI         ; Запретить прерывания
    CLD         ; Отключить десятичный режим
	LDA #0 		; Пишем число 0 в регистр А
	STA tmp 	; загружаем значение регистра A в переменную tmp
	
main_loop:
	LDA tmp 	; загружаем значение из tmp в регистр A
	CLC         ; Сбрасываем флаг переноса!
    ADC #1      ; Добавляем значение 1 к регистру А   
	STA tmp 	; загружаем значение регистра A в переменную tmp
    JMP main_loop   ; Прыгаем на метку main_loop


