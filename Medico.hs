import Paciente

data Medico = Medico {
    medicoId :: Int, 
    nome :: String,
    especialidade :: String,
    contato :: String,
    horarioDeAtendimento :: String,
    feedback :: [(Paciente, String, Int)]

    } deriving Show

    