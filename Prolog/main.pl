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
    writeln("\n------------------------------------------------------------------------------------------------------------------------------------------").

main :- 
    imprimirCliniSync,
    printLine,
    write( "Bem-vindo ao CliniSync - Sistema de agendamento de consultas"),
    printLine,
    showMenu.

showMenu :- 
    printLine,
    writeln("1 - Administrador"),
    writeln("2 - Paciente"),
    writeln("3 - Medico"),
    writeln("4 - Sair"),
    writeln("\nIdentifique-se selecionando o seu perfil:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (login_adm -> menuAdm);
        Option == "2" -> (menuPaciente);
        Option == "3" -> (menuMedico);
        Option == "4" -> (sair);
        opcaoInvalida,
        showMenu, halt
    ).

menuAdm :-
    printLine,
    writeln("1 - Ver pacientes cadastrados no sistema"),
    writeln("2 - Ver médicos cadastrados no sistema"),
    writeln("3 - Remover paciente"),
    writeln("4 - Remover medico"),
    writeln("5 - Alterar status de agendamento"),
    writeln("6 - Listar resumo de agendamentos"),
    writeln("7 - Atualizar contato Adm"),
    writeln("8 - Visualizar agendamentos pendentes"),
    writeln("0 - voltar"),
    printLine,
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (listarPacientes, menuAdm);
        Option == "2" -> (listarMedicos, menuAdm);
        Option == "3" -> (removePaciente, menuAdm);
        Option == "4" -> (removeMedico, menuAdm);
        Option == "5" -> (alterarStatusAgendamento, menuAdm);
        Option == "6" -> (listarResumoAgendamentos, menuAdm);
        Option == "7" -> (atualizarAdm, menuAdm);
        Option == "8" -> (listarAgendamentosPendentes, menuAdm);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuAdm
    ).

menuPaciente :-
    printLine,
    writeln("1 - Cadastrar-se"),
    writeln("2 - Logar"),
    writeln("3 - Consultar dados do Administrador"),
    writeln("0 - Voltar ao menu principal"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (cadastraPaciente, menuPaciente);
        Option == "2" -> (logarPaciente(email) -> menuInPaciente(email); menuPaciente);
        Option == "3" -> (exibeContatoAdm, menuPaciente);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuPaciente
    ).

menuInPaciente :-
    printLine,
    writeln("1 - Agendar consulta"),
    writeln("2 - Visualizar agendamentos concluidos"),
    writeln("3 - Visualizar agendamentos pendentes"),
    writeln("4 - Visualizar perfil de um medico"),
    writeln("5 - remarcar agendamento"),
    writeln("6 - cancelar agendamento"),
    writeln("0 - Voltar"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (agendaConsultaPaciente(email), menuInPaciente(email));
        Option == "2" -> (listaAgendamentosConcluidosPaciente(email), menuInPaciente(email));
        Option == "3" -> (listaAgendamentosPendentesPaciente(email), menuInPaciente(email));
        Option == "4" -> (visualizarPerfilMedico, menuInPaciente(email));
        Option == "5" -> (remarcaAgendamentoPaciente, menuInPaciente(email));
        Option == "6" -> (cancelaAgendamentoPaciente, menuInPaciente(email));
        Option == "0" -> (menuPaciente);
        opcaoInvalida,
        menuInPaciente(email)
    ).


menuMedico :-
    printLine,
    writeln("1 - Cadastrar-se"),
    writeln("2 - Logar"),
    writeln("3 - Consultar dados do Administrador"),
    writeln("0 - Voltar ao menu principal"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (cadastraMedico, menuMedico);
        Option == "2" -> (logarMedico(email), menuInMedico(email));
        Option == "3" -> (exibeContatoAdm, menuMedico);
        Option == "0" -> (showMenu);
        opcaoInvalida,
        menuMedico
    ).

menuInMedico :-
    printLine,
    writeln("1 - Visualizar agendamentos"),
    writeln("2 - Visualizar agendamentos pendentes"),
    writeln("3 - Cancelar agendamento"),
    writeln("4 - Agendar horario para consulta")
    writeln("5 - Visualizar perfil de um paciente"),
    writeln("0 - Voltar"),
    writeln("\nSelecione uma opcao:"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (listarAgendamentosMedico(email), menuInMedico(email));
        Option == "2" -> (listarAgendamentosPendentesMedico(email), menuInMedico(email));
        Option == "3" -> (cancelaAgendamentoMedico(email), menuInMedico(email));
        Option == "4" -> (agendaHorarioMedico(email), menuInMedico(email));
        Option == "5" -> (visualizarPerfilPaciente, menuInMedico(email));
        Option == "0" -> (menuMedico);
        opcaoInvalida,
        menuInMedico(email)
    ).

opcaoInvalida :-
	 writeln("Opcao invalida!").

sair :- halt.
