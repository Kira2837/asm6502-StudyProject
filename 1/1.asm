.segment "HEADER"
    .byte "NES", $1A  ; Сигнатура
    .byte $02         ; 32KB PRG-ROM (2 банка по 16KB)
    .byte $01         ; 8KB CHR-ROM

.segment "VECTORS" ; Обязательные вектора(метки)
    .word NMI    ; Вектор NMI
    .word RESET  ; Вектор сброса
    .word IRQ    ; Вектор IRQ

.segment "CODE"
NMI:
	RTI
IRQ:
	RTI 		 ; Возврат из прерывания   
RESET:
    ADC #1       ; Добавляем значение 1 к регистру А   
    JMP RESET    ; Прыгаем на метку RESET


