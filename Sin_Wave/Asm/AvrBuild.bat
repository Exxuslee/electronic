@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Lexx\Pro\Project\Sin_Wave\Asm\labels.tmp" -fI -W+ie -o "D:\Lexx\Pro\Project\Sin_Wave\Asm\Sine_wave.hex" -d "D:\Lexx\Pro\Project\Sin_Wave\Asm\Sine_wave.obj" -e "D:\Lexx\Pro\Project\Sin_Wave\Asm\Sine_wave.eep" -m "D:\Lexx\Pro\Project\Sin_Wave\Asm\Sine_wave.map" "D:\Lexx\Pro\Project\Sin_Wave\Asm\Sine_wave.asm"
