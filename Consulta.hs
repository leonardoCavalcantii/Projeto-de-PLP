import Data.Time
import Medico
import Paciente

data Consulta = Consulta
  { consultaId :: Int,
    medico :: Medico,
    paciente :: Paciente,
    dataHora :: UTCTime
  }