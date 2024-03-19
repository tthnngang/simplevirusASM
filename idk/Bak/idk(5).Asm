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
	path    				db 					100 dup (0)
	win32_find_data     	WIN32_FIND_DATA 	<?>
	e db "*.exe",0
	Chuky                   word 0
	_3ch					word 0
	NumberSec				word 0
	W	                    dword 0
	NewSizeImage			dword 0
	newFZ					dword 0
	FileHandle   			dword 0
	SizeofImage				dword 0
	FFFhandle				dword 0
	PERVA					dword 0
	PEVA					dword 0
	khoangcach				dword 0
	VS 						dword 0
	RS						dword 0
	VA						dword 0
	RA						dword 0
	filesize 				dword 0
	ImageBase				dword 0
	filehandle2				dword 0
	dem  dword 0
.code
start:
    push 260
    push offset path 
    push NULL
    call GetModuleFileName
    mov  dem, eax 
timpath:
	lea  eax, path 
	mov  ecx, 0 
	mov  ebx , dem 
	add  eax , ebx 
timpath1:
	mov  cl, [eax]
	cmp  ecx, 5ch
	je   themexe
	dec   eax 
	jmp timpath1
themexe:
	lea  ebx, e 
	inc  eax 
themeze:
	mov  cl , [ebx]
	cmp  ecx, 0 
	je   FFF
	mov  [eax], cl 
	inc   eax 
	inc ebx 
	jmp themeze 
FFF:
    mov  [eax], cx
    push offset win32_find_data
    push offset path 
    call FindFirstFile
    
    mov  FFFhandle, eax 
    cmp  eax, 0 
    je   hetfile 
    jmp  layduongdan
    
layduongdan:
	lea  eax, path 
	mov  ebx, dem 
	add  eax, ebx 
	mov ebx, 0
khoc1:
	mov bl , [eax]
	cmp ebx , 2ah 
	je  themten 
	dec  eax 
	jmp khoc1 
themten:
	lea edx, win32_find_data
	add edx , 44 
	mov  ebx, 0
themten2:
	mov  bl , [edx]
	cmp  ebx,0
	je  createfile
	mov [eax],bl
	inc  edx 
	inc  eax 
	jmp  themten2  
	  
findnext: 
 	
    push offset win32_find_data
    push FFFhandle
    call FindNextFile
    cmp  eax, 0 
    je   hetfile
     
layduongdan2:
	lea  eax, path 
	mov ebx, 0
timcuoipath:
	mov  bl, [eax]
	cmp  ebx, 0 
	je   khoc12
	inc  eax 
	jmp  timcuoipath
khoc12:
	mov bl , [eax]
	cmp ebx , 5ch 
	je  themten222 
	dec  eax 
	jmp khoc12 
themten222:
	lea edx, win32_find_data
	add edx , 44 
	mov  ebx, 0
	inc eax 
themten22:
	mov  bl , [edx]
	cmp  ebx,0
	je  createfile
	mov [eax],bl
	inc  edx 
	inc  eax 
	jmp  themten22    

createfile: 

    
	mov [eax], bl 
    push NULL
    push 80h
    push 3
    push NULL
    push FILE_SHARE_READ
    push GENERIC_READ + GENERIC_WRITE
    push offset path
    call CreateFile
    mov  FileHandle, eax 
    
    cmp  eax, 00FFFFFFFFh
    je   findnext
    
    push MB_OK
	push offset path
	push NULL
	push NULL
    call MessageBox
   
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
    
    lea  eax, Chuky
    mov  ecx, 0
    mov  cx, [eax]  
    mov  ebx, 15f7h
    cmp  ebx, ecx 
    jne  findnext
    ;mov   ecx, 0 
    ;mov  [eax], cx
    
    invoke SetFilePointer, FileHandle ,3ch, 0,0
    invoke ReadFile,FileHandle, offset _3ch, 2, 0,0

 ; sizeofimage    
    push 0
    push 0
    mov  eax, 0
    mov  ax , _3ch
    add  eax , 50h 
    push eax
    push FileHandle 
    call SetFilePointer
    
    push 0
    push 0
    push 4
    push  offset SizeofImage; pointer
    push FileHandle
    call ReadFile
    
    
equal:

	push 40h 
	push 3000h
	push SizeofImage
	push NULL
    call VirtualAlloc
    mov  ImageBase, eax 
    
; file size    
    push NULL
	push FileHandle 
 	call GetFileSize
 	
 	mov  newFZ, eax 
; map    
    push 0
    push 0
    push 0
    push FileHandle 
    call SetFilePointer
    
    push 0
    push 0
    push newFZ
    push ImageBase
    push FileHandle
    call ReadFile
    
    push FileHandle
 	call CloseHandle
    
    ; tim sectioncuoi 
    
    mov eax, ImageBase
    add eax, 3ch 
    mov eax, [eax]
    mov PERVA, eax 
    mov eax, ImageBase
    mov ebx , PERVA
    add eax, ebx 
    mov PEVA, eax 
    add eax, 6h
    mov  ebx, 0
    mov bx, [eax]
    mov NumberSec,bx
    
     
;khoangcach vs section cuoi 
	mov  ebx, 0 
	mov  bx, NumberSec
	mov  ecx, 0 
	
addition:
	add  ecx, 28h	
	dec  ebx 
	cmp  ebx, 1
	je   sectioncuoi  
	jmp  addition
sectioncuoi: 
	mov  eax, PEVA
	add  eax, 0f8h
	add  eax, ecx 
	add  eax, 8 
	mov  ebx, [eax]
	mov  VS, ebx
	add  eax, 4
	mov  ebx, [eax]
	mov  VA, ebx
	add  eax, 4
	mov  ebx,  [eax]
	mov  RS, ebx 
	add  eax, 4 ;raw address
	mov  eax, [eax]
	mov  RA, eax
; sua sign 
	mov  ebx, ImageBase
	add  ebx, 1eh
	mov  cx, 0
	mov  [ebx],cx

; sua entrypoint	 
	mov  ebx, ImageBase
	mov  eax, RA
	add  eax, ebx ; imagebase + entrypoint 
	
	add  eax, 11h ; khoangcach vs ex entrypoint 
	mov  ecx, 0
	mov  ecx, [eax]
	;mov  khoangcach , cx	

	mov  ebx, VA
	sub  ebx, ecx 
	
	mov  eax, PEVA
 	add  eax, 28h
 	mov  [eax],ebx
     
; sua so section 
	mov  eax, PEVA
	add  eax,6
	mov  ebx, 0
	mov  bx, NumberSec
	dec  ebx 
	mov  [eax], bx
	
; size of image 
    mov  eax, SizeofImage
    mov  ebx, VS
    sub  eax, ebx 
    mov  NewSizeImage, eax
    mov  ebx, PEVA
    add  ebx, 50h
    mov  [ebx],eax 
;sua section header 
; tim sectioncuoi 

    
     
;khoang cach vs section cuoi 
	mov  ebx, 0 
	mov  bx , NumberSec
	mov  ecx, 0 
	
addition2:
	add  ecx, 28h	
	dec  ebx 
	cmp  ebx, 1
	je   sectioncuoi2  
	jmp  addition2
sectioncuoi2: 
	mov  eax, PEVA
	add  eax, 0f8h
	add  eax, ecx   
	mov  ecx, 0 
	mov  ebx, 0
	mov  ebx, 40
sectioncuoi3:
	mov  [eax], ecx
	sub  ebx , 4
	add  eax, 4 
	cmp  ebx, 0 
	jle  a
	jmp  sectioncuoi3
; o day
a:
	push NULL
    push 80h
    push 2
    push NULL
    push FILE_SHARE_READ
    push GENERIC_READ + GENERIC_WRITE
    push offset win32_find_data.cFileName;?????
    call CreateFile
    mov  filehandle2, eax 
    
  	
writeF:
	push 0
	push 0	
	push 0
	push filehandle2
	call SetFilePointer
	
	push NULL
	push offset W
	push RA
	push ImageBase
	push filehandle2 
    call WriteFile
	
	push filehandle2
 	call CloseHandle
 	
    jmp  findnext
hetfile:
	;push NULL
	;call GetModuleHandle
	;push eax 
	;call CloseHandle
	push MB_OK
	push offset e
	push NULL
	push NULL
    call MessageBox
    
 end start      