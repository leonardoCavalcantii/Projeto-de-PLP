

data Paciente = Paciente
  { pacienteID :: Int,
    nome :: String,
    dataNascimento :: String,
    endereco :: String,
    contato :: String
  }  deriving Show

setNomePaciente :: Paciente -> String -> Paciente
 setNomePaciente paciente novoNome = paciente { nome = novoNome }

 setContatoPaciente :: Paciente -> String -> Paciente
    setContatoPaciente paciente novoContato = paciente { contato = novoContato }
