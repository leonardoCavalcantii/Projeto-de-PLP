import Data.Time
import Paciente



--data SlotConsulta = SlotConsulta{
  --  dataHoraConsulta :: UTCTime,
    --pacienteAgendado :: Maybe Paciente 

--}


data Medico = Medico {
    medicoId :: Int, 
    nome :: String,
    especialidade :: String,
    contato :: String,
    --slotConsulta :: [SlotConsulta],
    feedback :: [(Paciente, String, Int)]

    } 

    