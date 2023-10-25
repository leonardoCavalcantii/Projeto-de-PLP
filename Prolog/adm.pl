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

logarAdm(Email, Senha) :-
    printLine,
    writeln("LOGAR ADMINISTRADOR"),
    printLine,
    writeln("Insira seu email:"),
    read_line_to_string(user_input, EmailInput),
    
    nl,
    writeln("Insira sua senha: "),
	read_line_to_string(user_input, SenhaInput),

    (administrador(_, Email, Senha) -> 
        (
            EmailInput = Email, SenhaInput = Senha ->
            printLine,
            writeln("Login realizado com sucesso!"),
            printLine,
            nl;
            printLine,
	        writeln("Email ou senha incorretos!"),
            printLine,
            nl,
            false
        );
        printLine,
        writeln("Email ou senha incorretos!"),
        printLine,
        nl,
        false
    ).

logar_adm(Email, Senha) :-
    setup_bd_adm,
    arquivo_vazio_adm -> 
        printLine,
        writeln("Administrador não cadastrado!"), 
        printLine,
        nl, 
        false;
	(administrador(_, Email, Senha) -> 
        logarAdm(Email, Senha);
        printLine,
        writeln("Administrador não cadastrado!"), 
        printLine,
        nl, 
        false
    ).