format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

    msg_result db "Number with the most digits: %d", 0xA, 0x0
    prompt_exit db "Press any key to exit...", 0xA, 0x0

    num1 dd 123     ; ������ �����
    num2 dd 4567
    num3 dd 89

section '.code' code readable executable

start:
    push ebp
    mov ebp, esp

    ; --- ������� ���������� ���� ---
    push dword [num1]
    call count_digits
    add esp, 4
    mov esi, eax       ; digits in num1
    mov edi, [num1]    ; ������������, ��� ��� ����

    push dword [num2]
    call count_digits
    add esp, 4
    cmp eax, esi
    jle .check_num3
    mov esi, eax
    mov edi, [num2]    ; ����� ����-�����

.check_num3:
    push dword [num3]
    call count_digits
    add esp, 4
    cmp eax, esi
    jle .print_result
    mov edi, [num3]    ; ����� ����-�����

.print_result:
    push edi           ; ����� � ���������� ����������� ����
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

; === ���������: ������� ���� � ����������� ����� ===
count_digits:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8] ; �����
    mov ecx, 0         ; �������

.count_loop:
    inc ecx
    xor edx, edx
    mov ebx, 10
    div ebx
    test eax, eax
    jnz .count_loop

    mov eax, ecx       ; ������� ���������� ����
    pop ebp
    ret

section '.idata' import data readable

    library msvcrt, 'msvcrt.dll'
    import msvcrt, printf, 'printf', getch, '_getch'
