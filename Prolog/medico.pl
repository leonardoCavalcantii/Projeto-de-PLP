bd_Medico:- consult('./Data/bd_Medico.pl'). % Esse path está errado o bd não está em um package Data então é só / bd_Medico.pl

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
    tell('./Data/bd_Medico.pl'),  nl,
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
    retornaListaDeMedicos(List),
    adicionaListaMedicos(List),
    tell('./Data/bd_Medico.pl'),  nl,
    listing(medico/3),
    told,
    fimMetodo.

adicionaListaMedicos([]). 
adicionaListaMedicos([[Nome, Especialidade, Numero] | T]):-
    addMedico(Nome, Especialidade, Numero), adicionaListaMedicos(T).

addMedico(Nome,Especialidade, Numero):-
    assertz(medico(Nome, Especialidade, Numero)).

removeMedicoAux([H|T], Nome, [H|Retorno]):- removeMedicoAux(T, Nome, Ret).

removeMedicoAux([H|T], Nome, T):- member(Nome, H).

remove_cliente_aux([],_,[]) :- nl, writeln("Medico inexistente"), nl.

retornaListaDeMedicos(Lista):-
    findall([Nome, Especialidade, Numero], medico(Nome, Especialidade, Numero), Lista);

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).
    
