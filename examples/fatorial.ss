; exemplo de programa que calcula fatorial de maneira recursiva na SimpleVM
_start:
  call main
  end

fatorial:
  newframe
  store_1
  icopy_2 0
  compare r1 r2
  jump_if_eq basecase

  isub_1 1
  call fatorial
  load_2 1
  mul r1 r2
  popframe
  return

  basecase:
    icopy_1 1
    popframe
    return

main:
  icopy_1 20
  call fatorial

  loadservice 1 ; carrega o serviçp de IO (IoService)
  copy r3 r1 ; (copia o resultado do calculo pro registrador 3 (onde vai estar o conteudo a ser impresso))
  icopy_1 2 ; indica o subsserviço de IoService (write)
  icopy_2 1 ; indica o descritor de arquivo (stdout)
  invokeservice ; invoca o subsservço IoService::write
  return
