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
    
logarMedico :-
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

logar_Medico :-
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

visualizarConsultas(Medico, List):-
    c,
    findall([Id, Medico, Paciente, Horario, Status], consulta(Id, Medico, Paciente, Horario, Status), List),
    told.

visualizarConsultasPendentes(Medico, List) :-
    c,
    findall([Id, Medico, Paciente, Horario, Status], (consulta(Id, Medico, Paciente, Horario, Status), Status == "Pendente"), List),
    told.
    
cancelaConsulta(Medico):-
    nl,
	writeln("Digite o id da consulta a ser cancelada: "),
    read_line_to_string(user_input, Id),
    visualizarConsultasPendentes(Medico, Lista),
    rejeitaConsulta(Id, Lista, ListaAtual),
    retractall(medico(_,_,_)),
    adicionaListaConsulta(ListaAtual),
    tell('./bd_Consultas.pl'),  nl,
    listing(consulta/4),
    told,
    fimMetodo.

rejeitaConsulta(Id, [H|T], [H| Ret]):- 
    writeln(H), rejeitaConsulta(Id, T, Ret).

rejeitaAgendamento(Id, [H|_], _):-
    member(Id, H), H = agendamento.

rejeitaConsulta(_, [], []):-
    nl, writeln("Consulta inexistente"), nl.

adicionaListaConsulta([]). 

adicionaListaConsulta([[Id, Medico, Paciente, Horario] | T]):-
    addConsulta(Id, Medico, Paciente, Horario), adicionaListaConsulta(T).
    
addConsulta(Id, Medico, Paciente, Horario):-
    assertz(consulta(Id, Medico, Paciente, Horario)).

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).

