format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

    msg_result db "Number with the most digits: %d", 0xA, 0x0
    prompt_exit db "Press any key to exit...", 0xA, 0x0

    num1 dd 123     ; Пример чисел
    num2 dd 4567
    num3 dd 89

section '.code' code readable executable

start:
    push ebp
    mov ebp, esp

    ; --- Подсчёт количества цифр ---
    push dword [num1]
    call count_digits
    add esp, 4
    mov esi, eax       ; digits in num1
    mov edi, [num1]    ; предполагаем, что это макс

    push dword [num2]
    call count_digits
    add esp, 4
    cmp eax, esi
    jle .check_num3
    mov esi, eax
    mov edi, [num2]    ; новое макс-число

.check_num3:
    push dword [num3]
    call count_digits
    add esp, 4
    cmp eax, esi
    jle .print_result
    mov edi, [num3]    ; новое макс-число

.print_result:
    push edi           ; Число с наибольшим количеством цифр
    push msg_result
    call [printf]
    add esp, 8

    push prompt_exit
    call [printf]
    add esp, 4

    call [getch]

.cleanup:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

; === Процедура: подсчёт цифр в натуральном числе ===
count_digits:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8] ; число
    mov ecx, 0         ; счётчик

.count_loop:
    inc ecx
    xor edx, edx
    mov ebx, 10
    div ebx
    test eax, eax
    jnz .count_loop

    mov eax, ecx       ; вернуть количество цифр
    pop ebp
    ret

section '.idata' import data readable

    library msvcrt, 'msvcrt.dll'
    import msvcrt, printf, 'printf', getch, '_getch'
