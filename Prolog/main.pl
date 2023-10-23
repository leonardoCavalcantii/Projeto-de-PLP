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
    writeln("3 - Médico"),
    writeln("4 - Sair"),
    printLine,
    read_line_to_string(user_input, Option),
    (
        Option == "1" ->
    )


