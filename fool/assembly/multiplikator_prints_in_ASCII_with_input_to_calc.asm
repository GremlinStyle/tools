section .data
    input_buffer db 256 dup(0)    ; Buffer to hold input
    input_buffer2 db 256 dup(0)    ; Buffer to hold input
    format db '%i', 0             ; Format string for scanf
    prompt db 'Enter first Number: ', 0  ; Prompt message
    prompt2 db 'Enter second Number: ', 0  ; Prompt message
    c db 0
    sum dd 0
    list dd 0               ;List ? use with mov eax,[list+index]
    places dd 0
    dividend dd 12                  ; Reserve 4 bytes for key, initialized to 0
    divisor dd 10
    count dd 0
    tmp dd 0
    newline db '\n', 0
    res dd 0
    res2 dd 0
    op1 dd 7  ; Null-terminated message string
    op2 dd 6 
    
section .bss

section .text
    extern scanf, printf, ExitProcess
    global main

main:
    mov ebp, esp; for correct debugging
    ; Print the prompt message
    push prompt
    call printf
    add esp, 4

    ; Read input from the user
    push input_buffer
    push format
    call scanf
    add esp, 8
    
    mov ebp, esp; for correct debugging
    ; Print the prompt message
    push prompt2
    call printf
    add esp, 4

    ; Read input from the user
    push input_buffer2
    push format
    call scanf
    add esp, 8

    mov eax,[input_buffer]
    mov [op1],eax
    mov eax,[input_buffer2]
    mov [op2],eax
    call mult

    ;mov [sum],eax
    mov eax,[sum]       ;get_length prep
    xor edx,edx         ;get_length prep
    mov ecx,10          ;get_length prep
    call get_length
    
    mov eax,[sum]
    mov [dividend],eax
    
    call dividerloop
    
    call printloop

    ret
    
mult:
    mov eax, [op1]
    add [sum],eax
    mov eax, [sum]  ;debugger check
    
    mov eax,1           ;subtractor
    sub [op2],eax       ;subtract
    mov eax,[op2]       ;debugger check
    
    cmp eax,0
    je exit
    jmp mult
    
get_length:
    ;mov eax,[sum]        ;things needed to be done before
    ;mov ecx,1 
    ;xor edx,edx 
    cmp eax,ecx
    jl done
    imul ecx, 10        ;multiplikator
    inc edx             ;Ergebinis zb 300 => edx = 2
    jmp get_length

done:
    inc edx
    mov [places],edx
    ret
    
exit:
    ret
    
printloop:
    mov ebx,[count]
    cmp ebx,0
    jl exit
    
    mov eax,[list+ebx]
    add eax,48
    mov [tmp],eax
    push    tmp
    call    printf
    add     esp,4
    
    mov ebx,[count]
    sub ebx,4
    mov [count],ebx
    jmp printloop

ret

dividerloop:
    mov esi,[places]
    cmp esi,0
    jl done2
    
    ;divide
    mov eax,[dividend]
    xor edx, edx
    mov ecx, [divisor]
    div ecx             ;division result in eax and rest in edx | rest is into list | eax is new dividend
    mov [dividend],eax
    mov eax,[count]
    mov [res],edx
    
    mov eax,[dividend]     ;last divide manually
    cmp eax,10
    jl line             ;jmp to last divide
    
    mov eax,[count]
    mov edx,[res]
    mov [list+eax],edx

    ;increase counter
    mov eax,[count]
    add eax,4
    mov [count],eax
    
    ;decrease places
    ;mov esi,[places] ????????? esi suddenly 0
    dec esi
    ;mov [places],esi
    
    ;jmp to beginning
    jmp dividerloop
done2:
    ret
line:
    mov eax,[count]
    mov [list+eax],edx
    add edx,48
    
    mov eax,[count]
    add eax,4
    mov [count],eax
    mov edx,[dividend]
    mov [list+eax],edx
    xor eax,eax
    
    ret