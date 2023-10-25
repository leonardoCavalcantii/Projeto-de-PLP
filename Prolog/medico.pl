bd_Medico:- consult('./bd_Medico.pl').
bd_Agendamento:- consult('./bd_Agendamento').

arquivo_vazio :-
	\+(predicate_property(medico(_,_,_,_,_,_), dynamic)).


cadastraMedico:- 
    bd_Medico, nl,
   nl, writeln("Digite seus dados: "),
    
    nl, writeln("Digite seu nome: "),
    read_line_to_string(user_input, NomeMedico), nl,

    nl, writeln("Digite sua especialidade: "),
    read_line_to_string(user_input, Especialidade), nl,

    nl, writeln("Digite seu crm: "),
    read_line_to_string(user_input, CRM), nl,
    
    nl, writeln("Digite seu telefone: "),
    read_line_to_string(user_input, NumeroMedico), nl,
    
    nl, writeln("Digite seu email: "),
    read_line_to_string(user_input, EmailMedico), nl,

    nl, writeln("Digite seu senha: "),
    read_line_to_string(user_input, SenhaMedico), nl,

    
    
    
(get_crms_medico(CRMS), member(CRM, CRM) ->
	printLine,
    writeln("crm ja cadastrado!"),
	printLine,
    nl;
    assertz(medico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico)),
    printLine,
    writeln("Medico cadastrado com sucesso!"),
	printLine,
    adicionaMedico,
    fimMetodo.

),

get_crms_medico(CRMS) :-
    findall(CRM, medico(_, _, CRM, _, _, _), CRMS).


adicionaMedico:-
    bd_Medico,
    tell('./bd_Medico.pl'),  nl,
    listing(medico/6),
    told.
    
listarMedico:- 
    bd_Medico,
    findall(N, medico(N,_,_), ListaDeMedicos), 
    exibirListaDeMedicos(ListaDeMedicos), 
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
    findall([NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico], medico(NomeMedico, Especialidade, CRM, NumeroMedico, EmailMedico, SenhaMedico).

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
    rejeitaAgendamento(Id, T, Ret).

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

