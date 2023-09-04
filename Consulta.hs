import Data.Time
import Paciente
import Medico

data Consulta = Consulta {
    consultaId :: Int,
    --role :: a,
    medico :: Medico,
    paciente :: Paciente,
    dataHora :: UTCTime
    }