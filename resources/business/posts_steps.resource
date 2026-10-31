*** Settings ***
Resource    ../api/posts_api.resource
Resource    ../entities/posts_entities.resource
Resource    ../common/common.resource
Library     ../../libraries/db_validator.py    data/portfolio.db    AS    DbValidator

*** Keywords ***
Existe Conexion Con El Servicio De Posts
    [Documentation]    Precondicion: abre la sesion HTTP contra el servicio de posts.
    Crear Sesion Jsonplaceholder

Se Crea Un Post Nuevo
    [Documentation]    Genera un payload limpio, crea el post via API y guarda response/payload como variables de test.
    ${payload}=    Generar Payload De Post
    ${response}=    POST Crear Post    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${PAYLOAD}    ${payload}

Se Guarda El Post En La Capa De Persistencia
    [Documentation]    Persiste en BD el post creado, usando el id de la respuesta y los datos del payload.
    DbValidator.Guardar Post Creado
    ...    ${RESPONSE.json()}[id]
    ...    ${PAYLOAD}[title]
    ...    ${PAYLOAD}[body]
    ...    ${PAYLOAD}[userId]
    ...    ${EMPTY}

Se Crea Un Post Con Un Token Expuesto
    [Documentation]    Genera un payload con token expuesto, lo envia a la API y guarda la respuesta como variable.
    ${payload}=    Generar Payload De Post Con Token Expuesto
    ${response}=    POST Crear Post    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Se Consulta Un Post Existente
    [Documentation]    Consulta por id un post existente y guarda la respuesta como variable de test.
    [Arguments]    ${post_id}
    ${response}=    GET Obtener Post    ${post_id}
    Set Test Variable    ${RESPONSE}    ${response}
