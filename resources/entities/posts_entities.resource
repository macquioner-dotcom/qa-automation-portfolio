*** Settings ***
Library    Collections
Library    String

*** Keywords ***
Generar Payload De Post
    [Documentation]    Payload de negocio "limpio" (sin datos sensibles).
    ${sufijo}=    Generate Random String    6    [LETTERS]
    ${payload}=    Create Dictionary
    ...    title=Post de prueba ${sufijo}
    ...    body=Contenido generado por la suite de portafolio
    ...    userId=${1}
    RETURN    ${payload}

Generar Payload De Post Con Token Expuesto
    [Documentation]    Payload deliberadamente "malo": incluye un token sin
    ...    enmascarar en un campo de negocio. Se usa SOLO en la prueba negativa
    ...    que confirma que el guardrail de seguridad lo detecta.
    ${payload}=    Generar Payload De Post
    Set To Dictionary    ${payload}    authToken=ABCD1234SECRETO
    RETURN    ${payload}
