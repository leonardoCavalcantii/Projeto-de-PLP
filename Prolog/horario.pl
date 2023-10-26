:- use_module(library(persistency)).

:- persistent horario(Id, Hora, Min, date(Ano, Mes, Dia)).

:- initialization(init).

init:-
  absolute_file_name('horario.db', File, [access(write)]),
  db_attach(File, []).

add_horario(Ano, Mes, Dia, Hora, Min):-
    assert_horario(Id, Hora, Min, date(Ano, Mes, Dia)).
