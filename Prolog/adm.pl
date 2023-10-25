:- consult('./bd_Agendamento.pl').
:- consult('./bd_Medico.pl').
:- consult('./bd_Paciente.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

setup_bd_adm :-
	consult('./bd_adm.pl').

setup_bd_agendamento :-
    consult('./bd_Agendamento.pl').

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