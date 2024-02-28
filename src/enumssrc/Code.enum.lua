Code = {
  "END",
  --instrucoes de copia
  --  aqui vai seguir um padrao, onde o numero definido K representa o registrador e T o tipo de dado: TCOPY_K (T pode ser I(nteger), F(loat), e S(tring))
  --  tambem, tera a instrucao de copia entre registradores, representadas por COPY, onde tera dois operandos: K e Y, onde K é o destino e Y a origem
  "ICOPY_1",
  "ICOPY_2",
  "ICOPY_3",
  "ICOPY_4",
  "ICOPY_5",
  "ICOPY_6",
  "ICOPY_7",
  "ICOPY_8",

  "FCOPY_1",
  "FCOPY_2",
  "FCOPY_3",
  "FCOPY_4",
  "FCOPY_5",
  "FCOPY_6",
  "FCOPY_7",
  "FCOPY_8",

  "SCOPY_1",
  "SCOPY_2",
  "SCOPY_3",
  "SCOPY_4",
  "SCOPY_5",
  "SCOPY_6",
  "SCOPY_7",
  "SCOPY_8",

  "COPY",
  --operacoes aritmeticas
  --  ADD seguira um padrao semelhante, mas, sera o seguinte:
  --    ADD = soma o valor de dois registradores indicados nos operandos e armazena o resultado no primeiro operando
  --    TADD_K = adiciona um valor bruto do tipo T ao registrador K
  "ADD",
  "IADD_1",
  "IADD_2",
  "IADD_3",
  "IADD_4",
  "IADD_5",
  "IADD_6",
  "IADD_7",
  "IADD_8",

  "FADD_1",
  "FADD_2",
  "FADD_3",
  "FADD_4",
  "FADD_5",
  "FADD_6",
  "FADD_7",
  "FADD_8",
  -- outras operacoes tambem seguirao o mesmo padrao de ADD

  "MUL",
  "IMUL_1",
  "IMUL_2",
  "IMUL_3",
  "IMUL_4",
  "IMUL_5",
  "IMUL_6",
  "IMUL_7",
  "IMUL_8",

  "FMUL_1",
  "FMUL_2",
  "FMUL_3",
  "FMUL_4",
  "FMUL_5",
  "FMUL_6",
  "FMUL_7",
  "FMUL_8",


  "SUB",
  "ISUB_1",
  "ISUB_2",
  "ISUB_3",
  "ISUB_4",
  "ISUB_5",
  "ISUB_6",
  "ISUB_7",
  "ISUB_8",

  "FSUB_1",
  "FSUB_2",
  "FSUB_3",
  "FSUB_4",
  "FSUB_5",
  "FSUB_6",
  "FSUB_7",
  "FSUB_8",

  "DIV",
  "IDIV_1",
  "IDIV_2",
  "IDIV_3",
  "IDIV_4",
  "IDIV_5",
  "IDIV_6",
  "IDIV_7",
  "IDIV_8",

  "FDIV_1",
  "FDIV_2",
  "FDIV_3",
  "FDIV_4",
  "FDIV_5",
  "FDIV_6",
  "FDIV_7",
  "FDIV_8",

  "MOD",
  "IMOD_1",
  "IMOD_2",
  "IMOD_3",
  "IMOD_4",
  "IMOD_5",
  "IMOD_6",
  "IMOD_7",
  "IMOD_8",

  "FMOD_1",
  "FMOD_2",
  "FMOD_3",
  "FMOD_4",
  "FMOD_5",
  "FMOD_6",
  "FMOD_7",
  "FMOD_8",


  --Operadores relacionais: a mesma coisa
  "EQ",
  "IEQ_1",
  "IEQ_2",
  "IEQ_3",
  "IEQ_4",
  "IEQ_5",
  "IEQ_6",
  "IEQ_7",
  "IEQ_8",

  "FEQ_1",
  "FEQ_2",
  "FEQ_3",
  "FEQ_4",
  "FEQ_5",
  "FEQ_6",
  "FEQ_7",
  "FEQ_8",

  "SEQ_1",
  "SEQ_2",
  "SEQ_3",
  "SEQ_4",
  "SEQ_5",
  "SEQ_6",
  "SEQ_7",
  "SEQ_8",

  "NE",
  "INE_1",
  "INE_2",
  "INE_3",
  "INE_4",
  "INE_5",
  "INE_6",
  "INE_7",
  "INE_8",
  
  "FNE_1",
  "FNE_2",
  "FNE_3",
  "FNE_4",
  "FNE_5",
  "FNE_6",
  "FNE_7",
  "FNE_8",

  "SNE_1",
  "SNE_2",
  "SNE_3",
  "SNE_4",
  "SNE_5",
  "SNE_6",
  "SNE_7",
  "SNE_8",

  "GT",
  "IGT_1",
  "IGT_2",
  "IGT_3",
  "IGT_4",
  "IGT_5",
  "IGT_6",
  "IGT_7",
  "IGT_8",

  "FGT_1",
  "FGT_2",
  "FGT_3",
  "FGT_4",
  "FGT_5",
  "FGT_6",
  "FGT_7",
  "FGT_8",

  "LT",
  "ILT_1",
  "ILT_2",
  "ILT_3",
  "ILT_4",
  "ILT_5",
  "ILT_6",
  "ILT_7",
  "ILT_8",

  "FLT_1",
  "FLT_2",
  "FLT_3",
  "FLT_4",
  "FLT_5",
  "FLT_6",
  "FLT_7",
  "FLT_8",

  -- operadores bitwise: quase a mesma coisa, exceto q nao aceitam outros tipos de dados alem de inteiros
  --, logo, nao tera um T antes do nome da instrução. (assumindo que o valor seguinte é inteiro)

  "OR",
  "OR_1",
  "OR_2",
  "OR_3",
  "OR_4",
  "OR_5",
  'OR_6',
  "OR_7",
  "OR_8",

  "AND",
  "AND_1",
  "AND_2",
  "AND_3",
  "AND_4",
  "AND_5",
  'AND_6',
  "AND_7",
  "AND_8",

  --not simplesmente recebe como operando o registrador alvo, e nao dois, logo, so tem uma unica instrucao pra ele
  "NOT",

  --LOADNAN carrega o valor especial NaN no registrador especificado (atualmente, ele faz um 0 / 0 pra obter esse valor)
  "LOADNAN",
  
  --especial: COMPARE
  --  esse faria o mesmo que outras instrucoes relacionais fariam, com as diferenças de:
  --  1. Ele só subtrai um valor do outro e ver oque que dá
  --  2. ao inves de armazenar o resultado num registrador, ele so manipula algumas flags da vm, das quais sao lidas por instrucoes de salto condicionais
  --  3. caso o tipo de um dos operandos forem strings, os operandos sao transformados no tamanho das strings (entao cuidado ao comparar numeros e strings sem se verificar ksks)
  "COMPARE",

  --manipulacao da pilha de chamadas
  --  aqui tera instrucoes que manipulam a pilha de chamadas e as chamadas em si, como armazenamento de nomes, as chamadas propriamente ditas, etc.

  "NEWFRAME",
  "POPFRAME",

  --STORE seguira um padrao semelhante as operacoes aritmeticas:
  --  TSTORE = armazena o valor bruto do tipo T na pilha
  --  STORE_K = armazena o valor do registrador K na pilha
  --oque store faz é simplesmente empilhar um valor no frame atual, para posterior consulta (geralmente compiladores sao capazes de saber o indice correto da variavel nessa pilha)
  "ISTORE",
  "FSTORE",
  "SSTORE",

  "STORE_1",
  "STORE_2",
  "STORE_3",
  "STORE_4",
  "STORE_5",
  "STORE_6",
  "STORE_7",
  "STORE_8",

  --LOAD so tera a forma LOAD_K, onde K representa o registrador de destino

  --   LOAD_K armazena um valor da pilha no registrador K, onde ele recebe o indice da variavel na pilha como operando (o indice é um inteiro de 4 bytes)
  "LOAD_1",
  "LOAD_2",
  "LOAD_3",
  "LOAD_4",
  "LOAD_5",
  "LOAD_6",
  "LOAD_7",
  "LOAD_8",

  --CALL redireciona o contexto atual para um dado ponto do codigo (geralmente um rotulo se fosse em assembly) ate encontrar uma instrucao RETURN, para assim ele redirecionar pro contexto que o chamou de volta
  "CALL",
  "RETURN",
  -- DYNAMIC_CALL é uma instrucao especial que permite chamar um ponto do codigo conhecido somente na execução, do qual recebe como operando o registrador alvo (pra implementar por exemplo, funcoes de alta ordem)
  "DYNAMIC_CALL",
  
  --Serviços:
  --  A simplevm oferece serviços para interagir com o SO, dos quais estao definidos e docuntados em src/services. para usa-los, primeiro use a instrucao LOADSERVICE, seguida do descritor de serviço, e entao,
  -- coloque um indice no registrador 1 (que indica o subserviço), colocando quaisquer paramtros a mais nos registradores de 2 a 5
  -- e entao invoque-os com INVOKESERVICE.
  "LOADSERVICE",
  "INVOKESERVICE",


  --EXIT é uma instrucao especial que força o programa a parar com um dado status (definido no registrador 8)
  "EXIT",

  --Pulo condicional e incondicional:

  --  Pulo condicional: pula pra um dado ponto do codigo apenas se um valor de um dado registrador for verdadeiro ou falso:
  --  onde tem a seguinte forma:
  --    JUMP_IF_<OP> e JUMP_IF_N<OP> onde ele verifica se a ultima comparacao representada por OP foi verdadeira
  --
  --  Pulo incondicional: pula pra um dado ponto do codigo sem se preocupar com valor algum
  --  onde simplesmente tem a forma JUMP.
  --Ambos recebem como operando um inteiro de 4 bytes indicando o local de pulo
  "JUMP_IF_EQ",
  "JUMP_IF_LT",
  "JUMP_IF_GT",
  "JUMP_IF_GE",
  "JUMP_IF_LE",

  "JUMP_IF_NEQ",
  "JUMP_IF_NLT",
  "JUMP_IF_NGT",
  "JUMP_IF_NGE",
  "JUMP_IF_NLE",

  "JUMP"
}

return Code
