assemble: 
	#mkdir ./build
	rgbasm -E -o ./build/dma.o ./src/dma.asm
	rgbasm -E -o ./build/main.o ./src/main.asm
	rgbasm -E -o ./build/interrupts.o ./src/interrupts.asm
	rgbasm -E -o ./build/header.o ./src/header.asm
	rgbasm -E -o ./build/counting.o ./src/counting.asm
	rgbasm -E -o ./build/tomato.o ./src/tomato.asm -i include/
	rgbasm -E -o ./build/screen.o ./src/screen.asm
	rgbasm -E -o ./build/input.o ./src/input.asm
	rgbasm -E -o ./build/text.o ./src/text.asm -i include/
	rgblink -o ./build/pomodoro.gb ./build/main.o ./build/counting.o ./build/tomato.o ./build/screen.o ./build/input.o ./build/text.o ./build/interrupts.o ./build/header.o ./build/dma.o
	rgbfix -v -p 0 ./build/pomodoro.gb

clean:
	rm -rf ./build/*

2bpp:
	rgbgfx assets/tomato.png -f -o include/tomato.2bpp