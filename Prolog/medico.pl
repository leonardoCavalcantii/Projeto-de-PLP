setup_bd_Medico :- 
    consult('./bd_Medico.pl').

bd_Agendamento:- 
    consult('./bd_Agendamento').

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
    (get_emails_medico(Emails), member(Email, Emails) ->
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

	(medico(_,_,_,_, Email, Senha) -> nl,
	printLine, 
	writeln("Login realizado com sucesso!"), nl;
	printLine;
	writeln("Senha incorreta!"), nl, false).

logar_Medico(Email) :-
	setup_bd_Medico,
	arquivo_vazio -> 
	writeln("Medico nao cadastrado!"), 
	nl, 
	false;
	(medico(_,_,_,_,_,_) -> 
	logarMedico(Email);
	writeln("Medico nao cadastrado!"), 
	nl, 
	false).

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

removeMedico:-
    nl,
	writeln("Insira o Nome do medico a ser excluido: "),
    read_line_to_string(user_input, Nome),
    retornaListaDeMedicos(Lista),
    removeMedicoAux(Lista, Nome, ListaAtualizada),
    retractall(medico(_,_,_)),
    adicionaListaMedicos(ListaAtualizada),
    tell('./bd_Medico.pl'),  nl,
    listing(medico/3),
    told,
    fimMetodo.

retornaListaDeMedicos(Lista):-
    findall([NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico], medico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico), Lista).

adicionaListaMedicos([]). 

adicionaListaMedicos([[NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico] | T]):-
    addMedico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico), adicionaListaMedicos(T).

addMedico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico):-
    assertz(medico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico)).

removeMedicoAux([H|_], Nome, _) :-
    member(Nome, H),
    !.
    
removeMedicoAux([H|T], Nome, [H|Retorno]) :-
    removeMedicoAux(T, Nome, Retorno).
    
removeMedicoAux([], _, []) :-
    nl, writeln("Medico inexistente"), nl.

visualizarAgendamentos(Medico, List):-
    bd_Agendamento,
    findall([Id, Medico, Paciente, Horario, Status], agendamento(Id, Medico, Paciente, Horario, Status), List),
    told.

visualizarAgendamentosPendentes(Medico, List) :-
    bd_Agendamento,
    findall([Id, Medico, Paciente, Horario, Status], (agendamento(Id, Medico, Paciente, Horario, Status), Status == "Pendente"), List),
    told.
    
cancelaAgendamento(Medico):-
    nl,
	writeln("Digite o id da consulta a ser cancelada: "),
    read_line_to_string(user_input, Id),
    visualizarAgendamentosPendentes(Medico, Lista),
    rejeitaAgendamento(Id, Lista, ListaAtual),
    retractall(medico(_,_,_)),
    adicionaListaAgendamento(ListaAtual),
    tell('./bd_Agendamento.pl'),  nl,
    listing(agendamento/4),
    told,
    fimMetodo.


rejeitaAgendamento(Id, [H|T], [H| Ret]):- 
    writeln(H), rejeitaAgendamento(Id, T, Ret).

rejeitaAgendamento(Id, [H|_], _):-
    member(Id, H), !.

rejeitaAgendamento(_, [], []):-
    nl, writeln("Agendamento inexistente"), nl.

adicionaListaAgendamento([]). 

adicionaListaAgendamento([[Id, Medico, Paciente, Horario] | T]):-
    addAgendamento(Id, Medico, Paciente, Horario), adicionaListaAgendamento(T).
    
addAgendamento(Id, Medico, Paciente, Horario):-
    assertz(agendamento(Id, Medico, Paciente, Horario)).

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).

