.usei64

_start:
  call main
  icopy_1 0
  exit

print:
  newframe
  store_3 ; carrega o valor do registrador 3 na pilha
  copy r3 r1
  store_1
  store_2
  loadservice 1 ; carrega o serviço de IO
  icopy_1 2 ; define a operacao (write)
  icopy_2 1 ; define o descritor de arquivo (stdout)
  ; o conteudo a ser escrito ja esta no registrador 3
  invokeservice
  load_3 1 ; carrega o primeiro valor da pilha no registrador 3
  load_2 3 ; carrega o terceiro valor da pilha no registrador 2
  load_1 2
  popframe
  return

main:
  icopy_1 2000000000
  icopy_2 3000000000
  add r1 r2
  call print
  return
  