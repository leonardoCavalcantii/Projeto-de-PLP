{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

import Data.Char (toLower)
import System.Directory (doesFileExist, removeFile)
import System.IO
  ( IO,
    IOMode (ReadMode, ReadWriteMode, WriteMode),
    getLine,
    hClose,
    hFlush,
    hGetContents,
    hGetLine,
    hPutStr,
    hPutStrLn,
    openFile,
    putStrLn,
  )
import Data.Binary.Builder (append)

data Admin = Admin
  { nomeAdmin :: String,
    senhaAdmin :: String,
    telefoneAdmin :: String
  }
  deriving (Read, Show)

data Paciente = Paciente
  { nome :: String,
    cpf :: String,
    endereco :: String,
    contato :: String,
    peso :: String,
    altura :: String,
    idade :: String,
    frh :: String,
    emailPaciente :: String,
    senhaPaciente :: String
  }
  deriving (Read, Show)

data Medico = Medico
  { nomeMedico :: String,
    especialidade :: String,
    crm :: String,
    telefoneMedico :: String,
    emailMedico :: String,
    senhaMedico :: String
  }
  deriving (Read, Show)

data Agendamento = Agendamento
  { agendamentoId :: String,
    dataAgendamento :: String,
    servicos :: String,
    status :: Bool,
    nomePacienteAgendado :: String,
    emailDoPaciente :: String,
    nomeDoMedico :: String,
    emailDoMedico :: String
  }
  deriving (Read, Show)

data Ficha = Ficha
  { dataDaConsulta :: String,
    paciente :: Paciente,
    medico :: Medico,
    contatoPaciente :: String,
    contatoMedico :: String
  }
  deriving (Read, Show)

printLine :: IO ()
printLine = putStrLn "\n------------------------------------------------------------"

invalidOption :: IO () -> IO ()
invalidOption function = do
  putStrLn "\nSelecione uma alternativa válida"
  function

encerrarSessao :: IO ()
encerrarSessao = do
  printLine
  putStrLn "Saindo... Até a próxima!"
  printLine

main :: IO ()
main = do
  printLine
  putStr "Bem vindo ao CliniSync - Sistema de agendamento de consultas"
  printLine
  showMenu

showMenu :: IO ()
showMenu = do
  putStrLn "\nIdentifique-se selecionando o seu perfil:\n"

  putStrLn "1 - Administrador"
  putStrLn "2 - Paciente"
  putStrLn "3 - Médico"
  putStrLn "4 - Sair"
  printLine

  putStr "Opção: "
  opcao <- getLine
  menus opcao

menus :: String -> IO ()
menus x
  | x == "1" = acessoAdm
  | x == "2" = menuPaciente
  | x == "3" = menuMedico
  | x == "4" = encerrarSessao
  | otherwise = invalidOption showMenu

acessoAdm :: IO ()
acessoAdm = do
  printLine
  putStrLn "Olá, administrador!"
  putStrLn "Faça seu acesso:\n"
  putStr "Senha: "
  senha <- getLine

  adminDados <- readFile "admin.txt"
  let admin = read adminDados :: Admin

  if obterAdmin admin "senha" == senha
    then do
      menuAdm
    else do
      printLine
      putStrLn "Senha incorreta!"
      putStr "Deseja fazer login novamente! (s/n): "
      opcao <- getChar
      _ <- getChar


      if toLower opcao == 's'
        then do
          acessoAdm
        else showMenu

menuAdm :: IO ()
menuAdm = do
  printLine
  putStrLn "\nSelecione uma opção:\n"
  putStrLn "1 - Ver Pacientes cadastrados no sistema"
  putStrLn "2 - Ver Médicos cadastrados no sistema"
  putStrLn "3 - Remover Paciente"
  putStrLn "4 - Remover Médico"
  putStrLn "5 - Alterar Status de um agendamento"
  putStrLn "6 - Listar resumo de agendamentos"
  putStrLn "7 - Atualizar contato Adm"
  putStrLn "8 - Visualizar agendamentos pendentes"
  putStrLn "0 - Voltar"
  printLine
  putStr "Opção: "
  opcao <- getLine
  opcaoAdm opcao

opcaoAdm :: String -> IO ()
opcaoAdm x
  | x == "1" = verPacientesCadastrados
  | x == "2" = verMedicosCadastrados
  | x == "3" = removerPaciente
  | x == "4" = removerMedico
  | x == "5" = atualizarStatusAgendamento
  | x == "6" = listarAgendamentos
  | x == "7" = atualizarContatoAdm
---  | x == "8" = visualizarAgendamentos
  | x == "0" = showMenu
  | otherwise = invalidOption menuAdm

menuPaciente :: IO ()
menuPaciente = do
  printLine
  putStrLn "\nSelecione uma opção:\n"
  putStrLn "1 - Cadastrar-se"
  putStrLn "2 - Logar"
  putStrLn "3 - Consultar dados do administrador"
  putStrLn "0 - Voltar ao menu principal"
  printLine
  putStr "Opção: "
  opcao <- getLine
  opcaoPaciente opcao

opcaoPaciente :: String -> IO ()
opcaoPaciente x
  | x == "1" = cadastraPaciente
  | x == "2" = logarPaciente
  | x == "3" = verContatoDoAdministradorP
  | x == "0" = showMenu
  | otherwise = invalidOption menuPaciente

segundoMenuPaciente :: String -> IO ()
segundoMenuPaciente email = do
  printLine
  putStrLn "\nSelecione uma opção:\n"
  putStrLn "1 - Agendar Consulta"
  putStrLn "2 - Visualizar Agendamentos Fechados"
  putStrLn "3 - Visualizar Agendamentos Abertos"
  putStrLn "4 - Visualizar Perfil Médico"
  putStrLn "5 - Cancelar agendamento"
  putStrLn "0 - Voltar"
  printLine
  putStr "Opção: "
  opcao <- getLine
  segundaTelaPaciente opcao email

segundaTelaPaciente :: String -> String -> IO ()
segundaTelaPaciente x email
  | x == "1" = agendarConsulta email
  | x == "2" = agendamentosConcluidos True email
  | x == "3" = agendamentosConcluidos False email
---  | x == "4" = verPerfilMedico
  | x == "5" = cancelarAgendamento email
  | x == "0" = menuPaciente
  | otherwise = invalidOption (segundoMenuPaciente email)

menuMedico :: IO ()
menuMedico = do
  printLine
  putStrLn "\nSelecione uma opção:\n"
  putStrLn "1 - Cadastrar-se"
  putStrLn "2 - Logar"
  putStrLn "3 - Consultar dados do administrador"
  putStrLn "0 - Voltar ao menu principal"
  printLine
  putStr "Opção: "
  opcao <- getLine
  opcaoMedico opcao

opcaoMedico :: String -> IO ()
opcaoMedico x
  | x == "1" = cadastraMedico
  | x == "2" = logarMedico
  | x == "3" = verContatoDoAdministradorM
  | x == "0" = showMenu
  | otherwise = invalidOption menuPaciente

segundoMenuMedico :: String -> IO ()
segundoMenuMedico email = do
  printLine
  putStrLn "\nSelecione uma opção:\n"
  ---putStrLn "1 - Visualizar Agendamentos"
  putStrLn "2 - Cancelar agendamento"
  putStrLn "0 - Voltar"
  printLine
  putStr "Opção: "
  opcao <- getLine
  segundaTelaMedico opcao email

segundaTelaMedico :: String -> String -> IO ()
segundaTelaMedico x email
---  | x == "1" = visualizarAgendamentos email
  | x == "1" = cancelarAgendamento email
  | x == "0" = menuPaciente
  | otherwise = invalidOption (segundoMenuMedico email)

----------------------------------------OperaçõesAdm---------------------------------------

verPacientesCadastrados :: IO ()
verPacientesCadastrados = do
  arquivoExiste <- doesFileExist "pacientes.txt"

  if arquivoExiste then do
    file <- openFile "pacientes.txt" ReadMode
    contents <- hGetContents file
    let pacientes = lines contents

    printLine
    imprimePacientesCadastrados [read x :: Paciente | x <- pacientes] 0
  else do
    putStrLn "\nNenhum paciente cadastrado!"
  menuAdm

imprimePacientesCadastrados :: [Paciente] -> Int -> IO ()
imprimePacientesCadastrados [] 0 = putStrLn "\nNenhum Paciente encontrado!"
imprimePacientesCadastrados [] _ = putStrLn "\nPacientes Listados com Sucesso!"
imprimePacientesCadastrados (x : xs) n = do
  putStrLn (show n ++ " - " ++ obterNomesPacientes x)
  imprimePacientesCadastrados xs (n + 1)

verMedicosCadastrados :: IO ()
verMedicosCadastrados = do
  arquivoExiste <- doesFileExist "medicos.txt"

  if arquivoExiste then do
    file <- openFile "medicos.txt" ReadMode
    contents <- hGetContents file
    let medicos = lines contents

    printLine
    imprimeMedicosCadastrados [read x :: Medico | x <- medicos] 0
  else do
    putStrLn "\nNenhum médico cadastrado!"
  menuAdm

imprimeMedicosCadastrados :: [Medico] -> Int -> IO ()
imprimeMedicosCadastrados [] 1 = putStrLn "\nNenhum médico encontrado!"
imprimeMedicosCadastrados [] _ = putStrLn "\nMédicos Listados com Sucesso!"
imprimeMedicosCadastrados (x : xs) n = do
  putStrLn (show n ++ " - " ++ obterNomesMedicos x)
  imprimeMedicosCadastrados xs (n + 1)

removerPaciente :: IO ()
removerPaciente = do
  pacientesCadastrados <- doesFileExist "pacientes.txt"
  if not pacientesCadastrados
    then do
      putStrLn "Nenhum paciente cadastrado!"
    else do
      putStr "\nInsira o email do paciente a ser removido: "
      email <- getLine

      file <- openFile "pacientes.txt" ReadMode
      pacientesContent <- hGetContents file
      let pacientes = lines pacientesContent
      let hasPaciente = encontraPaciente [read x :: Paciente | x <- pacientes] email 

      if not hasPaciente
        then do
          putStrLn ("\nPaciente com email '" ++ email ++ "' não existe!")
        else do
          removeFile "pacientes.txt"
          let novaListaDePacientes = [read x :: Paciente | x <- pacientes, obterEmailPaciente (read x :: Paciente) /= email]
          atualizaPacientes novaListaDePacientes
          removerAgendamentosDeUmPaciente email

          putStrLn "Paciente removido com sucesso, todos os também foram removidos!"

  menuAdm

removerAgendamentosDeUmPaciente :: String -> IO ()
removerAgendamentosDeUmPaciente emailPaciente = do
  agendamentosMarcados <- doesFileExist "agendamentos.txt"
  if not agendamentosMarcados
    then do
      putStrLn "paciente não possui agendamentos!"
    else do
      agendamentosContent <- readFile "agendamentos.txt"
      let agendamentos = lines agendamentosContent

      removeFile "agendamentos.txt"
      let novaListaDeAgendamentos = [read x :: Agendamento | x <- agendamentos, not (verificaAgendamentoRemovidoPaciente (read x :: Agendamento) emailPaciente)]
      atualizarAgendamentos novaListaDeAgendamentos

atualizarAgendamentos :: [Agendamento] -> IO ()
atualizarAgendamentos [] = putStrLn "Agendamentos atualizados com sucesso!\n"
atualizarAgendamentos (x : xs) = do
  agendamentosCadastrados <- doesFileExist "agendamentos.txt"
  if not agendamentosCadastrados
    then do
      file <- openFile "agendamentos.txt" WriteMode
      hPutStr file (show x)
      hFlush file
      hClose file
    else appendFile "agendamentos.txt" ("\n" ++ show x)
  atualizarAgendamentos xs

removerMedico :: IO ()
removerMedico = do
  medicosCadastrados <- doesFileExist "medicos.txt"
  if not medicosCadastrados
    then do
      putStrLn "Nenhum médico cadastrado!"
    else do
      putStr "\nInsira o email do médico a ser removido: "
      email <- getLine

      file <- openFile "medicos.txt" ReadMode
      medicosContent <- hGetContents file
      let medicos = lines medicosContent
      let hasMedico = encontraMedico [read x :: Medico | x <- medicos] email 

      if not hasMedico
        then do
          putStrLn ("\nMédico com email '" ++ email ++ "' não existe!")
        else do
          removeFile "medicos.txt"
          let novaListaDeMedicos = [read x :: Medico | x <- medicos, obterEmailMedico (read x :: Medico) /= email]
          atualizaMedicos novaListaDeMedicos

          putStrLn "Médico removido com sucesso!"

  menuAdm

listarAgendamentos :: IO ()
listarAgendamentos = do
  arquivoExiste <- doesFileExist "agendamentos.txt"

  if arquivoExiste then do
    file <- openFile "agendamentos.txt" ReadMode
    contents <- hGetContents file
    let agendamentos = lines contents

    printLine
    imprimeAgendamentos [read x :: Agendamento | x <- agendamentos] 0
  else do
    putStrLn "\nNenhum agendamento encontrado!"
  menuAdm

imprimeAgendamentos :: [Agendamento] -> Int -> IO ()
imprimeAgendamentos [] 0 = putStrLn "\nNenhum agendamento encontrado!"
imprimeAgendamentos [] _ = putStrLn "\nAgendamentos listados com Sucesso!"
imprimeAgendamentos (x : xs) n = do
  putStrLn (show n ++ " - " ++ obterNomesAgendamentos x)
  imprimeAgendamentos xs (n + 1)

atualizarContatoAdm :: IO ()
atualizarContatoAdm = do
  printLine
  putStrLn "\nTem certeza que deseja atualizar o contato do Administrador?"
  putStrLn "\n--Digite 1 para continuar--"
  printLine
  opcao <- getLine
  opcaoContato opcao

opcaoContato :: String -> IO ()
opcaoContato x
  | x == "1" = mudaContato
  | otherwise = invalidOption menuAdm

atualizarPaciente :: IO ()
atualizarPaciente = do
  
  fileExists <- doesFileExist "pacientes.txt"

  if fileExists
    then do
      putStr "Digite dos dados para atualizar o paciente: " 
      putStr "Email usado para cadastrar o paciente: "
      email <- getLine

      file <- openFile "pacientes.txt" ReadMode
      contents <- hGetContents file
      let pacientes = lines contents
      let hasPaciente = encontraPaciente [read x :: Paciente | x <- pacientes] email

      if hasPaciente
        then do

            putStr "Novo endereço: "
            endereco <- getLine

            putStr "Novo número de Contato: "
            contato <- getLine

            putStr "Novo peso: "
            peso <- getLine

            putStr "Nova altura: "
            altura <- getLine

            putStr "Nova idade: "
            idade <- getLine

            putStr "Novo email: "
            novoEmail <- getLine

            putStr "Nova senha: "
            senha <- getLine

            let pacienteExistente = head [read x :: Paciente | x <- pacientes, obterEmailPaciente (read x :: Paciente) == email]

            let pacienteAtualizado =
                  pacienteExistente
                    { endereco = endereco,
                      contato = contato,
                      peso = peso,
                      altura = altura,
                      idade = idade,
                      emailPaciente = novoEmail,
                      senhaPaciente = senha
                    }

            let pacientesAtualizados = [if obterEmailPaciente (read x :: Paciente) == email then show pacienteAtualizado else x | x <- pacientes]

            ---writeFile "pacientes.txt" 

            putStrLn "\nPaciente atualizado com sucesso!"
            menuPaciente
        else do
          putStrLn "\nPaciente não encontrado com o email fornecido."
          menuPaciente
      hClose file
    else do
      putStrLn "Arquivo 'pacientes.txt' não encontrado. Certifique-se de cadastrar pacientes antes de atualizar."
      menuPaciente

atualizarStatusAgendamento :: IO ()
atualizarStatusAgendamento = do
  printLine
  putStrLn "Digite o email do paciente:"
  email <- getLine
  printLine
  putStrLn "\nSelecione o status desejado:"
  putStrLn "1 - Concluído"
  putStrLn "2 - Aguardando consulta"
  printLine
  opcao <- getLine
  ---atualizarStatus opcao email

  putStrLn "Alteração realizada com sucesso!"
  menuAdm

--atualizarStatus :: String -> String -> IO ()
---atualizarStatus x
---  | x == "1" = atualizaStatus True email
---  | x == "2" = atualizaStatus False email
---  | otherwise = invalidOption menuAdm
-------------------------------------OperaçõesPaciente-------------------------------------

cadastraPaciente :: IO ()
cadastraPaciente = do
  putStrLn "\nDigite seus dados pessoais:"
  putStrLn "Nome: "
  nome <- getLine

  putStrLn "CPF: "
  cpf <- getLine

  putStrLn "Endereço: "
  endereco <- getLine

  putStrLn "Número de Contato: "
  contato <- getLine

  putStrLn "Peso: "
  peso <- getLine

  putStrLn "Altura: "
  altura <- getLine

  putStrLn "Idade: "
  idade <- getLine

  putStrLn "Fator RH: "
  frh <- getLine

  putStrLn "Email: "
  email <- getLine

  putStrLn "Senha: "
  senha <- getLine

  let paciente = Paciente nome cpf endereco contato peso altura idade frh email senha

  pacientesCadastrados <- doesFileExist "pacientes.txt"

  if pacientesCadastrados
    then do
      file <- appendFile "pacientes.txt" (show paciente ++ "\n")
      putStrLn "Paciente cadastrado com sucesso!"
      menuPaciente
    else do
      file <- writeFile "pacientes.txt" (show paciente ++ "\n")
      putStrLn "Paciente cadastrado com sucesso!"
      menuPaciente

logarPaciente :: IO ()
logarPaciente = do
  printLine
  putStrLn "\nFaça login como paciente:"
  printLine
  putStr "Digite seu email: "
  email <- getLine
  fileExists <- doesFileExist "pacientes.txt"

  if fileExists
    then do
      putStr "Digite sua senha: "
      senha <- getLine
      file <- openFile "pacientes.txt" ReadMode
      contents <- hGetContents file
      let pacientes = lines contents
      let hasPaciente = encontraPaciente [read x :: Paciente | x <- pacientes] email

      if hasPaciente
        then do
          putStrLn "\nLogin realizado!"
          segundoMenuPaciente email
        else do
          putStrLn "\nEmail ou Senha incorretos."
          menuPaciente
      hClose file
    else do
      putStrLn "Paciente não cadastrado. Por favor, cadastre-se"
      cadastraPaciente

agendarConsulta :: String -> IO ()
agendarConsulta email = do
  putStrLn "\nDigite os dados para marcar uma nova consulta:"
  putStr "Seu nome: "
  nome <- getLine

  putStr "Digite o nome do médico: "
  nomeMedico <- getLine

  putStr "Digite o email do médico: "
  emailMedico <- getLine

  putStr "Data do agendamento: "
  dataAgendamento <- getLine

  putStr "Quais são os serviços para este agendamento? "
  servicos <- getLine

  putStr "Digite o nome do seu agendamento no formato (CS-nomeDoAgendamento-data-seuNome)"
  putStrLn "\nExemplo: CS-ConsultaEndocrinologista-200923-Adm"
  id <- getLine

  putStrLn ""

  let agendamento = Agendamento id dataAgendamento servicos False nome email nomeMedico emailMedico

  agendamentosCadastrados <- doesFileExist "agendamentos.txt"

  if agendamentosCadastrados
    then do
      file <- appendFile "agendamentos.txt" (show agendamento ++ "\n")
      putStrLn "Agendamento feito com sucesso!"
      menuPaciente
    else do
      file <- writeFile "agendamentos.txt" (show agendamento ++ "\n")
      putStrLn "Agendamento feito com sucesso!"
      segundoMenuPaciente email
    
agendamentosConcluidos :: Bool -> String -> IO ()
agendamentosConcluidos status email = do
  fileExists <- doesFileExist "agendamentos.txt"
  if not fileExists then do
    putStrLn "Não existem agendamentos efetuados até o momento"
  else do
    file <- openFile "agendamentos.txt" ReadMode
    contents <- hGetContents file

    let agendamentosStr = lines contents
    let agendamentos = map converterEmAgendamento agendamentosStr

    printLine
    putStrLn "\nListagem de agendamentos:"
    mostrarAgendamentosDoCliente agendamentos email status
  segundoMenuPaciente email

mostrarAgendamentosDoCliente :: [Agendamento] -> String -> Bool -> IO ()
mostrarAgendamentosDoCliente [] _ _ = return () 
mostrarAgendamentosDoCliente (a : as) email statusAg = do
  if obterAgendamentoStatusDeConcluido a == statusAg && obterAgendamento a "emailDoPaciente" == email
    then do
      putStrLn ""
      putStrLn ("Paciente: " ++ nomePacienteAgendado a)
      putStrLn ("Serviço: " ++ servicos a)
      putStrLn ("Data: " ++ dataAgendamento a)
      putStrLn ("Médico: " ++ nomeDoMedico a)
      putStrLn ("Email Médico: " ++ emailDoMedico a)
      putStrLn ("Status: " ++ show (status a))
      mostrarAgendamentosDoCliente as email statusAg
    else mostrarAgendamentosDoCliente as email statusAg

cancelarAgendamento :: String -> IO ()
cancelarAgendamento emailCliente = do
  
  fileExists <- doesFileExist "agendamentos.txt"
  if not fileExists then do
    putStrLn "Não existem agendamentos à serem cancelados."
    segundoMenuPaciente emailCliente
  else do
    file <- openFile "agendamentos.txt" ReadMode
    contents <- hGetContents file
    putStrLn "Escolha um agendamento para cancelar: \n"
    escolherAgendamento [read a :: Agendamento | a <- lines contents, obterAgendamento (read a :: Agendamento) "emailDoDono" == emailCliente] emailCliente

--------------------------------------OperaçõesMedico--------------------------------------

cadastraMedico :: IO ()
cadastraMedico = do
  putStrLn "\nDigite seus dados pessoais:"
  putStr "Nome: "
  nome <- getLine

  putStr "Especialidade: "
  especialidade <- getLine

  putStr "CRM: "
  crm <- getLine

  putStr "Número de Contato: "
  contato <- getLine

  putStr "Email: "
  email <- getLine

  putStr "Senha: "
  senha <- getLine

  let medico = Medico nome especialidade crm contato email senha

  medicosCadastrados <- doesFileExist "medicos.txt"

  if medicosCadastrados
    then do
      file <- appendFile "medicos.txt" (show medico ++ "\n")
      putStrLn "Médico cadastrado com sucesso!"
      menuMedico
    else do
      file <- writeFile "medicos.txt" (show medico ++ "\n")
      putStrLn "Médico cadastrado com sucesso!"
      menuMedico

logarMedico :: IO ()
logarMedico = do
  printLine
  putStrLn "\nFaça login como médico:"
  printLine
  putStr "Digite seu email: "
  email <- getLine
  fileExists <- doesFileExist "medicos.txt"

  if fileExists
    then do
      putStr "Digite sua senha: "
      senha <- getLine
      file <- openFile "medicos.txt" ReadMode
      contents <- hGetContents file
      let medicos = lines contents
      let hasMedico = encontraMedico [read x :: Medico | x <- medicos] email

      if hasMedico
        then do
          putStrLn "\nLogin realizado!"
          segundoMenuMedico email
        else do
          putStrLn "\nEmail ou Senha incorretos."
          menuMedico
      hClose file
    else do
      putStrLn "Médico não cadastrado. Por favor, cadastre-se"
      cadastraMedico

-------------------------------------MétodosAuxiliares-------------------------------------

obterNomesPacientes :: Paciente -> String
obterNomesPacientes (Paciente nomePaciente _ _ _ _ _ _ _ _ _) = nomePaciente

obterNomesMedicos :: Medico -> String
obterNomesMedicos (Medico nomeMedico _ _ _ _ _) = nomeMedico

obterNomesAgendamentos :: Agendamento -> String
obterNomesAgendamentos (Agendamento agendamentoId _ _ _ _ _ _ _) = agendamentoId

obterAdmin :: Admin -> String -> String
obterAdmin Admin {nomeAdmin = n, senhaAdmin = s, telefoneAdmin = t} prop
  | prop == "nome" = n
  | prop == "senha" = s
  | prop == "telefone" = t

obterPaciente :: Paciente -> String -> String
obterPaciente Paciente {nome = nome, cpf = cpf, endereco = endereco, contato = contato, peso = peso, altura = altura, idade = idade, frh = frh, emailPaciente = email, senhaPaciente = senha} prop
  | prop == "nome" = nome
  | prop == "cpf" = cpf
  | prop == "endereco" = endereco
  | prop == "contato" = contato
  | prop == "emailPaciente" = email
  | prop == "peso" = peso
  | prop == "altura" = altura
  | prop == "idade" = idade
  | prop == "frh" = frh
  | prop == "senhaPaciente" = senha
  | otherwise = "Propriedade não encontrada"

obterMedico :: Medico -> String -> String
obterMedico Medico {nomeMedico = nome, especialidade = especialidade, crm = crm, telefoneMedico = contato, emailMedico = email, senhaMedico = senha} prop
  | prop == "nomeMedico" = nome
  | prop == "especialidade" = especialidade
  | prop == "crm" = crm
  | prop == "telefoneMedico" = contato
  | prop == "emailMedico" = email
  | prop == "senhaMedico" = senha
  | otherwise = "Propriedade não encontrada"

obterAgendamento :: Agendamento -> String -> String
obterAgendamento Agendamento {agendamentoId = id, dataAgendamento = dataAgendamento, status = status, nomePacienteAgendado = nomePaciente, emailDoPaciente = email} prop
  | prop == "agendamentoId" = show id
  | prop == "dataAgendamento" = dataAgendamento
  | prop == "status" = show status
  | prop == "nomePacienteAgendado" = nomePaciente
  | prop == "emailDoPaciente" = email
  | otherwise = "Propriedade não encontrada"

obterEmailPaciente :: Paciente -> String
obterEmailPaciente Paciente {nome = nome, cpf = cpf, endereco = endereco, contato = contato, emailPaciente = email, peso = peso, altura = altura, idade = idade, frh = frh, senhaPaciente = senha} = email

obterEmailMedico :: Medico -> String
obterEmailMedico Medico {nomeMedico = nome, especialidade = especialidade, crm = crm, telefoneMedico = contato, emailMedico = email, senhaMedico = senha} = email

obterAgendamentoId :: Agendamento -> String
obterAgendamentoId Agendamento {agendamentoId = id, dataAgendamento = dataAgendamento, servicos = servicos, status = status, nomePacienteAgendado = nomePaciente, emailDoPaciente = email} = id

obterAgendamentoStatusConcluido :: Agendamento -> Bool
obterAgendamentoStatusConcluido Agendamento {agendamentoId = id, dataAgendamento = dataAgendamento, servicos = servicos, status = status, nomePacienteAgendado = nomePaciente, emailDoPaciente = email} = status

encontraPaciente :: [Paciente] -> String  -> Bool
encontraPaciente [] email = False
-- Procura Paciente somente verificando o email
encontraPaciente (c : cs) email 
  | obterPaciente c "emailPaciente" == email = True
  | obterPaciente c "emailPaciente" /= email = encontrar
  where
    encontrar = encontraPaciente cs email 

atualizaPacientes :: [Paciente] -> IO ()
atualizaPacientes [] = putStrLn "Paciente removido com sucesso!\n"
atualizaPacientes (x : xs) = do
  pacientesCadastrados <- doesFileExist "pacientes.txt"
  if not pacientesCadastrados
    then do
      file <- openFile "pacientes.txt" WriteMode
      hPutStr file (show x)
      hFlush file
      hClose file
    else appendFile "pacientes.txt" ("\n" ++ show x)
  atualizaPacientes xs

encontraMedico :: [Medico] -> String  -> Bool
encontraMedico [] email = False
-- Procura Médico somente verificando o email
encontraMedico (c : cs) email 
  | obterMedico c "emailMedico" == email = True
  | obterMedico c "emailMedico" /= email = encontrar
  where
    encontrar = encontraMedico cs email

atualizaMedicos :: [Medico] -> IO ()
atualizaMedicos [] = putStrLn "Médico removido com sucesso!\n"
atualizaMedicos (x : xs) = do
  medicosCadastrados <- doesFileExist "medicos.txt"
  if not medicosCadastrados
    then do
      file <- openFile "medicos.txt" WriteMode
      hPutStr file (show x)
      hFlush file
      hClose file
    else appendFile "medicos.txt" ("\n" ++ show x)
  atualizaMedicos xs

verificaAgendamentoRemovidoPaciente :: Agendamento -> String -> Bool
verificaAgendamentoRemovidoPaciente agendamento email= do
  obterAgendamento agendamento "email" == email && not (obterAgendamentoStatusConcluido agendamento)

verContatoDoAdministradorP :: IO ()
verContatoDoAdministradorP = do
  adminContent <- readFile "admin.txt"
  let admin = read adminContent :: Admin
  putStr "\nContato: \n"
  putStrLn (obterAdmin admin "nome")
  putStrLn (obterAdmin admin "telefone")
  menuPaciente

verContatoDoAdministradorM :: IO ()
verContatoDoAdministradorM = do
  adminContent <- readFile "admin.txt"
  let admin = read adminContent :: Admin
  putStr "\nContato: \n"
  putStrLn (obterAdmin admin "nome")
  putStrLn (obterAdmin admin "telefone")
  menuMedico

mudaContato :: IO ()
mudaContato = do

  adminFileExists <- doesFileExist "admin.txt"
  if not adminFileExists
    then do
      putStrLn "Arquivo 'admin.txt' não encontrado."
      menuAdm
    else do
      adminContent <- readFile "admin.txt"
      let adminDados = read adminContent :: Admin

      putStr "\nInsira o nome do novo administrador: "
      nome <- getLine

      putStr "\nInsira a senha do novo administrador: "
      senha <- getLine

      putStr "\nInsira o telefone do novo administrador: "
      contato <- getLine

      let novoAdmin =
            adminDados
              { nomeAdmin = nome, senhaAdmin = senha, telefoneAdmin = contato}
      writeFile "admin.txt" (show novoAdmin)

      putStrLn "\nContato atualizado com sucesso!"
      menuAdm

converterEmAgendamento :: String -> Agendamento
converterEmAgendamento a = read a :: Agendamento

obterAgendamentoStatusDeConcluido :: Agendamento -> Bool
obterAgendamentoStatusDeConcluido Agendamento {agendamentoId = i, dataAgendamento = dataAgendamento, servicos = servicos, status = c, nomePacienteAgendado = nome, emailDoPaciente = email} = c

escolherAgendamento :: [Agendamento] -> String -> IO ()
escolherAgendamento [] emailPaciente = do
  putStrLn "Nenhum agendamento cadastrado \n"
  segundoMenuPaciente emailPaciente
escolherAgendamento [a] emailCliente = do
  imprimirEscolhaAgendamento a
  printLine
  putStr "opção: "
  opcao <- getLine
  removerAgendamento opcao emailCliente
escolherAgendamento (a : as) emailCliente = do
  imprimirEscolhaAgendamento a
  escolherAgendamento as emailCliente

imprimirEscolhaAgendamento :: Agendamento -> IO ()
imprimirEscolhaAgendamento a = do
  putStrLn (obterAgendamento a "agendamentoId" ++ " - " ++ obterAgendamento a "servicos: " ++ " - " ++ obterAgendamento a "dataAgendamento" ++ "; ")

removerAgendamento :: String -> String -> IO ()
removerAgendamento opcao emailPaciente = do
  contents <- readFile "agendamentos.txt"
  let agendamentos = [read a :: Agendamento | a <- lines contents]
  let hasAgendamento = encontrarAgendamento agendamentos (read opcao :: String)

  if not hasAgendamento
    then do
      putStrLn "Agendamento não encontrado"
      cancelarAgendamento emailPaciente
    else do
      removeFile "agendamentos.txt"
      atualizarAgendamentos [a | a <- agendamentos, obterAgendamento a "agendamentoId" /= opcao]
      putStrLn "Agendamento cancelado com sucesso!"
      segundoMenuPaciente emailPaciente

encontrarAgendamento :: [Agendamento] -> String -> Bool
encontrarAgendamento [] agendamentoId = False
encontrarAgendamento (c : cs) agendamentoId
  | obterAgendamentoId c == agendamentoId = True
  | obterAgendamentoId c /= agendamentoId = encontrar
  where
    encontrar = encontrarAgendamento cs agendamentoId

