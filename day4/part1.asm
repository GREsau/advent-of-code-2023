stdin           equ 0
stdout          equ 1
stderr          equ 2
sys_read        equ 0  ; read(fd, buf, count)
sys_write       equ 1  ; write(fd, buf, count)
sys_mmap        equ 9  ; mmap(addr, length, prot, flags, fd, offset)
sys_exit        equ 60 ; exit(error_code)
prot_read       equ 1
prot_write      equ 2
map_private     equ 2
map_anonymous   equ 32

; r12 stores address of current input char
; r13 stores total score
; stack stores 104-byte (13 qword) set of winning numbers

byteset_lenb equ 104
byteset_lenq equ byteset_lenb/8

%macro bail_if_rax_negative 0
  cmp rax,0
  jge %%ok
  mov rdi,rax
  mov rax,sys_exit
  syscall
  %%ok:
%endmacro

section .text
  global  _start

; Print unsigned decimal representation of rax to stdout with trailing newline
print_rax:
  mov byte [rsp-1],`\n`
  mov rsi,-1        ; number of chars to print (negated)
  mov rdi,10        ; divisor
  .loop:
  mov rdx,0
  div rdi
  add dl,'0'        ; convert remainder from number to char
  dec rsi           ; one more char to print
  mov [rsp+rsi],dl
  test rax,rax
  jnz .loop
  mov rax,sys_write
  mov rdx,rsi       ; arg2: number of chars to print, un-negated on next line
  neg rdx
  add rsi,rsp       ; arg1: pointer to message to write
  mov rdi,stdout    ; arg0: fd
  syscall
  bail_if_rax_negative
  ret

skip_spaces:
  cmp byte [r12],' '
  jne .ret
  inc r12
  jmp skip_spaces
  .ret: ret

; Parses a 1-digit or 2-digit decimal number at [r12]
; Assumes char following number is <'0' (e.g. \0 \n space)
; Result is in al
parse_number:
  xor rax,rax
  mov al,[r12]
  sub al,'0'
  inc r12
  cmp byte [r12],'0'
  jl .ret
  mov ah,10
  mul ah
  add al,[r12]
  sub al,'0'
  inc r12
  .ret: ret

_start:
  xor r13,r13
  sub rsp,byteset_lenb

  ; Allocate 1MB, storing start address in r12
  mov rax,sys_mmap ; mmap(addr, length, prot, flags, fd, offset)
  mov rdi,0
  mov rsi,1024*1024
  mov rdx,prot_read|prot_write
  mov r10,map_private|map_anonymous
  mov r8,-1
  mov r9,0
  syscall
  bail_if_rax_negative
  mov r12,rax

  ; Read stdin into buffer at r12, appending two null bytes
  mov rdi,stdin
  mov rsi,r12
  mov rdx,1024*1024
  mov rax,sys_read
  syscall
  bail_if_rax_negative
  mov word [r12+rax],0

read_line:
  cmp byte [r12],0
  je end ; found null byte - we're done!
  .find_colon:
  inc r12
  cmp byte [r12],':'
  jne .find_colon
  inc r12 ; skip :
  call skip_spaces
populate_set:
  add rsp,byteset_lenb
  times byteset_lenq push 0 ; clear byteset
  .loop:
  call parse_number
  inc byte [rsp+rax]
  call skip_spaces
  cmp byte [r12],'|'
  jne .loop
  inc r12 ; skip |
  mov rbx,1 ; this ticket's score (doubled - needs halving+truncating before use)
check_numbers:
  cmp byte [r12],`\n`
  jle ticket_done
  call skip_spaces
  call parse_number
  cmp byte [rsp+rax],0
  jz check_numbers ; loser - check next number
  sal rbx,1 ; winner! double ticket score then check next number
  jmp check_numbers
ticket_done:
  inc r12 ; skip \n (or first null byte)
  sar rbx,1
  add r13,rbx
  jmp read_line

end:
  mov rax,r13
  call print_rax
  mov rdi,0
  mov rax,sys_exit
  syscall