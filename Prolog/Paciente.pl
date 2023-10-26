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

listaConsultasConcluidasPaciente(Email) :-
    setup_bd_consulta,
    printLine,
    writeln("LISTA DE CONSULTAS CONCLUIDAS PACIENTE"),
    printLine,
    findall([Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status], consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, "Concluida"), Consultas),
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

visualizarPerfilPaciente :-
    setup_bd_Paciente,
    writeln("Digite o email do paciente: "),
    read_line_to_string(user_input, EmailPaciente),
    printLine,
    writeln("PERFIL DO PACIENTE"),
    printLine,

    (paciente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha) ->
        write("Nome: "),
        writeln(Nome),
        nl,
        write("CPF: "),
        writeln(CPF),
        nl,
        write("Telefone: "),
        writeln(Telefone),
        nl,
        write("Peso: "),
        writeln(Peso),
        nl,
        write("Idade: "),
        writeln(Idade),
        nl,
        write("Grupo Sanguineo: "),
        writeln(GP),
        nl,
        write("Email: "),
        writeln(Email),
        printLine;
        writeln("Paciente nao encontrado no sistema.")
    ),
    told,
    fimMetodo.

fimMetodo:-
    printLine,
	writeln("Pressione enter para continuar: "),
	read_line_to_string(user_input, _).