*** Settings ***
Library     RequestsLibrary
Library     ../../libraries/config_loader.py    AS    Config

*** Keywords ***
Crear Sesion Jsonplaceholder
    ${base_url}=    Config.Get Nested Value    environment.base_url
    Create Session    jsonplaceholder    ${base_url}

POST Crear Post
    [Documentation]    Wrapper HTTP puro. Sin logica de negocio: la validacion
    ...    de status ocurre en la capa business, nunca aqui.
    [Arguments]    ${payload}
    ${response}=    POST On Session    jsonplaceholder    /posts    json=${payload}    expected_status=any
    RETURN    ${response}

GET Obtener Post
    [Arguments]    ${post_id}
    ${response}=    GET On Session    jsonplaceholder    /posts/${post_id}    expected_status=any
    RETURN    ${response}
