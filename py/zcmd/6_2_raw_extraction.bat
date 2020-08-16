REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM extract all files from nsp\xci on raw mode
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
cls
call "%nscb_logos%" "program_logo"
echo -----------------------------------------------
echo EXTRACT FILES FROM NSP\XCI ON RAW MODE
echo -----------------------------------------------
if exist "%list_folder%\6_2list.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del "%list_folder%\6_2list.txt" )
endlocal
if not exist "%list_folder%\6_2list.txt" goto manual_INIT
ECHO .......................................................
ECHO A PREVIOUS LIST WAS FOUND. WHAT DO YOU WANT TO DO?
:prevlist0
ECHO .......................................................
echo Input "1" to auto-start processing from the previous list
echo Input "2" to erase list and make a new one.
echo Input "3" to continue building the previous list
echo .......................................................
echo NOTE: By pressing 3 you'll see the previous list
echo before starting the processing the files and you will
echo be able to add and delete items from the list
echo.
ECHO *************************************************
echo Or Input "0" to return to the MODE SELECTION MENU
ECHO *************************************************
echo.
set /p bs="Enter your choice: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto showlist
if /i "%bs%"=="2" goto delist
if /i "%bs%"=="1" goto dostart
if /i "%bs%"=="0" call "%main_program%"
echo.
echo BAD CHOICE
goto prevlist0
:delist
del "%list_folder%\6_2list.txt" 2>&1>NUL
cls
call "%nscb_logos%" "program_logo"
echo -----------------------------------------------
echo INDIVIDUAL PROCESSING ACTIVATED
echo -----------------------------------------------
echo ..................................
echo YOU'VE DECIDED TO START A NEW LIST
echo ..................................
:manual_INIT
endlocal
ECHO ***********************************************
echo Input "1" to add folder to list via selector
echo Input "2" to add file to list via selector
echo Input "3" to add files to list via local libraries
echo Input "4" to add files to list via folder-walker
echo Input "0" to return to the MODE SELECTION MENU
ECHO ***********************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz nsx -tfile "%list_folder%\6_2list.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" call "%main_program%"
if /i "%eval%"=="1" ( %pycommand% "%sq_lc%" -lib_call listmanager selector2list -xarg "%list_folder%\6_2list.txt" mode=folder ext="nsp xci nsz xcz nsx" ) 2>&1>NUL
if /i "%eval%"=="2" ( %pycommand% "%sq_lc%" -lib_call listmanager selector2list -xarg "%list_folder%\6_2list.txt" mode=file ext="nsp xci nsz xcz nsx" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%sq_lc%" -lib_call picker_walker select_from_local_libraries -xarg "%list_folder%\6_2list.txt" "extlist=nsp xci nsz xcz nsx" )
if /i "%eval%"=="4" ( %pycommand% "%sq_lc%" -lib_call picker_walker get_files_from_walk -xarg "%list_folder%\6_2list.txt" "extlist=nsp xci nsz xcz nsx" )
goto checkagain
echo.
:checkagain
echo WHAT DO YOU WANT TO DO?
echo ......................................................................
echo "DRAG ANOTHER FILE OR FOLDER AND PRESS ENTER TO ADD ITEMS TO THE LIST"
echo.
echo Input "1" to start processing
echo Input "2" to add another folder to list via selector
echo Input "3" to add another file to list via selector
echo Input "4" to add files to list via local libraries
echo Input "5" to add files to list via folder-walker
echo Input "e" to exit
echo Input "i" to see list of files to process
echo Input "r" to remove some files (counting from bottom)
echo Input "z" to remove the whole list
echo ......................................................................
ECHO *************************************************
echo Or Input "0" to return to the MODE SELECTION MENU
ECHO *************************************************
echo.
%pycommand% "%squirrel%" -t nsp xci nsz xcz nsx -tfile "%list_folder%\6_2list.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" call "%main_program%"
if /i "%eval%"=="1" goto dostart
if /i "%eval%"=="2" ( %pycommand% "%sq_lc%" -lib_call listmanager selector2list -xarg  "%list_folder%\6_2list.txt" mode=folder ext="nsp xci nsz xcz nsx" ) 2>&1>NUL
if /i "%eval%"=="3" ( %pycommand% "%sq_lc%" -lib_call listmanager selector2list -xarg  "%list_folder%\6_2list.txt" mode=file ext="nsp xci nsz xcz nsx" )  2>&1>NUL
if /i "%eval%"=="4" ( %pycommand% "%sq_lc%" -lib_call picker_walker select_from_local_libraries -xarg "%list_folder%\6_2list.txt" "extlist=nsp xci nsz xcz nsx" )
if /i "%eval%"=="5" ( %pycommand% "%sq_lc%" -lib_call picker_walker get_files_from_walk -xarg "%list_folder%\6_2list.txt" "extlist=nsp xci nsz xcz nsx" )
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del ("%list_folder%\6_2list.txt") 2>&1>NUL

goto checkagain

:r_files
set /p bs="Input the number of files you want to remove (from bottom): "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:update_list1
if !pos1! GTR !pos2! ( goto :update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :update_list1
:update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<lists/6_2list.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>lists/6_2list.txt.new
endlocal
move /y "lists/6_2list.txt.new" "lists/6_2list.txt" >nul
endlocal

:showlist
cls
call "%nscb_logos%" "program_logo"
ECHO -------------------------------------------------
ECHO                 FILES TO PROCESS
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo YOU'VE ADDED !conta! FILES TO PROCESS
echo .................................................
endlocal

goto checkagain

:s_cl_wrongchoice
echo wrong choice
echo ............

:dostart
cls
call "%nscb_logos%" "program_logo"
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (lists/6_2list.txt) do (
%pycommand% "%squirrel%" %buffer% -o "%prog_dir%NSCB_extracted" -tfile "%prog_dir%lists/6_2list.txt" -raw_x ""
%pycommand% "%squirrel%" --strip_lines "%prog_dir%lists/6_2list.txt"
call "%nscb_tools%" "contador" "6_2list.txt"
)
ECHO ---------------------------------------------------
ECHO *********** ALL FILES WERE PROCESSED! *************
ECHO ---------------------------------------------------
goto s_exit_choice

:s_exit_choice
call "%nscb_tools%" "delete_if_empty" "6_2list.txt"
if /i "%va_exit%"=="true" echo PROGRAM WILL CLOSE NOW
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Input "0" to go back to the mode selection
echo Input "1" to exit the program
echo.
set /p bs="Enter your choice: "
set bs=%bs:"=%
if /i "%bs%"=="0" call "%main_program%"
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:salida
::pause
exit