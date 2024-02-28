; exemplo de programa que faz uma soma usando um label/função
_start:
  call main
  end
; ele simplesmente adiciona o valor do registrador 1 e do registrador 2, armazena no registrador 1 e retorna
somar:
  add r1 r2
  return

; função principal (não é necessária, é apenas pra organização)
main:
  icopy_1 2
  icopy_2 3
  call somar ; chama o label somar
  
  ; vamos imprimir o resultado!
  loadservice 1 ; carregamos o serviço de e/s da vm (IoService)
  copy r3 r1 ; copia o resultado da soma do registrador 1 para o registrador 3 (aqui sera o conteudo a ser escrito)
  icopy_1 2 ; indica o subsserviço a ser utilizado (nesse caso, write)
  icopy_2 1 ; indica o descritor do arquivo que queremos escrever (stdout)
  invokeservice ; invoca o subsserviço IoService::write
  return