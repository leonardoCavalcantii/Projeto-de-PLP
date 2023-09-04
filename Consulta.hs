import Data.Time
import Paciente
import Medico

data Consulta = Consulta {
    consultaId :: Int,
    role :: a,
    medico :: Maybe Medico,
    paciente :: Maybe Paciente,
    dataHora :: UTCTime
    }