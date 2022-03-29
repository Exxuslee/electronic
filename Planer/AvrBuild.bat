@ECHO OFF
del "e:\lexx\planer\planer.map"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler\avrasm32.exe" -fI  -o "e:\lexx\planer\planer.hex" -d "e:\lexx\planer\planer.obj" -e "e:\lexx\planer\planer.eep" -I "C:\Program Files\Atmel\AVR Tools\AvrAssembler\Appnotes" -w  -m "e:\lexx\planer\planer.map" "E:\Lexx\Planer\planer_zemlq.asm"
