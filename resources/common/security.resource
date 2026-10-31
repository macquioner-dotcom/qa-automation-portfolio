*** Settings ***
Library    ../../libraries/security_scanner.py    AS    SecurityScanner

*** Keywords ***
Validar Ausencia De Datos Sensibles En Respuesta
    [Documentation]    Escanea el texto de la respuesta y falla si detecta datos sensibles expuestos (p. ej. tokens).
    [Arguments]    ${response_text}
    SecurityScanner.Validar Ausencia De Datos Sensibles    ${response_text}
