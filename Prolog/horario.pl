setup_bd_Medico :-
  consult('./bd_Medico.pl').

setup_bd_Horario :-
  consult('./bd_Horario.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

arquivo_vazio :-
	\+(predicate_property(horario(_,_,_,_), dynamic)).

agendarHorarioMedico(Email) :-
  setup_bd_Horario,
  printLine,
  writeln("CADASTRO NOVO HORARIO"),
    printLine,
    writeln("Digite os dados: "),

    nl, writeln("Id: "),
    read_line_to_string(user_input, Id),

    nl, writeln("Data: "),
    read_line_to_string(user_input, Data),

    nl, writeln("Hora: "),
    read_line_to_string(user_input, Hora),

    nl,
    (get_ids_horarios(Ids), member(Id, Ids) ->
		printLine,
        writeln("Id ja cadastrado!"),
		printLine,
        nl;
        assertz(horario(Id, Email, Data, Hora)),
        adicionaHorario,
		printLine,
        writeln("Horario cadastrado com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

adicionaHorario :-
    setup_bd_Horario,
    tell('./bd_Horario.pl'),
    nl,
    listing(horario/4),
    told.

get_ids_horarios(Ids):-
    findall(Id, horario(Id, _, _, _), Ids).

removerHorarioMedico :-
    setup_bd_Horario,
    printLine,
    writeln("REMOVER HORARIO"),
    printLine,
    writeln("Digite os dados: "),
    nl, writeln("Id do horario: "),
    read_line_to_string(user_input, Id),

    nl,
    (
        retractall(horario(Id, _, _, _)),
        removeHorario,
		printLine,
        writeln("Horario removido com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

removeHorario :-
    tell('./bd_Horario.pl'),
    nl,
    listing(horario/4),
    told.
  
visualizarHorariosMedico :-
    setup_bd_Horario,
    writeln("Digite o email do medico: "),
    read_line_to_string(user_input, EmailMedico),
    printLine,
    writeln("HORARIOS MEDICO"),
    printLine,
    findall([Id, EmailMedico, Data, Horario], horario(Id, EmailMedico, Data, Horario), Horarios),
    exibirHorarios(Horarios),
    printLine,
    told,
    fimMetodo.

visualizarHorariosMedico(EmailMedico) :-
    printLine,
    writeln("HORARIOS MEDICO"),
    printLine,
    findall([Id, EmailMedico, Data, Horario], horario(Id, EmailMedico, Data, Horario), Horarios),
    exibirHorarios(Horarios),
    printLine,
    told,
    fimMetodo.

exibirHorarios([[Id, EmailMedico, Data, Horario] | T]) :-
    write("Id: "),
    writeln(Id),

    write("Email Medico: "),
    writeln(EmailMedico),

    write("Data: "),
    writeln(Data),

    write("Horario: "),
    writeln(Horario),

    writeln("-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x"),
    nl,
    exibirHorarios(T).

exibirHorarios([]).

fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).