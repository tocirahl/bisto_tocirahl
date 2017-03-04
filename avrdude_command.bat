@ECHO OFF
CLS

:MENU
ECHO.
ECHO ...............................................
ECHO ATTINY25 PROGRAMMER
ECHO ...............................................
ECHO.
ECHO 1 - Test Connection
ECHO 2 - Save Firmware on chip to PC
ECHO 3 - Erase Firmware on chip
ECHO 4 - Write Firmware to chip
ECHO 5 - Exit
ECHO.

:RESET
SET M=-1
SET /P M=
IF %M%==1 GOTO TEST
IF %M%==2 GOTO SAVE
IF %M%==3 GOTO ERASE
IF %M%==4 GOTO WRITE
IF %M%==5 EXIT

ECHO Invalid Selection
GOTO RESET

:TEST
ECHO avrdude -p t25 -c usbasp -n
avrdude -v -v -v -v -p t25 -c usbasp -n
GOTO MENU

:SAVE
ECHO avrdude -p t25 -c usbasp -u -Uflash:r:flash-dump.hex:i -Ueeprom:r:eeprom-dump.hex:i -Ulfuse:r:lfuse-dump.hex:i -Uhfuse:r:hfuse-dump.hex:i -Uefuse:r:efuse-dump.hex:i
avrdude -v -v -v -v -p t25 -c usbasp -u -Uflash:r:flash-dump.hex:i -Ueeprom:r:eeprom-dump.hex:i -Ulfuse:r:lfuse-dump.hex:i -Uhfuse:r:hfuse-dump.hex:i -Uefuse:r:efuse-dump.hex:i
GOTO MENU

:ERASE
SET CONTINUE=N
SET /P CONTINUE=Are you sure (y/N)? 
IF NOT %CONTINUE%==y GOTO MENU

ECHO avrdude -p t25 -c usbasp -u -e
avrdude -v -v -v -v -p t25 -c usbasp -u -e
GOTO MENU

:WRITE
SET FIRMWARE=
SET /P FIRMWARE=Hex File:
SET LFUSE=xd2
SET /P LFUSE=Low Fuse (xd2):
SET HFUSE=xde
SET /P HFUSE=High Fuse (xde):
SET EFUSE=xff
SET /P EFUSE=Ext Fuse (xff):

ECHO avrdude -p t25 -c usbasp -u -Uflash:w:%FIRMWARE%:a -Ulfuse:w:%LFUSE%:m -Uhfuse:w:%HFUSE%:m -Uefuse:w:%EFUSE%:m

SET CONTINUE=N
SET /P CONTINUE=Does this look correct (y/N)? 
IF NOT %CONTINUE%==y GOTO MENU

ECHO Writing firmware...
avrdude -v -v -v -v -p t25 -c usbasp -u -Uflash:w:%FIRMWARE%:a -Ulfuse:w:%LFUSE%:m -Uhfuse:w:%HFUSE%:m -Uefuse:w:%EFUSE%:m

GOTO MENU

