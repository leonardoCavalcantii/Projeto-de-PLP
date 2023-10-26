setup_bd_consulta :-
    consult('./bd_Consultas.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

agendaConsultaPaciente(EmailPaciente) :-
    setup_bd_consulta,
    printLine,
    writeln("MARCAR NOVA CONSULTA"),
    printLine,
    writeln("Digite os dados: "),
    
    nl, writeln("Id: "),
    read_line_to_string(user_input, Id),

    nl, writeln("Medico: "),
    read_line_to_string(user_input, Medico),

    nl, writeln("Paciente: "),
    read_line_to_string(user_input, Paciente),

    nl, writeln("Data: "),
    read_line_to_string(user_input, Data),

    nl, writeln("Horario: "),
    read_line_to_string(user_input, Horario),

    nl,
    (get_ids_consultas(Ids), member(Id, Ids) ->
        printLine,
        writeln("Id ja cadastrado!"),
        printLine,
        nl;
        assertz(consulta(Id, Medico, Paciente, EmailPaciente, Data, Horario, "Pendente")),
        adicionaConsulta,
        printLine,
        writeln("Consulta marcada com sucesso!"),
        printLine,
        nl
    ),
    fimMetodo.

adicionaConsulta :-
    setup_bd_consulta,
    tell('./bd_Consultas.pl'),
    nl,
    listing(consulta/7),
    told.

get_ids_consultas(Ids) :-
    findall(Id, consulta(Id, _, _, _, _, _, _), Ids).
   

listaConsultasPendentesPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS PENDENTES"),
    printLine,
    findall([Id, Paciente, Email, Medico, Data, Horario, Status], consulta(Id, Medico, Paciente, Email, Data, Horario, "Pendente"), Consultas),
    exibirConsultas(Consultas),
    printLine,
    told,
    fimMetodo.

exibirConsultas([[Id, Paciente, Email, Medico, Data, Horario, Status] | T]) :-
    write("Id: "),
    writeln(Id),
    write("Medico: "),
    writeln(Medico),
    write("Data: "),
    writeln(Data),
    write("Horario: "),
    writeln(Horario),
    nl,
    exibirConsultas(T).

exibirConsultas([]).

remarcaConsultaPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("REMARCAR CONSULTA"),
    printLine,
    writeln("Digite o ID da consulta que deseja remarcar: "),
    read_line_to_string(user_input, ID),
    (
        consulta(ID, Paciente, Medico, Email, _, _, "Pendente") ->
            writeln("Digite a nova data da consulta (formato dd/mm/yyyy): "),
            read_line_to_string(user_input, NovaData),

            writeln("Digite o novo horario da consulta (hh:mm): "),
            read_line_to_string(user_input, NovoHorario),

            % Remova a consulta anterior
            retract(consulta(ID, Paciente, Medico, Email, _, _, "Pendente")),
            
            % Adicione a consulta atualizada
            assertz(consulta(ID, Paciente, Medico, Email, NovaData, NovoHorario, "Pendente")),
            adicionaConsulta,
            
            writeln("Consulta remarcada com sucesso!");
        writeln("Nao foi possivel remarcar a consulta. Certifique-se de que a consulta existe e esta pendente.")
    ),
    printLine,
    fimMetodo.

dermarcarConsultaPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("DESMARCAR CONSULTA"),
    printLine,
    writeln("Digite os dados: "),
    nl, writeln("Id da consulta: "),
    read_line_to_string(user_input, Id),

    nl,
    (
        retractall(consulta(Id, _, _, Email, _, _, _)),
        removeConsulta,
		printLine,
        writeln("Consulta desmarcada com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

removeConsulta :-
    tell('./bd_Consultas.pl'),
    nl,
    listing(consulta/7),
    told.

fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).