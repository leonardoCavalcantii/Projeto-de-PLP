bd_Paciente:- consult('./bd_Paciente.pl').

cadastraPaciente :-
	bd_Paciente, nl,
	nl, writeln("Digite seus dados: "),
	nl, writeln("nome: "),
	read_line_to_string(user_input, Nome),
	nl, writeln("cpf: "),
	read_line_to_string(user_input, CPF),
	nl, writeln("telefone: "),
	read_line_to_string(user_input, Telefone),
	nl, writeln("peso: "),
	read_line_to_string(user_input, Peso),
	nl, writeln("idade: "),
	read_line_to_string(user_input, idade),
	nl, writeln("grupo sanguineo: "),
	read_line_to_string(user_input, Grupo_Sanguineo),
	nl, writeln("email: "),
	read_line_to_string(user_input, Email),
	nl, writeln("senha: "),
	read_line_to_string(user_input, Senha).
	nl,
	(get_emails_clientes(Emails), member(Email, Emails) -> nl, writeln("Email já cadastrado."), nl;
	assertz(cliente(Nome, Email, Senha, Telefone)),
	adicionaCliente,
	writeln("Cliente cadastrado com sucesso!"),nl),
	fimMetodo.

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

