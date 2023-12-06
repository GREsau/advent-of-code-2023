@echo off
setlocal EnableDelayedExpansion

for /F "tokens=1,*" %%a in (input.txt) do (
  if "%%a"=="Time:" set times=%%b
  if "%%a"=="Distance:" set distances=%%b
)

set result=1

:process_pair
set wins=0
for /F "tokens=1,*" %%a in ("%times%") do (
  set time=%%a
  set times=%%b
)
for /F "tokens=1,*" %%a in ("%distances%") do (
  set record_distance=%%a
  set distances=%%b
)
for /L %%h in (0,1,%time%) do (
  set /A traveltime = %time% - %%h
  set /A distance = %%h * !traveltime!
  if !distance! GTR %record_distance% set /A wins += 1
)
if %wins% GTR 0 set /A result *= %wins%
if not "%times%"=="" goto process_pair

echo %result%
