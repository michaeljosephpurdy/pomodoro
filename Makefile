assemble: 
	#mkdir ./build
	rgbasm -o ./build/main.o ./src/main.asm -i include/
	rgbasm -o ./build/counting.o ./src/counting.asm
	rgbasm -o ./build/tomato.o ./src/tomato.asm
	rgblink -o ./build/pomodoro.gb ./build/main.o ./build/counting.o ./build/tomato.o
	rgbfix -v -p 0 ./build/pomodoro.gb

clean:
	rm -rf ./build/*
