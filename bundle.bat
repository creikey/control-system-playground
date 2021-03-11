if not exist "exports\" mkdir exports
RMDIR /S /Q exports\
mkdir exports
godot --path src --export-debug web ..\exports\index.html
butler push exports/ creikey/control-system-playground:web

if not exist "exports\" mkdir exports
RMDIR /S /Q exports\
mkdir exports
godot --path src --export-debug windows ..\exports\control_system_playground.exe
butler push exports/ creikey/control-system-playground:windows

if not exist "exports\" mkdir exports
RMDIR /S /Q exports\
mkdir exports
godot --path src --export-debug linux ..\exports\control_system_playground.x86_64
butler push exports/ creikey/control-system-playground:linux


echo "Done exporting and uploading"
pause

