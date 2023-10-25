bd_Paciente:- 
	consult('./bd_Paciente.pl').

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").


cadastraPaciente :-
	bd_Paciente, nl,
	printLine,
	whiteln('CADASTRO NOVO PACIENTE')
	printLine,
	writeln("Digite seus dados: "),

	writeln("nome: "),
	read_line_to_string(user_input, Nome),

	writeln("cpf: "),
	read_line_to_string(user_input, CPF),

	writeln("telefone: "),
	read_line_to_string(user_input, Telefone),

	writeln("peso: "),
	read_line_to_string(user_input, Peso),

	writeln("idade: "),
	read_line_to_string(user_input, Idade),

	writeln("grupo sanguineo: "),
	read_line_to_string(user_input, GP),

	writeln("email: "),
	read_line_to_string(user_input, Email),

	writeln("senha: "),
	read_line_to_string(user_input, Senha).
	
	nl,
	(get_emails_clientes(Emails), member(Email, Emails) -> nl, writeln("Email ja cadastrado."), nl;
	assertz(cliente(Nome, CPF, Telefone, Peso, Idade, GP, Email, Senha)),
	adicionaPaciente,
	writeln("Paciente cadastrado com sucesso!"),nl),
	fimMetodo.

adicionaPaciente :-
	bd_Paciente,
	tell('./bd_Paciente.pl'), nl,
	listening(Paciente/8),
	told.

get_emails_paciente(Emails) :- 
	findall(Email, paciente(_,Email,_,_), Emails).

loginPaciente(Email) :-
	nl,
	writeln("Insira seu email: "),
	read_line_to_string(user_input, Email),
	writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),
	(cliente(_, Email, Senha, _) -> nl, writeln("Login realizado com sucesso!"), nl;
	writeln("Senha incorreta."), nl, false).

login_paciente(Email) :-
	setup_bd,
	arquivo_vazio -> writeln("Paciente não cadastrado."), nl, false;
	(paciente(_, _, _, _) -> loginPaciente(Email);
	writeln("Paciente não cadastrado."), nl, false),
	fimMetodo.

fimMetodo:-
	writeln("Clique em enter para continuar: "),
	read_line_to_string(user_input, _).

