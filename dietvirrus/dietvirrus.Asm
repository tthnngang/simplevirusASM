.386
.model flat, stdcall  ;32 bit memory model
.stack 100h
option casemap :none  ;case sensitive
include user32.inc
include kernel32.inc
include windows.inc
; Directives for the linker to link libraries
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
.data
	path    db "C:\Users\Ngan\Desktop\dietvirrus\New folder\*.exe", 0 
	win32_find_data     	WIN32_FIND_DATA 	<?>
	FileHandle   			dword 0
	Chuky                   db 0
.code
start:

    push offset win32_find_data
    push offset path 
    call FindFirstFile
    
    push NULL
    push 80h
    push 3
    push NULL
    push FILE_SHARE_READ
    push GENERIC_READ + GENERIC_WRITE
    push offset win32_find_data.cFileName
    call CreateFile
    mov  FileHandle, eax 
    
    
    push 0
    push 0
    push 1eh
    push eax 
    call SetFilePointer
    
    push 0
    push 0
    push 2
    push offset Chuky
    push FileHandle
    call ReadFile 
    
 end start    