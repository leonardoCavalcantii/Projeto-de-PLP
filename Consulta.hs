import Data.Time
import Paciente
--import Medico

data Consulta = Consulta {
    consultaId :: Int,
    paciente :: Paciente,
    --medico :: Medico,
    dataHora :: UTCTime
    }