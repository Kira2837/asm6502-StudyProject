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
main:
	LDX #$FF
	TXS               ; Инициализируем стек

	; Включаем PPU
	LDA #%10000000    ; NMI включено
	STA $2000
	LDA #%00011110    ; Показываем фон
	STA $2001
	

  ; Заливаем экран чёрным
  JSR FillScreenWithBlack
	
; --- Бесконечный цикл ---
loop:
    jmp loop	

FillScreenWithBlack:
	; Устанавливаем адрес PPU $2000 (начало фоновой карты)
	LDA $2002         ; Сброс PPU
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

  ; Заполняем экран тайлом 0 (чёрный)
	LDX #$00          ; Счётчик
	LDY #$04          ; 4 страницы по 256 байт
	LDA #0            ; Тайл 0 (чёрный)
:
	STA $2007         ; Записываем тайл
	DEX
	BNE :-
	DEY
	BNE :-
	RTS	

NMI:
IRQ:
	RTI
	
.segment "CHARS"
  .incbin "3grafix.chr"  ; Подключаем файл с чёрными тайлами