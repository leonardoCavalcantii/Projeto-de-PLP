bd_Medico:- consult('./bd_Medico.pl').
bd_Agendamento:- consult('./bd_Agendamento').

cadastraMedico:- 
    bd_Medico, nl,
   nl, writeln("Digite seus dados: "),
    writeln("Digite seu nome: "),
    read_line_to_string(user_input, NomeMedico), nl,

    writeln("Digite sua especialidade: "),
    read_line_to_string(user_input, Especialidade), nl,

    writeln("Digite seu numero: "),
    read_line_to_string(user_input, Numero), nl,

    assertz(medico(NomeMedico, Especialidade, Numero)),
    adicionaMedico,
    fimMetodo.

adicionaMedico:-
    bd_Medico,
    tell('./bd_Medico.pl'),  nl,
    listing(medico/3),
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
    findall([Nome, Especialidade, Numero], medico(Nome, Especialidade, Numero), Lista).

adicionaListaMedicos([]). 

adicionaListaMedicos([[Nome, Especialidade, Numero] | T]):-
    addMedico(Nome, Especialidade, Numero), adicionaListaMedicos(T).

addMedico(Nome,Especialidade, Numero):-
    assertz(medico(Nome, Especialidade, Numero)).

    removeMedicoAux([H|_], Nome, _) :-
        member(Nome, H),
        !.
    
    removeMedicoAux([H|T], Nome, [H|Retorno]) :-
        removeMedicoAux(T, Nome, Retorno).
    
    removeMedicoAux([], _, []) :-
        nl, writeln("Medico inexistente"), nl.

visualizarAgendamentos(Medico, List):-
    bd_Agendamento,
    findall([Medico, Paciente, Horario, Status], agendamento(Medico, Paciente, Horario, Status), List),
    told.

visualizarAgendamentosPendentes(Medico, List) :-
    bd_Agendamento,
    findall([Medico, Paciente, Horario, Status], (agendamento(Medico, Paciente, Horario, Status), Status == "Pendente"), List),
    told.
    
        

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).

