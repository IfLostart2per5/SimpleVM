# SimpleVM
Uma VM (Virtual Machine) de propósito geral feita com LuaJIT.

## Objetivo
Fazer uma plataforma de execução de código simples, veloz e fácil de entender, para executar códigos de maneira satisfatória

## Exemplo
Um exemplo simples do assembly dessa VM:

```

_start:
  call main
  icopy_1 1
  exit

; Simplesmente adiciona o valor do registrador 1 e do registrador 2, armazena no registrador 1 e retorna
somar:
  add r1 r2
  return


main:
  icopy_1 2
  icopy_2 3
  call somar ; chama o label somar
  
  ; Vamos imprimir o resultado!
  loadservice 1 ; carregamos o serviço de E/S da VM (IoService)
  copy r3 r1 ; copia o resultado da soma do registrador 1 para o registrador 3 (aqui será o conteúdo a ser escrito)
  icopy_1 2 ; indica o subsserviço a ser utilizado (nesse caso, write)
  icopy_2 1 ; indica o descritor do arquivo que queremos escrever (stdout)
  invokeservice ; invoca o subsserviço IoService::write
  return
```

Mais exemplos podem ser vistos [aqui](./examples).
