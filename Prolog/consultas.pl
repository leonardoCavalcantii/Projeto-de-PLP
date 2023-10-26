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

    nl, writeln("Email do medico: "),
    read_line_to_string(user_input, EmailMedico),

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
        assertz(consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, "Pendente")),
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
    listing(consulta/8),
    told.

get_ids_consultas(Ids) :-
    findall(Id, consulta(Id, _, _, _, _, _, _, _), Ids).
   
listarResumoConsultas :-
    setup_bd_consulta,
    printLine,
    writeln("RESUMO DE CONSULTAS"),
    printLine,
    findall([Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status], consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status), Consultas),
    exibirConsultas(Consultas),
    printLine,
    told,
    fimMetodo.

listaConsultasPendentesPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS PENDENTES"),
    printLine,
    findall([Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status], consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, "Pendente"), Consultas),
    exibirConsultas(Consultas),
    printLine,
    told,
    fimMetodo.

exibirConsultas([[Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status] | T]) :-
    write("Id: "),
    writeln(Id),

    write("Medico: "),
    writeln(Medico),

    write("Data: "),
    writeln(Data),

    write("Horario: "),
    writeln(Horario),

    write("Status: "),
    writeln(Status),

    writeln("-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x"),
    nl,
    exibirConsultas(T).

exibirConsultas([]).

remarcaConsultaPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("REMARCAR CONSULTA"),
    printLine,
    writeln("Digite o ID da consulta que deseja remarcar: "),
    read_line_to_string(user_input, IdConsulta),
    (
        consulta(ID, Medico, EmailMedico, Paciente, Email, _, _, "Pendente") ->
            writeln("Digite a nova data da consulta (formato dd/mm/yyyy): "),
            read_line_to_string(user_input, NovaData),

            writeln("Digite o novo horario da consulta (hh:mm): "),
            read_line_to_string(user_input, NovoHorario),
            
            retractall(consulta(IdConsulta, _, _, _, Email, _, _, _)),
            removeConsulta,

            assertz(consulta(IdConsulta, Medico, EmailMedico, Paciente, Email, NovaData, NovoHorario, "Pendente")),
            adicionaConsulta,
            nl,

            writeln("Consulta remarcada com sucesso!");
        writeln("Nao foi possivel remarcar a consulta. Certifique-se de que a consulta existe e esta pendente.")
    ),
    printLine,
    fimMetodo.

alterarStatusConsulta :-
    setup_bd_consulta,
    printLine,
    writeln("ALTERAR STATUS CONSULTA"),
    printLine,
    writeln("Digite o ID da consulta que deseja alterar: "),
    read_line_to_string(user_input, IdConsulta),
    (
        consulta(ID, Medico, EmailMedico, Paciente, Email, Data, Horario, _) ->
            writeln("Digite o novo status: "),
            read_line_to_string(user_input, NovoStatus),
            
            retractall(consulta(IdConsulta, _, _, _, _, _, _, _)),
            removeConsulta,

            assertz(consulta(IdConsulta, Medico, EmailMedico, Paciente, Email, Data, Horario, NovoStatus)),
            adicionaConsulta,
            nl,

            writeln("Consulta alterada com sucesso!");
        writeln("Nao foi possivel alterar a consulta. Certifique-se de que a consulta existe e esta pendente.")
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
        retractall(consulta(Id, _, _, _, Email, _, _, _)),
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
    listing(consulta/8),
    told.

fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).