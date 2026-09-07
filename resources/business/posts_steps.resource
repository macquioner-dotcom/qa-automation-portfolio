*** Settings ***
Resource    ../api/posts_api.resource
Resource    ../entities/posts_entities.resource
Resource    ../common/common.resource
Library     ../../libraries/db_validator.py    data/portfolio.db    AS    DbValidator

*** Keywords ***
GIVEN Existe Conexion Con El Servicio De Posts
    Crear Sesion Jsonplaceholder

WHEN Se Crea Un Post Nuevo
    ${payload}=    Generar Payload De Post
    ${response}=    POST Crear Post    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${PAYLOAD}    ${payload}

AND Se Guarda El Post En La Capa De Persistencia
    DbValidator.Guardar Post Creado
    ...    ${RESPONSE.json()}[id]
    ...    ${PAYLOAD}[title]
    ...    ${PAYLOAD}[body]
    ...    ${PAYLOAD}[userId]
    ...    ${EMPTY}

WHEN Se Crea Un Post Con Un Token Expuesto
    ${payload}=    Generar Payload De Post Con Token Expuesto
    ${response}=    POST Crear Post    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

WHEN Se Consulta Un Post Existente
    [Arguments]    ${post_id}
    ${response}=    GET Obtener Post    ${post_id}
    Set Test Variable    ${RESPONSE}    ${response}
