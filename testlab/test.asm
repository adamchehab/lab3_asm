format PE console

entry Start

include 'C:\fasmw17327\INCLUDE\win32a.inc'

; section for initialising variables
section '.data' data readable writable
    strA db 'Enter A: ', 0
    strC db 'Enter C: ', 0
    strD db 'Enter D: ', 0

    resStr db 'Result: %d', 0

    a dd 12
    c dd 20
    d dd 20
    res dd ?


; section for code
section '.code' code readable executable

    Start:
        ; (2c + d – 52) / (a/4 + 1)

        ; (2c + d – 52)
        mov eax, [c]
        mov ebx, 2
        imul ebx
        add eax, [d]
        sub eax, 52
        mov ebx, eax
        ; (now in EBX)

        ;ecx=(a/4-1)
        mov eax, [a]
        cdq
        mov ecx, 4
        idiv ecx
        sub eax, 1
        mov ecx, eax
        ; (now in ECX)

        ;eax=(2*c-d+23)/(a/4-1)
        mov eax, ebx
        idiv ecx
        ; (now in EAX)

        ; move eax to res
        mov [res], eax

        ; output result
        push [res]
        push resStr
        call [printf]

        ; prevent window from closing
        call [getch]                

        ; leave programm
        push 0
        call [ExitProcess]

; section for libraries
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'
        
    import  kernel,\
            ExitProcess, 'ExitProcess'

    import  msvcrt,\
            printf, 'printf',\
            scanf, 'scanf',\
            getch, '_getch'