@echo off
setlocal enabledelayedexpansion

REM --- PHAN CAU HINH ---
REM (1) Dat URL THO (Raw URL) cua file phien ban (whatnew.txt)
set "FILE_URL=https://raw.githubusercontent.com/ptmchau2905-commits/teeeee/main/whatnew.txt"

REM (2) Dat ten file ban dang luu tren may (file de so sanh)
set "LOCAL_FILE=whatnew.txt"

REM (3) Dat ten file tam de tai ve (khong can sua)
set "TEMP_FILE=whatnew.temp.txt"
REM --- KET THUC CAU HINH ---

echo [Trinh kiem tra cap nhat]
echo.

REM --- Buoc 1: Kiem tra Dependency (curl) ---
echo [1/5] Kiem tra cong cu 'curl'...
where curl > nul 2> nul
if %errorlevel% neq 0 (
    echo    [LOI!] Khong tim thay 'curl.exe'.
    echo    Day la cong cu can thiet de tai file. Vui long tai 'curl' tai:
    echo    httpsC://curl.se/windows/
    pause
    goto :eof
)
echo    Tim thay 'curl'.

REM --- Buoc 2: Tai phien ban moi nhat vao file TAM ---
echo [2/5] Dang tai file phien ban moi nhat...
REM Xoa file tam neu no ton tai tu lan chay loi truoc
if exist "%TEMP_FILE%" del "%TEMP_FILE%" > nul

curl -L -s -o "%TEMP_FILE%" "%FILE_URL%"
if %errorlevel% neq 0 (
    echo    [LOI!] Khong the tai file. Kiem tra lai URL hoac ket noi mang.
    pause
    goto :eof
)

REM Kiem tra xem file tai ve co bi rong khong
if not exist "%TEMP_FILE%" (
    echo    [LOI!] Tai file that bai, file tam khong duoc tao.
    pause
    goto :eof
)
for %%A in ("%TEMP_FILE%") do if %%~zA equ 0 (
    echo    [LOI!] File tai ve bi rong (0 bytes). Co the URL bi loi hoac repo la private.
    del "%TEMP_FILE%"
    pause
    goto :eof
)
echo    Tai file thanh cong.

REM --- Buoc 3: Doc phien ban MOI (tu file tam) ---
set "NEW_VERSION="
set /p NEW_VERSION=<"%TEMP_FILE%"
if not defined NEW_VERSION (
    echo    [LOI!] Khong the doc duoc noi dung phien ban tu file tai ve.
    del "%TEMP_FILE%"
    pause
    goto :eof
)
echo [3/5] Phien ban moi nhat tren mang: %NEW_VERSION%

REM --- Buoc 4: Doc phien ban HIEN TAI (tu file local) ---
set "CURRENT_VERSION="
if exist "%LOCAL_FILE%" (
    set /p CURRENT_VERSION=<"%LOCAL_FILE%"
)

if not defined CURRENT_VERSION (
    echo [4/5] Khong tim thay phien ban hien tai (Lan dau su dung).
) else (
    echo [4/5] Phien ban hien tai cua ban:   %CURRENT_VERSION%
)

REM --- Buoc 5: So sanh va thuc thi ---
echo [5/5] Dang so sanh phien ban...
echo.

if not defined CURRENT_VERSION (
    REM Truong hop 1: Day la lan dau tien chay (chua co file local)
    echo [THONG BAO]
    echo Day la lan dau ban chay kịch ban nay.
    echo Da tai phien ban moi nhat: %NEW_VERSION%
    REM Doi ten file tam thanh file chinh thuc
    move /Y "%TEMP_FILE%" "%LOCAL_FILE%" > nul

) else if "%CURRENT_VERSION%" == "%NEW_VERSION%" (
    REM Truong hop 2: Phien ban giong nhau (da moi nhat)
    echo [DA MOI NHAT]
    echo Ban dang su dung phien ban moi nhat: %CURRENT_VERSION%
    REM Khong can file tam nua
    del "%TEMP_FILE%"

) else (
    REM Truong hop 3: Phat hien ban moi
    echo [CO CAP NHAT MOI!]
    echo Phat hien phien ban moi!
    echo   > Phien ban cua ban: %CURRENT_VERSION%
    echo   > Phien ban moi:   %NEW_VERSION%
    echo.
    echo Dang cap nhat file '%LOCAL_FILE%'...
    REM Thay the file cu bang file moi
    move /Y "%TEMP_FILE%" "%LOCAL_FILE%" > nul
    echo Da cap nhat thanh cong.
)

echo.
echo Hoan tat!
endlocal
pause
