*** Settings ***
Library    ../../libraries/security_scanner.py    AS    SecurityScanner

*** Keywords ***
Validar Ausencia De Datos Sensibles En Respuesta
    [Arguments]    ${response_text}
    SecurityScanner.Validar Ausencia De Datos Sensibles    ${response_text}
