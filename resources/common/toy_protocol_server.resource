*** Settings ***
Library    ../../libraries/toy_protocol_server_manager.py    AS    ToyProtocolServer

*** Keywords ***
Iniciar Servidor Mock De Protocolo Propio
    ${port}=    ToyProtocolServer.Iniciar Servidor Mock De Prueba
    Set Suite Variable    ${TOY_PROTOCOL_PORT}    ${port}

Detener Servidor Mock De Protocolo Propio
    ToyProtocolServer.Detener Servidor Mock De Prueba
