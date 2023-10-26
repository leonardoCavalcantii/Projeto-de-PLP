:- include('./adm.pl').
:- include('./consultas.pl').
:- include('./bd_Medico.pl').
:- include('./bd_Paciente.pl').
:- include('./medico.pl').
:- include('./Paciente.pl').
:- include('./horario.pl').

imprimirCliniSync :-
    writeln("                                                                                                                                          "),
    writeln("        CCCCCCCCCCCCClllllll   iiii                     iiii     SSSSSSSSSSSSSSS                                                          "),
    writeln("     CCC::::::::::::Cl:::::l  i::::i                   i::::i  SS:::::::::::::::S                                                         "),
    writeln("   CC:::::::::::::::Cl:::::l   iiii                     iiii  S:::::SSSSSS::::::S                                                         "),
    writeln("  C:::::CCCCCCCC::::Cl:::::l                                  S:::::S     SSSSSSS                                                         "),
    writeln(" C:::::C       CCCCCC l::::l iiiiiiinnnn  nnnnnnnn    iiiiiii S:::::S      yyyyyyy           yyyyyyynnnn  nnnnnnnn        cccccccccccccccc"),
    writeln("C:::::C               l::::l i:::::in:::nn::::::::nn  i:::::i S:::::S       y:::::y         y:::::y n:::nn::::::::nn    cc:::::::::::::::c"),
    writeln("C:::::C               l::::l  i::::in::::::::::::::nn  i::::i  S::::SSSS     y:::::y       y:::::y  n::::::::::::::nn  c:::::::::::::::::c"),
    writeln("C:::::C               l::::l  i::::inn:::::::::::::::n i::::i   SS::::::SSSSS y:::::y     y:::::y   nn:::::::::::::::nc:::::::cccccc:::::c"),
    writeln("C:::::C               l::::l  i::::i  n:::::nnnn:::::n i::::i     SSS::::::::SSy:::::y   y:::::y      n:::::nnnn:::::nc::::::c     ccccccc"),
    writeln("C:::::C               l::::l  i::::i  n::::n    n::::n i::::i        SSSSSS::::Sy:::::y y:::::y       n::::n    n::::nc:::::c             "),
    writeln("C:::::C               l::::l  i::::i  n::::n    n::::n i::::i             S:::::Sy:::::y:::::y        n::::n    n::::nc:::::c             "),
    writeln(" C:::::C       CCCCCC l::::l  i::::i  n::::n    n::::n i::::i             S:::::S y:::::::::y         n::::n    n::::nc::::::c     ccccccc"),
    writeln("  C:::::CCCCCCCC::::Cl::::::li::::::i n::::n    n::::ni::::::iSSSSSSS     S:::::S  y:::::::y          n::::n    n::::nc:::::::cccccc:::::c"),
    writeln("   CC:::::::::::::::Cl::::::li::::::i n::::n    n::::ni::::::iS::::::SSSSSS:::::S   y:::::y           n::::n    n::::n c:::::::::::::::::c"),
    writeln("     CCC::::::::::::Cl::::::li::::::i n::::n    n::::ni::::::iS:::::::::::::::SS   y:::::y            n::::n    n::::n  cc:::::::::::::::c"),
    writeln("        CCCCCCCCCCCCClllllllliiiiiiii nnnnnn    nnnnnniiiiiiii SSSSSSSSSSSSSSS    y:::::y             nnnnnn    nnnnnn    cccccccccccccccc"),
    writeln("                                                                                 y:::::y                                                  "),
    writeln("                                                                                y:::::y                                                   "),
    writeln("                                                                               y:::::y                                                    "),
    writeln("                                                                              y:::::y                                                     "),
    writeln("                                                                             yyyyyyy                                                      ").
   

printLine :-
    writeln("------------------------------------------------------------------------------------------------------------------------------------------").

main :- 
    imprimirCliniSync,
    printLine,
    writeln("Bem-vindo ao CliniSync - Sistema de agendamento de consultas!"),
    printLine,
    showMenu.

showMenu :- 
    printLine,
    writeln("MENU"),
    printLine,
    writeln("Identifique o seu perfil:\n"),
    writeln("   1 - Administrador"),
    writeln("   2 - Paciente"),
    writeln("   3 - Medico"),
    writeln("   4 - Sair"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (logar_Adm -> menuAdm);
        Option == "2" -> (menuPaciente);
        Option == "3" -> (menuMedico);
        Option == "4" -> (sair);
        opcaoInvalida,
        showMenu, halt
    ).

menuAdm :-
    printLine,
    writeln("MENU ADMINISTRADOR"),
    printLine,
    writeln("1 - Ver pacientes cadastrados no sistema"),
    writeln("2 - Ver medicos cadastrados no sistema"),
    writeln("3 - Remover paciente"),
    writeln("4 - Remover medico"),
    writeln("5 - Alterar status da consulta"),
    writeln("6 - Listar resumo de consultas"),
    writeln("7 - Visualizar consultas pendentes"),
    writeln("8 - Atualizar contato Adm"),
    writeln("0 - voltar"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (listarPacientes, menuAdm);
        Option == "2" -> (listarMedicos, menuAdm);
        Option == "3" -> (removePacienteEmail, menuAdm);
        Option == "4" -> (removeMedicoEmail, menuAdm);
        Option == "5" -> (alterarStatusConsulta, menuAdm);
        Option == "6" -> (listarResumoConsultas, menuAdm);
        Option == "7" -> (listarConsultaPendentes, menuAdm);
        Option == "8" -> (atualizarAdm, menuAdm);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuAdm
    ).

menuPaciente :-
    printLine,
    writeln("MENU PACIENTE"),
    printLine,
    writeln("1 - Cadastrar-se"),
    writeln("2 - Logar"),
    writeln("3 - Consultar dados do Administrador"),
    writeln("0 - Voltar ao menu principal"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (cadastraPaciente, menuPaciente);
        Option == "2" -> (logarPaciente(Email) -> menuInPaciente(Email); showMenu);
        Option == "3" -> (exibeContatoAdm, menuPaciente);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuPaciente
    ).

menuInPaciente(Email) :-
    printLine,
    writeln("MENU DE INTERACAO PACIENTE"),
    printLine,
    writeln("1 - Marcar consulta"),
    writeln("2 - Remarcar consulta"),
    writeln("3 - Desmarcar consulta"),
    writeln("4 - Visualizar consultas concluidas"),
    writeln("5 - Visualizar consultas pendentes"),
    writeln("6 - Visualizar perfil de um medico"),
    writeln("7 - Visualizar horarios de um medico"),
    writeln("0 - Voltar"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (agendaConsultaPaciente(Email), menuInPaciente(Email));
        Option == "2" -> (remarcaConsultaPaciente(Email), menuInPaciente(Email));
        Option == "3" -> (dermarcarConsultaPaciente(Email), menuInPaciente(Email));
        Option == "4" -> (listaConsultasConcluidasPaciente(Email), menuInPaciente(Email));
        Option == "5" -> (listaConsultasPendentesPaciente(Email), menuInPaciente(Email));
        Option == "6" -> (visualizarPerfilMedico, menuInPaciente(Email));
        Option == "7" -> (visualizarHorariosMedico, menuInPaciente(Email));
        Option == "0" -> (menuPaciente);
        opcaoInvalida,
        menuInPaciente
    ).

menuMedico :-
    printLine,
    writeln("MENU MEDICO"),
    printLine,
    writeln("1 - Cadastrar-se"),
    writeln("2 - Logar"),
    writeln("3 - Consultar dados do Administrador"),
    writeln("0 - Voltar ao menu principal"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (cadastraMedico, menuMedico);
        Option == "2" -> (logarMedico(Email) -> menuInMedico(Email); showMenu);
        Option == "3" -> (exibeContatoAdm, menuMedico);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuMedico
    ).

menuInMedico(Email) :-
    printLine,
    writeln("MENU DE INTERACAO MEDICO"),
    printLine,
    writeln("1 - Adicionar horario para consulta"),
    writeln("2 - Remover horario para consulta"),
    writeln("3 - Visualizar horarios para consulta"),
    writeln("4 - Visualizar consultas concluidas"),
    writeln("5 - Visualizar consultas pendentes"),
    writeln("6 - Visualizar perfil de um paciente"),
    writeln("7 - Cancelar consulta"),
    writeln("0 - Voltar"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (agendarHorarioMedico(Email), menuInMedico(Email));
        Option == "2" -> (removerHorarioMedico, menuInMedico(Email));
        Option == "3" -> (visualizarHorariosMedico(Email), menuInMedico(Email));
        Option == "4" -> (listarConsultasConcluidasMedico(Email), menuInMedico(Email));
        Option == "5" -> (listarConsultasPendentesMedico(Email), menuInMedico(Email));
        Option == "6" -> (visualizarPerfilPaciente, menuInMedico(Email));
        Option == "7" -> (cancelaConsultaMedico(Email), menuInMedico(Email));
        Option == "0" -> (menuMedico);
        opcaoInvalida,
        menuInMedico
    ).

opcaoInvalida :-
	 writeln("Opcao invalida!").

sair :- 
    printLine,
    writeln("Saindo do CliniSync..."),
    printLine,
    writeln("Obrigado por usar nosso sistema."),
    printLine,
    halt.
