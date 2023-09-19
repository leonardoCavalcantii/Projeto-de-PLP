{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}

import Data.Char (isDigit, toLower)
import Distribution.Compat.CharParsing qualified as DisponibilidadeHotelzinho
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
    withFile,
    hPrint
  )
import System.IO.Error ()
import Prelude hiding (catch)
import GHC.IO.IOMode

----------------------------------------------------Important Part-------------------------------------------
data Admin = Admin
  { nomeAdmin :: String,
    senhaAdmin :: String,
    telefoneAdmin :: String
  }
  deriving (Read, Show)

-------------------------------------------------------------------------------------------------------------------------
-- Paciente
data Cliente = Cliente
  { nomeCliente :: String,
    email :: String,
    senha :: String,
    telefone :: String
  }
  deriving (Read, Show)

-----------------------------------------------------------------------------[*Concluido]---------------------------------------------
data Medico = Medico
  { medicoNome :: String,
    crm :: String,
    senhaMedico :: String,
    especialidade :: String,
    medicoContato :: String
  }
  deriving (Read, Show)

---------------------------------------------------------------------------------------------------------------------------

-- Agendar consulta
data Agendamento = Agendamento
  { agendamentoId :: Int,
    date :: String,
    concluido :: Bool,
    nome :: String,
    emailCliente :: String
  }
  deriving (Read, Show)

criarAgendamento :: Int -> String -> Bool -> String -> String -> Agendamento
criarAgendamento id date False nome email =
  Agendamento {
    agendamentoId = id,
    date = date,
    concluido = False,
    nome = nome,
    emailCliente = email
  }

menuAgendamento :: IO Agendamento
menuAgendamento = do
  putStrLn "\nInsira seu nome: "
  nomeCliente <- getLine

  putStrLn "\nInsira a data do agendamento: "
  date <- getLine

  putStrLn "\nInsira seu email: "
  email <- getLine

  let conclusao = False
  let novoAgendamento = criarAgendamento 0 date conclusao nomeCliente email
  salvarAgendamento novoAgendamento
  return novoAgendamento

salvarAgendamento :: Agendamento -> IO ()
salvarAgendamento agendamento = do
  -- Abre o arquivo em modo de escrita e anexa ao final do arquivo, se existir.
  withFile "agendamentos.txt" AppendMode $ \file -> do
    hPrint file agendamento


----[Menus]---------------------------------------------------------------------------------------------------------------------
printLine :: IO ()
printLine = putStrLn "\n"

main :: IO ()
main = do
  putStrLn "\n[Bem vindo ao CliniSync, seu sistema de marcação de consulta!] "
  showMenu

showMenu :: IO ()
showMenu = do
  printLine
  putStrLn "\nPara começar, INDENTIFIQUE - SE:\n"

  putStrLn "(1) - Sou Administrador"
  putStrLn "(2) - Sou Paciente"
  putStrLn "(3) - Sou Médico"
  putStrLn "(x) - Sair"


  putStr "\nOpção: "
  opcao <- getLine
  menus opcao

menus :: String -> IO ()
menus x
  | x == "1" = acessoAdm
  | x == "2" = menuCliente
  | x == "3" = menuMedico
  | x == "x" = encerrarSessao
  | otherwise = invalidOption showMenu

------------------------------------------------------------[Menu Admim(Ajustar)]------------------------------------------------------------------------------------------------------
menuAdm :: IO ()
menuAdm = do
  printLine
  putStrLn "\nSelecione uma das opções abaixo:\n"
  putStrLn "(1) - Ver pacientes cadastrados"
  putStrLn "(2) - Ver médicos cadastrados"
  putStrLn "(3) - Remover usuários"
  --putStrLn "(3) - Alterar disponibilidade hotelzinho"
  putStrLn "(4) - listar resumo de agendamentos"
  putStrLn "(5) - Atualizar contato Adm"
  putStrLn "(7) - Remarcar data de um agendamento"
  putStrLn "(8) - Ver serviços agendados pendentes"
  putStrLn "(9) - Marcar um servico como concluido"
  putStrLn "(.) - Voltar"

  putStrLn "\nOpção: "
  opcao <- getLine
  opcaoAdm opcao

opcaoAdm :: String -> IO ()
opcaoAdm x
  | x == "1" = verClientesCadastrados
  | x == "2" = verMedicoCadastrado
  | x == "3" = alterarDisponibilidadeHotelzinho
  | x == "4" = listarResumoDeAtendimentos
  | x == "5" = atualizarContatoAdm
  | x == "7" = remarcarDataDoAgendamento
  | x == "8" = listarAgendamentosPendentes
  | x == "9" = marcarServicoComoConcluido
  | x == "." = showMenu
  | otherwise = invalidOption menuAdm

----------------------------------------------------------------------------------------------[]---------------------------------

-----------------------------------------[Menu Cliente(Ajustar)]---------------------------------------------------------------------------------
menuCliente :: IO ()
menuCliente = do
  printLine
  putStrLn "\nSelecione uma das opções abaixo:\n"
  putStrLn "(1) - Se cadastrar como paciente"
  putStrLn "(2) - Logar no sistema como paciente"
  putStrLn "(3) - Suporte"
  putStrLn "(.) - Voltar ao menu principal"

  putStrLn "\nOpção: "
  opcao <- getLine
  opcaoCliente opcao

opcaoCliente :: String -> IO ()
opcaoCliente x
  | x == "1" = cadastrarComoCliente
  | x == "2" = logarComoCliente
  | x == "3" = verContatoDoAdministrador
  | x == "." = showMenu
  | otherwise = invalidOption menuCliente

segundoMenuCliente :: String -> IO ()
segundoMenuCliente email = do
  printLine
  putStrLn "\nSelecione o que deseja como cliente\n"
  putStrLn "1 - Agendar consultas"
  putStrLn "2 - Ver agendamentos concluidos"
  putStrLn "3 - Ver agendamentos ainda não concluidos"
  putStrLn "4 - Cancelar agendamento"
  putStrLn "0 - Retornar para o menu"

  putStrLn "\nOpção: "
  opcao <- getLine
  segundaTelaCliente opcao email

segundaTelaCliente :: String -> String -> IO ()
segundaTelaCliente x email
  | x == "1" = do
      agendamento <- menuAgendamento
      putStrLn "\nConsulta agendada com sucesso! 😀"
      segundaTelaCliente "0" email
  | x == "2" = agendamentosConcluidos True email
  | x == "3" = agendamentosConcluidos False email
  | x == "4" = cancelarAgendamento email
  | x == "0" = menuCliente
  | otherwise = invalidOption (segundoMenuCliente email)



---------------------------------------------------------------------------------------[]----------------------------------

-----------------------[Menu Médico(Ajustar)]------------------------------------------------------------------------------------------------
menuMedico :: IO ()
menuMedico = do
  printLine
  putStrLn "\nSelecione uma das opções abaixo:\n"
  putStrLn "(1) - Cadastre - se"
  putStrLn "(2) - Registrar na ficha"
  putStrLn "(3) - Ver contato do paciente"
  putStrLn "(.) - Voltar ao menu principal"

  putStr "\nOpção: "
  opcao <- getLine
  opcaoMedico opcao

opcaoMedico :: String -> IO ()
opcaoMedico x
  | x == "1" = cadastrarComoMedico
  | x == "2" = logarComoCliente
  | x == "3" = verContatoDoAdministrador
  | x == "." = showMenu
  | otherwise = invalidOption menuMedico

-----------------------------------------------------------------------------------------[]-------------------------------


alterarDisponibilidadeHotelzinho :: IO ()
alterarDisponibilidadeHotelzinho = do
  printLine
  putStrLn "\nSelecione qual a disponibilidade do hotelzinho neste momento:"
  putStrLn "1 - Hotelzinho está disponível"
  putStrLn "2 - Hotelzinho NÃO está disponível"
  printLine
  opcao <- getLine

  putStrLn "Alteração realizada com sucesso!"
  menuAdm


atualizarContatoAdm :: IO ()
atualizarContatoAdm = do
  printLine
  putStrLn "\nTem certeza que deseja atualizar o contato do Administrador?"
  putStrLn "\n--Aperte 1 para continuar--"
  printLine
  opcao <- getLine
  opcaoContato opcao

opcaoContato :: String -> IO ()
opcaoContato x
  | x == "1" = mudaContato
  | otherwise = invalidOption menuAdm




encerrarSessao :: IO ()
encerrarSessao = do
  printLine
  putStrLn "Saindo... Até a próxima!"
  printLine

invalidOption :: IO () -> IO ()
invalidOption function = do
  putStrLn "\nSelecione uma alternativa válida"
  function

------- Metodos Admnistrador -------

imprimeClientesCadastrados :: [Cliente] -> Int -> IO ()
imprimeClientesCadastrados [] 0 = putStrLn "\nNenhum cliente cadastrado"
imprimeClientesCadastrados [] _ = putStrLn "\nClientes listados com sucesso"
imprimeClientesCadastrados (x : xs) n = do
  putStrLn (show n ++ " - " ++ obterNomes x)
  imprimeClientesCadastrados xs (n + 1)

--------------------------------------------------------------------------------------------------------------------------
verClientesCadastrados :: IO ()
verClientesCadastrados = do
  arquivoExiste <- doesFileExist "clientes.txt"

  if arquivoExiste
    then do
      file <- openFile "clientes.txt" ReadMode
      contents <- hGetContents file
      let clientes = lines contents

      printLine
      imprimeClientesCadastrados [read x :: Cliente | x <- clientes] 0
    else do
      putStrLn "\nNão há clientes cadastrados."
  menuAdm

----------------------------------------------------[verMédicoCadastrado]----------------------------------------------------------------------------------------------
-- Médico
verMedicoCadastrado :: IO ()
verMedicoCadastrado = do
  arquivoExiste <- doesFileExist "medicos.txt"

  if arquivoExiste
    then do
      file <- openFile "medicos.txt" ReadMode
      contents <- hGetContents file
      let medicos = lines contents

      printLine
      imprimeMedicoCadastrados [read x :: Medico | x <- medicos] 0
    else do
      putStrLn "\nNão há médicos cadastrados."
  menuAdm

imprimeMedicoCadastrados :: [Medico] -> Int -> IO ()
imprimeMedicoCadastrados [] 0 = putStrLn "\nNenhum médico cadastrado"
imprimeMedicoCadastrados [] _ = putStrLn "\nMédicos listados com sucesso"
imprimeMedicoCadastrados (x : xs) n = do
  putStrLn (show n ++ " - " ++ obterNomesM x)
  imprimeMedicoCadastrados xs (n + 1)

--------------------------------------------------------------------------------------------[]----------------------------------------
removerCliente :: IO ()
removerCliente = do
  clientesCadastrados <- doesFileExist "clientes.txt"
  if not clientesCadastrados
    then do
      putStrLn "Não há clientes cadastrados!"
    else do
      putStrLn "\nInsira o email do cliente a ser removido: "
      email <- getLine

      file <- openFile "clientes.txt" ReadMode
      clientesContent <- hGetContents file
      let clientes = lines clientesContent
      let hasCliente = encontraCliente [read x :: Cliente | x <- clientes] email ""

      if not hasCliente
        then do
          putStrLn ("\nCliente com email: '" ++ email ++ "' não existe!")
        else do
          removeFile "clientes.txt"
          let novaListaDeClientes = [read x :: Cliente | x <- clientes, obterEmail (read x :: Cliente) /= email]
          atualizaClientes novaListaDeClientes
          removerAgendamentosDeUmCliente email

          putStrLn "Cliente removido com sucesso, todos os animais e agendamentos não realizados do cliente também foram removidos!"

  menuAdm

atualizaClientes :: [Cliente] -> IO ()
atualizaClientes [] = putStrLn "Cliente removido com sucesso!\n"
atualizaClientes (x : xs) = do
  clientesCadastrados <- doesFileExist "clientes.txt"
  if not clientesCadastrados
    then do
      file <- openFile "clientes.txt" WriteMode
      hPutStr file (show x)
      hFlush file
      hClose file
    else appendFile "clientes.txt" ("\n" ++ show x)
  atualizaClientes xs


--------------------------------------------------------------------[Login do Admin]--------------------------------------------------
acessoAdm :: IO ()
acessoAdm = do
  printLine
  putStrLn ("\nSenha administrador: ")
  senha <- getLine

  -- Dados para cadastro ADMIN(desconsiderar nome!)
  -- Para que usar esse char?
  adminDados <- readFile "admin.txt"
  let admin = read adminDados :: Admin

  if obterAdmin admin "senha" == senha
    then do
      menuAdm
  else do
      printLine
      --putStrLn "Senha inválida!"
      putStr "Senha inválida!"
      showMenu
-------------------------------------------------------------------------------------------[]------------------------------      

remarcarDataDoAgendamento :: IO ()
remarcarDataDoAgendamento = do
  putStrLn "Digite (x) para desistir de remarcar agendamento ou digite o id do agendamento que será remarcado: "
  id <- getLine

  if id == "x"
    then do
      menuAdm
    else
      if not (all isDigit id)
        then do
          putStrLn "Formato inválido! Digite um número!"
          remarcarDataDoAgendamento
        else do
          arquivoExiste <- doesFileExist "agendamentos.txt"
          if not arquivoExiste
            then do
              putStrLn "\nNão existem agendamentos à serem remarcados"
            else do
              agendamentosContent <- readFile "agendamentos.txt"
              let agendamentos = [read x :: Agendamento | x <- lines agendamentosContent]
              let hasAgendamento = encontrarAgendamento agendamentos (read id :: Int)

              if not hasAgendamento
                then do
                  putStrLn ("Agendamento com id '" ++ id ++ "' não existe!")
                  remarcarDataDoAgendamento
                else do
                  let agendamentoDados = encontraERetornaAgendamento agendamentos (read id :: Int)

                  if obterAgendamentoStatusDeConcluido agendamentoDados
                    then do
                      putStrLn "Esse atendimento já foi realizado e não pode ter sua data alterada!"
                      remarcarDataDoAgendamento
                    else do
                      putStrLn "Nova data do atendimento: "
                      novaData <- getLine

                      let novoAgendamento =
                            Agendamento
                              { agendamentoId = obterAgendamentoId agendamentoDados,
                                nome = obterAgendamento agendamentoDados "nome",
                                date = novaData,
                                concluido = False,
                                emailCliente = obterAgendamento agendamentoDados "emailCliente"
                              }

                      removeFile "agendamentos.txt"
                      atualizarAgendamentos (novoAgendamento : [x | x <- agendamentos, obterAgendamentoId x /= (read id :: Int)])
                      putStr ("Data do agendamento '" ++ id ++ "' alterado com sucesso!")
  menuAdm

marcarServicoComoConcluido :: IO ()
marcarServicoComoConcluido = do
  putStrLn "Digite o id do agendamento que será marcado como concluido: "
  id <- getLine

  if not (all isDigit id)
    then do
      putStrLn "Formato inválido! Digite um número!"
      marcarServicoComoConcluido
    else do
      fileExists <- doesFileExist "agendamentos.txt"
      if not fileExists
        then do
          putStrLn "Não existem agendamentos até o momento."
        else do
          agendamentosContent <- readFile "agendamentos.txt"
          let agendamentos = [read x :: Agendamento | x <- lines agendamentosContent]
          let hasAgendamento = encontrarAgendamento agendamentos (read id :: Int)

          if not hasAgendamento
            then do
              putStrLn ("Agendamento com id '" ++ id ++ "' não existe!")
              marcarServicoComoConcluido
            else do
              let agendamentoDados = encontraERetornaAgendamento agendamentos (read id :: Int)

              if obterAgendamentoStatusDeConcluido agendamentoDados
                then do
                  putStrLn "Esse atendimento já foi marcado como concluido!"
                  marcarServicoComoConcluido
                else do
                  let novoAgendamento =
                        Agendamento
                          { agendamentoId = obterAgendamentoId agendamentoDados,
                            nome = obterAgendamento agendamentoDados "nome",
                            date = obterAgendamento agendamentoDados "date",
                            concluido = True,
                            emailCliente = obterAgendamento agendamentoDados "emailCliente"
                          }

                  removeFile "agendamentos.txt"
                  atualizarAgendamentos (novoAgendamento : [x | x <- agendamentos, obterAgendamentoId x /= (read id :: Int)])
                  putStr ("Data do agendamento '" ++ id ++ "' alterado com sucesso!")
  menuAdm

listarResumoDeAtendimentos :: IO ()
listarResumoDeAtendimentos = do
  arquivoExiste <- doesFileExist "agendamentos.txt"
  if arquivoExiste
    then do
      file <- openFile "agendamentos.txt" ReadMode
      contents <- hGetContents file
      let agendamentos = [read x :: Agendamento | x <- lines contents]
      putStrLn "\nListagem de agendendamentos"
      imprimirResumosDeAtendimento agendamentos
    else do
      putStrLn "\nNão existem agendamentos cadastrados"
  menuAdm

imprimirResumosDeAtendimento :: [Agendamento] -> IO ()
imprimirResumosDeAtendimento [] = do
  putStrLn "Nenhum agendamento cadastrado"
  putStrLn ""
  printLine
imprimirResumosDeAtendimento [a] = do
  imprimirAtendimento a
  printLine
imprimirResumosDeAtendimento (a : as) = do
  imprimirAtendimento a
  imprimirResumosDeAtendimento as

imprimirAtendimento :: Agendamento -> IO ()
imprimirAtendimento a = do
  putStrLn "\n"
  putStrLn ("Data: " ++ obterAgendamento a "date")
  putStrLn ("Concluído: " ++ obterAgendamento a "concluido")
  putStrLn ("Nome do Cliente: " ++ obterAgendamento a "nome")
  putStrLn ("Dono: " ++ obterAgendamento a "emailCliente")
  putStrLn ("Serviços: " ++ obterAgendamento a "servicos")
  putStrLn ("Concluído: " ++ show (obterAgendamentoStatusDeConcluido a))
  putStrLn ("ID: " ++ show (obterAgendamentoId a))



mudaContato :: IO ()
mudaContato = do
  adminContent <- readFile "admin.txt"
  let adminDados = read adminContent :: Admin

  putStrLn "\nInsira o novo número de contato: "
  novoNumero <- getLine

  removeFile "admin.txt"
  adminFile <- openFile "admin.txt" WriteMode

  let admin =
        Admin
          { nomeAdmin = obterAdmin adminDados "nome",
            senhaAdmin = obterAdmin adminDados "senha",
            telefoneAdmin = novoNumero
          }

  hPutStr adminFile (show admin)
  hFlush adminFile
  hClose adminFile

  putStrLn "\nContato atualizado com sucesso!"
  menuAdm




listarAgendamentosPendentes :: IO ()
listarAgendamentosPendentes = do
  fileExists <- doesFileExist "agendamentos.txt"
  if not fileExists
    then do
      putStr "Ainda não existem agendamentos realizados"
      menuAdm
    else do
      file <- openFile "agendamentos.txt" ReadMode
      contents <- hGetContents file

      let agendamentosStr = lines contents
      let agendamentos = map converterEmAgendamento agendamentosStr

      putStrLn "\nListagem de agendamentos pendentes:"
      mostrarAgendamentosPendentes agendamentos
      menuAdm

mostrarAgendamentosPendentes :: [Agendamento] -> IO ()
mostrarAgendamentosPendentes [] = do
  putStrLn ""
mostrarAgendamentosPendentes (a : as) = do
  if obterAgendamentoStatusDeConcluido a
    then do
      mostrarAgendamentosPendentes as
    else do
      putStrLn ""
      putStrLn ("Nome: " ++ obterAgendamento a "nome")
      putStrLn ("Data: " ++ obterAgendamento a "date")
      putStrLn ("Servico: " ++ obterAgendamento a "servicos")
      putStrLn ("Email do Cliente: " ++ obterAgendamento a "emailCliente")
      mostrarAgendamentosPendentes as

------------------------------------

--------- Metodos Clientes ---------

agendamentosConcluidos :: Bool -> String -> IO ()
agendamentosConcluidos status email = do
  fileExists <- doesFileExist "agendamentos.txt"
  if not fileExists
    then do
      putStrLn "Não existem agendamentos efetuados até o momento"
    else do
      file <- openFile "agendamentos.txt" ReadMode
      contents <- hGetContents file

      let agendamentosStr = lines contents
      let agendamentos = map converterEmAgendamento agendamentosStr

      printLine
      putStrLn "\nListagem de agendamentos:"
      mostrarAgendamentosDoCliente agendamentos email status
  segundoMenuCliente email

mostrarAgendamentosDoCliente :: [Agendamento] -> String -> Bool -> IO ()
mostrarAgendamentosDoCliente [] email status = do
  putStrLn ""
mostrarAgendamentosDoCliente (a : as) email status = do
  if (obterAgendamentoStatusDeConcluido a == status) && (obterAgendamento a "emailDoDono" == email)
    then do
      putStrLn ""
      putStrLn ("Serviço: " ++ obterAgendamento a "servicos")
      putStrLn ("email: " ++ obterAgendamento a "emailCliente")
      putStrLn ("data: " ++ obterAgendamento a "date")
      putStrLn ("nome: " ++ obterAgendamento a "nome")
      putStrLn ("Concluído: " ++ show (obterAgendamentoStatusDeConcluido a))
      mostrarAgendamentosDoCliente as email status
    else mostrarAgendamentosDoCliente as email status

  --animaisCadastrados <- doesFileExist "animais.txt"

  --if animaisCadastrados
    --then do
     -- appendFile "animais.txt" ("\n" )

     -- putStrLn "Animal Cadastrado com sucessos!"
    --else appendFile "animais.txt" (" ")
  segundoMenuCliente email

converterEmAgendamento :: String -> Agendamento
converterEmAgendamento a = read a :: Agendamento


-- [Ajeitar]--------------------------(Paciente)--------------------------------------------------------------------------------------

cadastrarComoCliente :: IO ()
cadastrarComoCliente = do
  putStrLn ("\nInsira seu nome: ")
  nome <- getLine
  -- putStrLn ("Nome " ++ nome)

  putStrLn ("\nInsira seu email: ")
  email <- getLine

  putStrLn ("\nInsira sua senha: ")
  senha <- getLine

  putStrLn ("\nInsira seu telefone: ")
  telefone <- getLine

  -- putStrLn ""

  fileExists <- doesFileExist "clientes.txt"
  if fileExists
    then do
      file <- openFile "clientes.txt" ReadMode
      contents <- hGetContents file
      let clientes = lines contents
      let hasThisClient = encontraCliente ([read x :: Cliente | x <- clientes]) email ""

      if hasThisClient
        then do
          putStrLn "Usuario ja existente"
          menuCliente
        else do
          criarCliente nome email senha telefone
    else do
      criarCliente nome email senha telefone

criarCliente :: String -> String -> String -> String -> IO ()
criarCliente nome email senha telefone = do
  let cliente = Cliente {nomeCliente = nome, email = email, senha = senha, telefone = telefone}

  clientesCadastrados <- doesFileExist "clientes.txt"

  if clientesCadastrados
    then do
      file <- appendFile "clientes.txt" ("\n" ++ show cliente)
      putStrLn "\nCliente cadastrado com sucesso!"
      menuCliente
    else do
      file <- appendFile "clientes.txt" (show cliente)
      menuCliente

-----[Ajeitar]--------------------------------------------------------------------(Médico)----------------------------------------------------------------

cadastrarComoMedico :: IO ()
cadastrarComoMedico = do
  putStrLn ("\nInsira seu nome: ")
  medicoNome <- getLine

  putStrLn ("\nInsira seu crm: ")
  crm <- getLine

  putStrLn ("\nInsira sua especialidade: ")
  especialidade <- getLine

  putStrLn ("\nInsira sua senha: ")
  senhaMedico <- getLine

  putStrLn ("\nInsira seu contato: ")
  medicoContato <- getLine

  -- putStrLn ""
  fileExists <- doesFileExist "medicos.txt"
  if fileExists
    then do
      file <- openFile "medicos.txt" ReadMode
      contents <- hGetContents file
      let medicos = lines contents
      let hasThisClient = encontraMedico ([read x :: Medico | x <- medicos]) crm ""

      if hasThisClient
        then do
          putStrLn "Usuario ja existente"
          menuMedico
        else do
          criarMedico medicoNome crm senhaMedico medicoContato especialidade
    else do
      criarMedico medicoNome crm senhaMedico medicoContato especialidade

criarMedico :: String -> String -> String -> String -> String -> IO ()
criarMedico medicoNome crm senhaMedico medicoContato especialidade = do
  let medico = Medico {medicoNome = medicoNome, crm = crm, senhaMedico = senhaMedico, medicoContato = medicoContato, especialidade = especialidade}

  medicosCadastrados <- doesFileExist "clientes.txt"

  if medicosCadastrados
    then do
      file <- appendFile "medicos.txt" ( show medico ++ "\n")
      putStrLn "Médico cadastrado com sucesso!"
      menuMedico
    else do
      file <- appendFile "medicos.txt" (show medico)
      menuMedico

--------------------------------------------------------------------------------------------------------------------------
logarComoCliente :: IO ()
logarComoCliente = do
  --printLine
  putStrLn "\nInsira seu email: "
  email <- getLine
  fileExists <- doesFileExist "clientes.txt"

  if fileExists
    then do
      putStrLn "\nInsira sua senha: "
      senha <- getLine
      file <- openFile "clientes.txt" ReadMode
      contents <- hGetContents file
      let clientes = lines contents
      let hasCliente = encontraCliente [read x :: Cliente | x <- clientes] email senha

      if hasCliente
        then do
          putStrLn "\nLogin realizado com sucesso!✔️"
          segundoMenuCliente email
        else do
          putStrLn "\nNome ou senha incorretos! ❌"
          menuCliente
      hClose file
    else do
      putStrLn "Nenhum cliente não cadastrado. Por favor, cadastre-se!"
      cadastrarComoCliente

verContatoDoAdministrador :: IO ()
verContatoDoAdministrador = do
  adminContent <- readFile "admin.txt"
  let admin = read adminContent :: Admin
  putStrLn "\nEntre em contado com nossa administração: "
  putStrLn (obterAdmin admin "telefone")

  menuCliente

removerAgendamentosDeUmCliente :: String -> IO ()
removerAgendamentosDeUmCliente emailDoCliente = do
  agendamentosCadastrados <- doesFileExist "agendamentos.txt"
  if not agendamentosCadastrados
    then do
      putStrLn "Cliente não possuia agendamentos!"
    else do
      agendamentosContent <- readFile "agendamentos.txt"
      let agendamentos = lines agendamentosContent

      removeFile "agendamentos.txt"
      let novaListaDeAgendamentos = [read x :: Agendamento | x <- agendamentos, not (verificaAgendamentoASerRemovidoByCliente (read x :: Agendamento) emailDoCliente)]
      atualizarAgendamentos novaListaDeAgendamentos

cancelarAgendamento :: String -> IO ()
cancelarAgendamento emailCliente = do
  fileExists <- doesFileExist "agendamentos.txt"
  if not fileExists
    then do
      putStrLn "Não existem agendamentos à serem cancelados."
      segundoMenuCliente emailCliente
    else do
      file <- openFile "agendamentos.txt" ReadMode
      contents <- hGetContents file
      putStrLn "Escolha um agendamento para cancelar: \n"
      escolherAgendamento [read a :: Agendamento | a <- lines contents, obterAgendamento (read a :: Agendamento) "emailDoDono" == emailCliente] emailCliente

escolherAgendamento :: [Agendamento] -> String -> IO ()
escolherAgendamento [] emailCliente = do
  putStrLn "Nenhum agendamento cadastrado \n"
  segundoMenuCliente emailCliente
escolherAgendamento [a] emailCliente = do
  imprimirEscolhaAgendamento a

  putStrLn "Opção: "
  opcao <- getLine
  removerAgendamento opcao emailCliente
escolherAgendamento (a : as) emailCliente = do
  imprimirEscolhaAgendamento a
  escolherAgendamento as emailCliente

imprimirEscolhaAgendamento :: Agendamento -> IO ()
imprimirEscolhaAgendamento a = do
  putStrLn (obterAgendamento a "agendamentoId" ++ " - " ++ "Nome: " ++ obterAgendamento a "nome" ++ "; " ++ "Data: " ++ obterAgendamento a "date")

removerAgendamento :: String -> String -> IO ()
removerAgendamento opcao emailCliente = do
  contents <- readFile "agendamentos.txt"
  let agendamentos = [read a :: Agendamento | a <- lines contents]
  let hasAgendamento = encontrarAgendamento agendamentos (read opcao :: Int)

  if not hasAgendamento
    then do
      putStrLn "Agendamento não encontrado"
      cancelarAgendamento emailCliente
    else do
      removeFile "agendamentos.txt"
      atualizarAgendamentos [a | a <- agendamentos, obterAgendamento a "agendamentoId" /= opcao]
      putStrLn "Agendamento cancelado com sucesso!"
      segundoMenuCliente emailCliente

------------------------------------

-------- Metodos auxiliares --------

obterMedico :: Medico -> String -> String
obterMedico Medico {medicoNome = n, crm = c, senhaMedico = s, medicoContato = t} prop
  | prop == "nomeCliente" = n
  | prop == "email" = c
  | prop == "senha" = s
  | prop == "telefone" = t

obterCliente :: Cliente -> String -> String
obterCliente Cliente {nomeCliente = n, email = e, senha = s, telefone = t} prop
  | prop == "nomeCliente" = n
  | prop == "email" = e
  | prop == "senha" = s
  | prop == "telefone" = t

editCliente :: Cliente -> Cliente
editCliente Cliente {nomeCliente = n, email = e, senha = s, telefone = t} = Cliente {nomeCliente = n, email = e, senha = s, telefone = t}


indexCliente :: [Cliente] -> String -> Int -> Int
indexCliente (c : cs) email i
  | obterCliente c "email" == email = i
  | obterCliente c "email" /= email = next
  where
    next = indexCliente cs email (i + 1)

toStringListCliente :: [Cliente] -> String
toStringListCliente (x : xs) = show x ++ "\n" ++ toStringListCliente xs
toStringListCliente [] = ""

toCliente :: String -> Cliente
toCliente c = read c :: Cliente

toObjListCliente :: [String] -> [Cliente]
toObjListCliente = map toCliente

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


obterEmail :: Cliente -> String
obterEmail Cliente {nomeCliente = c, email = e, senha = s, telefone = t} = e

obterSenha :: Cliente -> String
obterSenha (Cliente _ _ senha _) = senha

obterNomes :: Cliente -> String
obterNomes (Cliente nomeCliente _ _ _) = nomeCliente

-------------------------------------------------------------------------------------------------------------------------------
obterNomesM :: Medico -> String
obterNomesM (Medico nomeMedico _ _ _ _) = nomeMedico

-------------------------------------------------[]-------------------------------------------------------------------------------------

encontraCliente :: [Cliente] -> String -> String -> Bool
encontraCliente [] email senha = False
-- Procura Cliente somente verificando o email
encontraCliente (c : cs) email ""
  | obterCliente c "email" == email = True
  | obterCliente c "email" /= email = encontrar
  where
    encontrar = encontraCliente cs email ""
-- Procura Cliente verificando o email e a senha
encontraCliente (c : cs) email senha
  | obterCliente c "email" == email && obterCliente c "senha" == senha = True
  | obterCliente c "email" /= email || obterCliente c "senha" /= senha = encontrar
  where
    encontrar = encontraCliente cs email senha

-------------------------------------------------------------------------------------------------------------------------

encontraMedico :: [Medico] -> String -> String -> Bool
encontraMedico [] crm senhaMedico = False
encontraMedico (c : cs) crm ""
  | obterMedico c "email" == crm = True
  | obterMedico c "email" /= crm = encontrar
  where
    encontrar = encontraMedico cs crm ""

----------------[Médico]-------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------

makeAgendamentoId :: [Agendamento] -> Int
makeAgendamentoId [] = 0
makeAgendamentoId [agendamento] = obterAgendamentoId agendamento + 1
makeAgendamentoId (agendamento : resto) = do
  makeAgendamentoId resto

obterAgendamentoId :: Agendamento -> Int
obterAgendamentoId Agendamento {agendamentoId = i, date = d, concluido = c, nome = n, emailCliente = e} = i

obterAgendamentoStatusDeConcluido :: Agendamento -> Bool
obterAgendamentoStatusDeConcluido Agendamento {agendamentoId = i, date = d, concluido = c, nome = n, emailCliente = e} = c

encontrarAgendamento :: [Agendamento] -> Int -> Bool
encontrarAgendamento [] agendamentoId = False
encontrarAgendamento (c : cs) agendamentoId
  | obterAgendamentoId c == agendamentoId = True
  | obterAgendamentoId c /= agendamentoId = encontrar
  where
    encontrar = encontrarAgendamento cs agendamentoId

encontraERetornaAgendamento :: [Agendamento] -> Int -> Agendamento
encontraERetornaAgendamento (c : cs) agendamentoId
  | obterAgendamentoId c == agendamentoId = c
  | obterAgendamentoId c /= agendamentoId = encontrar
  where
    encontrar = encontraERetornaAgendamento cs agendamentoId

obterAgendamento :: Agendamento -> String -> String
obterAgendamento Agendamento {agendamentoId = i, date = d, concluido = c, nome = n, emailCliente = e} prop
  | prop == "agendamentoId" = show i
  | prop == "date" = d
  | prop == "nome" = n
  | prop == "concluido" = show c
  | prop == "emailCliente" = e

verificaAgendamentoASerRemovido :: Agendamento -> String -> String -> Bool
verificaAgendamentoASerRemovido agendamento emailCliente nomeDoCliente = do
  obterAgendamento agendamento "nome" == nomeDoCliente && obterAgendamento agendamento "emailCliente" == emailCliente && not (obterAgendamentoStatusDeConcluido agendamento)

verificaAgendamentoASerRemovidoByCliente :: Agendamento -> String -> Bool
verificaAgendamentoASerRemovidoByCliente agendamento emailDoDono = True

obterAdmin :: Admin -> String -> String
obterAdmin Admin {nomeAdmin = n, senhaAdmin = s, telefoneAdmin = t} prop
  | prop == "nome" = n
  | prop == "senha" = s
  | prop == "telefone" = t