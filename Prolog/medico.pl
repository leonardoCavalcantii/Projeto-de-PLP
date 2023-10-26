setup_bd_Medico :- 
    consult('./bd_Medico.pl').

setup_bd_consulta:- 
    consult('./bd_Consultas').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

arquivo_vazio :-
    \+(predicate_property(medico(_,_,_,_,_,_), dynamic)).

cadastraMedico:- 
    setup_bd_Medico,
    printLine,
    writeln("CADASTRO NOVO MEDICO"),
    printLine,
    writeln("Digite seus dados: "),
    
    nl, writeln("Nome: "),
    read_line_to_string(user_input, NomeMedico),

    nl, writeln("Especialidade: "),
    read_line_to_string(user_input, Especialidade),

    nl, writeln("CRM: "),
    read_line_to_string(user_input, CRM),
    
    nl, writeln("Telefone de contato: "),
    read_line_to_string(user_input, NumeroMedico),
    
    nl, writeln("email: "),
    read_line_to_string(user_input, EmailMedico),

    nl, writeln("Escolha sua senha: "),
    read_line_to_string(user_input, SenhaMedico),

    nl,
    (get_emails_medico(Emails), member(EmailMedico, Emails) ->
        printLine,
        writeln("Email ja cadastrado!"),
        printLine,
        nl;
        assertz(medico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico)),
        adicionaMedico,
        printLine,
        writeln("Medico cadastrado com sucesso!"),
        printLine,
        nl
    ),
    fimMetodo.

adicionaMedico :-
    setup_bd_Medico,
    tell('./bd_Medico.pl'),
    nl,
    listing(medico/6),
    told.

get_emails_medico(Emails) :-
    findall(Email, medico(_, _, _, _, Email, _), Emails).
    
logarMedico(Email) :-
    printLine,
	writeln("LOGAR MEDICO"),
	printLine,
	writeln("Insira seu email: "),
	read_line_to_string(user_input, Email),

	nl,
	writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),

	(medico(_,_,_,_, Email, Senha) -> nl, writeln("Login realizado com sucesso!"), nl;
	writeln("Senha incorreta!"), nl, false).

logar_Medico(Email) :-
	setup_bd_Medico,
	arquivo_vazio -> 
        printLine,
	    writeln("Medico nao cadastrado!"), 
        printLine,
	    nl, 
	    false;
	    (medico(_,_,_,_,_,_)) -> logarMedico;
	    writeln("Medico nao cadastrado!"), nl, false.

listarMedicos :- 
    setup_bd_Medico,
    printLine,
    writeln("LISTA DE MEDICOS CADASTRADOS"),
    printLine,
    findall(Nome, medico(Nome, _, _, _, _, _), ListaDeMedicos),
    exibirListaDeMedicos(ListaDeMedicos),
    printLine,
    told,
    fimMetodo.

exibirListaDeMedicos([H|T]):-
    writeln(H),
    exibirListaDeMedicos(T).

exibirListaDeMedicos([]).

removeMedicoEmail:-
    setup_bd_Medico,
    printLine,
    writeln("DESCADASTRAR MEDICO"),
    printLine,
    writeln("Digite os dados: "),
    nl, writeln("Email: "),
    read_line_to_string(user_input, Email),

    nl,
    (
        retractall(medico(_, _, _, _, Email, _)),
        removeMedico,
		printLine,
        writeln("Medico removido com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

removeMedico :-
    tell('./bd_Medico.pl'),
    nl,
    listing(medico/6),
    told.

listarConsultasConcluidasMedico(EmailMedico) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS CONCLUIDAS MEDICO"),
    printLine,
    findall([Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status], consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, "Concluida"), Consultas),
    exibirConsultas(Consultas),
    printLine,
    told,
    fimMetodo.

listarConsultasPendentesMedico(EmailMedico) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS CONCLUIDAS MEDICO"),
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
    nl,
    exibirConsultas(T).

exibirConsultas([]).

cancelaConsultaMedico(EmailMedico) :-
    setup_bd_consulta,
    printLine,
    writeln("CANCELAR CONSULTA"),
    printLine,
    writeln("Digite o ID da consulta que deseja cancelar: "),
    read_line_to_string(user_input, IdConsulta),
    (
        consulta(ID, Medico, EmailMedico, Paciente, Email, Data, Horario, _) ->
            
            retractall(consulta(IdConsulta, _, EmailMedico, _, _, _, _, _)),
            removeConsulta,

            assertz(consulta(ID, Medico, EmailMedico, Paciente, Email, Data, Horario, "Cancelada")),
            adicionaConsulta,
            nl,

            writeln("Consulta remarcada com sucesso!");
        writeln("Nao foi possivel remarcar a consulta. Certifique-se de que a consulta existe e esta pendente.")
    ),
    printLine,
    fimMetodo.

adicionaConsulta :-
    setup_bd_consulta,
    tell('./bd_Consultas.pl'),
    nl,
    listing(consulta/8),
    told.

visualizarPerfilMedico :-
    setup_bd_medico,
    writeln("Digite o email do medico: "),
    read_line_to_string(user_input, EmailMedico),
    printLine,
    writeln("PERFIL DO MEDICO"),
    printLine,

    (medico(Nome, Especialidade, CRM, Telefone, EmailMedico, Senha) ->
         write("Nome: "),
        writeln(Nome),
        nl,
        write("Especialidade: "),
        writeln(Especialidade),
        nl,
        write("Telefone: "),
        writeln(Telefone),
        nl,
        write("Email: "),
        writeln(EmailMedico),
        printLine;
        writeln("Medico nao encontrado no sistema.")
    ),
    told,
    fimMetodo.

exibirMedico([[Nome, Especialidade, CRM, Telefone, Email, Senha] | T]) :-
    write("Nome: "),
    writeln(Nome),
    nl,
    write("Especialidade: "),
    writeln(Especialidade),
    nl,
    write("Telefone: "),
    writeln(Telefone),
    nl,
    write("Email: "),
    writeln(Email),
    exibirMedico(T).

exibirMedico([]).

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).


