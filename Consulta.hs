import Data.Time
import Paciente
import Medico


data Consulta = Consulta {
   
    consultaId :: Int,
    medico :: Medico,
    paciente :: Paciente,
    dataHora :: UTCTime
   
    }