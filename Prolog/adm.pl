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
    write("Nome administrador: "),
    writeln(Nome),
    nl,
    write("Email administrador: "),
    writeln(Email),
    exibirAdm(T).

exibirAdm([]).

atualizarAdm :-
    setup_bd_adm,
    printLine,
    writeln("ATUALIZAR CONTATO ADMINISTRADOR"),
    printLine,
    writeln("Digite o novo nome do administrador: "),
    read_line_to_string(user_input, NovoNome),

    writeln("Digite o novo email do administrador: "),
    read_line_to_string(user_input, NovoEmail),

    writeln("Digite a nova senha do administrador: "),
    read_line_to_string(user_input, NovaSenha),

    retractall(administrador(_, _, _)),
    assertz(administrador(NovoNome, NovoEmail, NovaSenha)),

    tell('./bd_Adm.pl'),
    nl,
    listing(administrador/3),
    told,

    writeln("Contato do administrador atualizado com sucesso!"),
    printLine.

listarConsultaPendentes :-
setup_bd_adm,
    printLine,
    writeln("CONSULTAS PENDENTES"),
    printLine,
    findall([Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status], consulta(Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, "Pendente"), Consultas),
    exibirConsulta(Consultas),
    printLine,
    told,
    fimMetodo.

exibirConsulta([[Id, Medico, EmailMedico, Paciente, EmailPaciente, Data, Horario, Status] | T]) :-
    write("Id: "),
    writeln(Id),

    write("Nome medico: "),
    writeln(Medico),

    write("Nome paciente: "),
    writeln(Paciente),

    write("Data: "),
    writeln(Data),

    write("Horario: "),
    writeln(Horario),
    
    writeln("-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x"),
    nl,
    exibirConsulta(T).

exibirConsulta([]).

fimMetodo:-
    writeln("Clique em enter para continuar: "),
    read_line_to_string(user_input, _).