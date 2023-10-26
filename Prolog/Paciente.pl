setup_bd_Paciente :-
    consult('./bd_Paciente.pl').

setup_bd_consulta :-
    consult('./bd_Consultas.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

arquivo_vazio :-
	\+(predicate_property(paciente(_,_,_,_,_,_,_,_), dynamic)).

cadastraPaciente :-
    setup_bd_Paciente,
    printLine,
    writeln("CADASTRO NOVO PACIENTE"),
    printLine,
    writeln("Digite seus dados: "),

    nl, writeln("Nome: "),
    read_line_to_string(user_input, Nome),

    nl, writeln("CPF: "),
    read_line_to_string(user_input, CPF),

    nl, writeln("Telefone: "),
    read_line_to_string(user_input, Telefone),

    nl, writeln("Peso: "),
    read_line_to_string(user_input, Peso),

    nl, writeln("Idade: "),
    read_line_to_string(user_input, Idade),

    nl, writeln("Grupo Sanguineo: "),
    read_line_to_string(user_input, GP),

    nl, writeln("Email: "),
    read_line_to_string(user_input, Email),

    nl, writeln("Senha: "),
    read_line_to_string(user_input, Senha),

    nl,
    (get_emails_paciente(Emails), member(Email, Emails) ->
		printLine,
        writeln("Email ja cadastrado!"),
		printLine,
        nl;
        assertz(paciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha)),
        adicionaPaciente,
		printLine,
        writeln("Paciente cadastrado com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

adicionaPaciente :-
    setup_bd_Paciente,
    tell('./bd_Paciente.pl'),
    nl,
    listing(paciente/8),
    told.

get_emails_paciente(Emails) :-
    findall(Email, paciente(_, _, _, _, _, _, Email, _), Emails).

logarPaciente(Email) :-
	printLine,
	writeln("LOGAR PACIENTE"),
	printLine,
	writeln("Insira seu email: "),
	read_line_to_string(user_input, Email),

	nl,
	writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),

	(paciente(_,_,_,_,_,_, Email, Senha) -> nl, writeln("Login realizado com sucesso!"), nl;
	writeln("Senha incorreta!"), nl, false).

logar_Paciente(Email) :-
	setup_bd_Paciente,
	arquivo_vazio -> 
        printLine,
	    writeln("Paciente nao cadastrado!"), 
        printLine,
	    nl, 
	    false;
	    (paciente(_,_,_,_,_,_,_,_)) -> logarPaciente(Email);
	    writeln("Paciente nao cadastrado!"), nl, false.


listarPacientes :-
    setup_bd_Paciente,
    printLine,
    writeln("LISTA DE PACIENTES CADASTRADOS"),
    printLine,
    findall(Nome, paciente(Nome, _, _, _, _, _, _, _), ListaDePaciente),
    exibirListaDePaciente(ListaDePaciente),
    printLine,
    told,
    fimMetodo.

exibirListaDePaciente([H|T]) :-
    writeln(H),
    exibirListaDePaciente(T).

exibirListaDePaciente([]).

listaConsultasConcluidasPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS CONCLUIDAS"),
    printLine,
    findall([Id, Paciente, Email, Medico, Data, Horario, Status], consulta(Id, Medico, Paciente, Email, Data, Horario, "Concluida"), Consultas),
    exibirConsultas(Consultas),
    printLine,
    told,
    fimMetodo.

removePacienteEmail :-
    setup_bd_Paciente,
    printLine,
    writeln("DESCADASTRAR PACIENTE"),
    printLine,
    writeln("Digite os dados: "),
    nl, writeln("Email: "),
    read_line_to_string(user_input, Email),

    nl,
    (
        retractall(paciente(_, _, _, _, _, _, Email, _)),
        removePaciente,
		printLine,
        writeln("Paciente removido com sucesso!"),
		printLine,
        nl
    ),
    fimMetodo.

removePaciente :-
    tell('./bd_Paciente.pl'),
    nl,
    listing(paciente/8),
    told.
   
fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).