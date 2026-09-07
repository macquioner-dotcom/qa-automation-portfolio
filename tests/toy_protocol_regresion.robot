*** Settings ***
Library     ../libraries/toy_protocol_client.py    AS    ToyProtocolClient
Resource    ../resources/common/toy_protocol_server.resource
Resource    ../resources/common/common.resource
Suite Setup       Iniciar Servidor Mock De Protocolo Propio
Suite Teardown    Detener Servidor Mock De Protocolo Propio

*** Test Cases ***
CP-004 Heartbeat del protocolo propio responde OK
    [Documentation]    Sign On / heartbeat sobre socket TCP crudo, mismo patron
    ...    que un Sign On real de ISO8583.
    [Setup]    Registrar Caso De Prueba    CP-004
    ToyProtocolClient.Conectar Al Servidor    127.0.0.1    ${TOY_PROTOCOL_PORT}
    ${respuesta}=    ToyProtocolClient.Enviar Mensaje Y Recibir Respuesta    0800|PING
    Should Be Equal    ${respuesta}    0810|PING|OK
    ToyProtocolClient.Cerrar Conexion

CP-005 Consulta de saldo exitosa sobre protocolo propio (TCP)
    [Setup]    Registrar Caso De Prueba    CP-005
    ToyProtocolClient.Conectar Al Servidor    127.0.0.1    ${TOY_PROTOCOL_PORT}
    ${respuesta}=    ToyProtocolClient.Enviar Mensaje Y Recibir Respuesta    0200|BAL|1001
    Should Be Equal    ${respuesta}    0210|BAL|1001|500000|00
    ToyProtocolClient.Cerrar Conexion

CP-006 Consulta de saldo de una cuenta inexistente
    [Setup]    Registrar Caso De Prueba    CP-006
    ToyProtocolClient.Conectar Al Servidor    127.0.0.1    ${TOY_PROTOCOL_PORT}
    ${respuesta}=    ToyProtocolClient.Enviar Mensaje Y Recibir Respuesta    0200|BAL|9999
    Should Be Equal    ${respuesta}    0210|BAL|9999|0|91
    ToyProtocolClient.Cerrar Conexion
