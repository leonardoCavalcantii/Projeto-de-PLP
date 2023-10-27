setup_bd_Medico :-
  consult('./bd_Medico.pl').

setup_bd_Horario :-
  consult('./bd_Horario.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

arquivo_vazio :-
	\+(predicate_property(horario(_,_,_,_,_), dynamic)).

agendarHorarioMedico(Email) :-
  setup_bd_Horario,
  printLine,
  writeln("CADASTRO NOVO HORARIO"),
    printLine,
    writeln("Digite os dados: "),

    get_next_id(Id),

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
        assertz(horario(Id, Email, Data, Hora, "Disponivel")),
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
    listing(horario/5),
    told.

get_ids_horarios(Ids):-
    findall(Id, horario(Id, _, _, _, _), Ids).

find_largest_id(MaxID) :-
    findall(ID, horario(ID, _, _, _, _), IDs),
    (max_list(IDs, MaxID) -> true ; MaxID is 0).

get_next_id(NextID) :-
    find_largest_id(LargestID),
    NextID is LargestID + 1.

removerHorarioMedico :-
    setup_bd_Horario,
    printLine,
    writeln("REMOVER HORARIO"),
    printLine,
    writeln("Digite os dados: "),
    nl, writeln("Id do horario: "),
    read_line_to_string(user_input, Id),
    number_string(IdHorario, Id),

    nl,
    (
        retractall(horario(IdHorario, _, _, _, _)),
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
    listing(horario/5),
    told.
  
visualizarHorariosMedico :-
    setup_bd_Horario,
    writeln("Digite o email do medico: "),
    read_line_to_string(user_input, EmailMedico),
    printLine,
    writeln("HORARIOS MEDICO"),
    printLine,
    findall([Id, EmailMedico, Data, Horario, Status], horario(Id, EmailMedico, Data, Horario, Status), Horarios),
    exibirHorarios(Horarios),
    printLine,
    told,
    fimMetodo.

visualizarHorariosMedico(EmailMedico) :-
    printLine,
    writeln("HORARIOS MEDICO"),
    printLine,
    findall([Id, EmailMedico, Data, Horario, Status], horario(Id, EmailMedico, Data, Horario, Status), Horarios),
    exibirHorarios(Horarios),
    printLine,
    told,
    fimMetodo.

exibirHorarios([[Id, EmailMedico, Data, Horario, Status] | T]) :-
    write("Id: "),
    writeln(Id),

    write("Data: "),
    writeln(Data),

    write("Horario: "),
    writeln(Horario),

    write("Status: "),
    writeln(Status),

    writeln("-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x"),
    nl,
    exibirHorarios(T).

exibirHorarios([]).

fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).