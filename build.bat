
@echo Assembling...
@mkdir build
ca65 main.s -o .\build\game.o
@IF ERRORLEVEL 1 GOTO failure
@echo Linking...
ld65 -o .\build\game.nes -C mem_segments.cfg .\build\game.o
@IF ERRORLEVEL 1 GOTO failure
@echo Success!
@GOTO endbuild
:failure
@echo Build failed. Make sure you've installed cc65 and included it's bin dir in your Path
:endbuild
@pause