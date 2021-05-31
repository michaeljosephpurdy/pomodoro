assemble: 
	#mkdir ./build
	rgbasm -o ./build/dma.o ./src/dma.asm -E
	rgbasm -o ./build/main.o ./src/main.asm -E
	rgbasm -o ./build/interrupts.o ./src/interrupts.asm -E
	rgbasm -o ./build/header.o ./src/header.asm -E
	rgbasm -o ./build/counting.o ./src/counting.asm -E
	rgbasm -o ./build/tomato.o ./src/tomato.asm -i include/ -E
	rgbasm -o ./build/screen.o ./src/screen.asm -E
	rgbasm -o ./build/input.o ./src/input.asm -E
	rgbasm -o ./build/math.o ./src/math.asm -E
	rgbasm -o ./build/text.o ./src/text.asm -i include/ -E
	rgblink -o ./build/pomodoro.gb ./build/main.o ./build/counting.o ./build/tomato.o ./build/screen.o ./build/input.o ./build/text.o ./build/interrupts.o ./build/header.o ./build/dma.o ./build/math.o
	rgbfix -v -p 0 ./build/pomodoro.gb

clean:
	rm -rf ./build/*

2bpp:
	rgbgfx assets/tomato.png -f -o include/tomato.2bpp