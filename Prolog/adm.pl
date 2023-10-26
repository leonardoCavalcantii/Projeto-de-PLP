:- consult('./bd_Consultas.pl').
:- consult('./bd_Medico.pl').
:- consult('./bd_Paciente.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

setup_bd_adm :-
	consult('./bd_adm.pl').

setup_bd_Consulta :-
    consult('./bd_Consultas.pl').

setup_bd_medico :-
    consult('./bd_Medico.pl').

setup_bd_paciente :-
    consult('./bd_Paciente.pl').

arquivo_vazio_adm :-
    \+(predicate_property(administrador(_,_,_), dynamic)).

logarAdm :-
    printLine,
    writeln("LOGAR ADMINISTRADOR"),
    printLine,
    writeln("Insira seu email:"),
    read_line_to_string(user_input, Email),
    
    nl,
    writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),

    (administrador(_, Email, Senha) -> nl, writeln("Login realizado com sucesso!"), nl;
    writeln("Senha incorreta!"), nl, false).

logar_Adm :-
    setup_bd_adm,
    arquivo_vazio_adm -> 
        printLine,
        writeln("Administrador nao cadastrado!"), 
        printLine,
        nl, 
        false;
        (administrador(_, _, _)) -> logarAdm;
        writeln("Administrador nao cadastrado!"), nl, false.

exibeContatoAdm :-
    setup_bd_adm,
    printLine,
    writeln("CONTATO DO ADMINISTRADOR"),
    printLine,
    findall([Nome, Email], administrador(Nome, Email, _), Adm),
    exibirAdm(Adm),
    printLine,
    told,
    fimMetodo.

exibirAdm([[Nome, Email] | T]) :-
    writeln("Nome administrador: "),
    writeln(Nome),
    nl,
    writeln("Email administrador: "),
    writeln(Email),
    exibirAdm(T).

exibirAdm([]).

listarConsultaPendentes(List) :-
    setup_bd_Consulta,
    findall([Id, Medico, Paciente, Horario, Status], (consulta(Id, Medico, Paciente, Email, Data, Horario, Status), Status == "Pendente"), List),
    told.

visualizarResumoConsulta(List):-
    findall([Medico, Paciente, Horario], consulta(Id, Medico, Paciente, Email, Data, Horario, Status), List).

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).