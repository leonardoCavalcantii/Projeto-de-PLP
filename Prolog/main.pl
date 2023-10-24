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
    printLine,
    imprimirCliniSync,
    printLine,
    write( "Bem-vindo ao CliniSync - Sistema de agendamento de consultas"),
    printLine,
    showMenu.

showMenu :- 
    writeln("\nIdentifique-se selecionando o seu perfil:\n"),
    writeln("1 - Administrador"),
    writeln("2 - Paciente"),
    writeln("3 - Medico"),
    writeln("4 - Sair"),
    printLine,
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> (login_adm -> menuAdm);
        Option == "2" -> menuPaciente;
        Option == "3" -> menuMedico;
        Option == "4" -> sair;
        opcaoInvalida,
        showMenu, halt
    ).

menuAdm :-
    writeln("Selecione uma opção:"),
    writeln("1 - Ver pacientes cadastrados no sistema"),
    writeln("2 - Ver médicos cadastrados no sistema"),
    writeln("3 - Remover paciente"),
    writeln("4 - Remover médico"),
    writeln("5 - Alterar status de agendamento"),
    writeln("6 - Listar resumo de agendamentos"),
    writeln("7 - Atualizar contato Adm"),
    writeln("8 - Visualizar agendamentos pendentes"),
    whiteln("0 - voltar"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> listarPacientes, menuAdm;
        Option == "2" -> listarMedicos, menuAdm;
        Option == "3" -> removePaciente, menuAdm;
        Option == "4" -> removeMedico, menuAdm;
        Option == "5" -> alterarStatusAgendamento, menuAdm;
        Option == "6" -> listarResumoAgendamentos, menuAdm;
        Option == "7" -> atualizarAdm, menuAdm;
        Option == "8" -> listarAgendamentosPendentes, menuAdm;
        Option == "0" -> showMenu;
        opcaoInvalida,
        menuAdm
    ).

menuPaciente :-
    whiteln("Selecione uma opção:"),
    whiteln("1 - Cadastrar-se"),
    whiteln("2 - Logar"),
    whiteln("3 - Consultar dados do Administrador"),
    whiteln("0 - Voltar ao menu principal"),
    read_line_to_string(user_input, Option),
    (
        Option == "1" -> cadastraPaciente, menuPaciente;
        Option == "2" -> (logarPaciente(email) -> menuInPaciente(email));
        Option == "3" -> exibeContatoAdm, menuPaciente;
        Option == "0" -> showMenu;
        opcaoInvalida,
        menuInPaciente
    ).

opcaoInvalida :-
	 writeln("Opcao invalida!").

sair :- halt.
