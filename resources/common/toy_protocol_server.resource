*** Settings ***
Library    ../../libraries/toy_protocol_server_manager.py    AS    ToyProtocolServer

*** Keywords ***
Iniciar Servidor Mock De Protocolo Propio
    [Documentation]    Levanta el servidor mock del protocolo propio y guarda el puerto asignado como variable de suite.
    ${port}=    ToyProtocolServer.Iniciar Servidor Mock De Prueba
    Set Suite Variable    ${TOY_PROTOCOL_PORT}    ${port}

Detener Servidor Mock De Protocolo Propio
    [Documentation]    Detiene y libera el servidor mock del protocolo propio levantado en el Suite Setup.
    ToyProtocolServer.Detener Servidor Mock De Prueba
