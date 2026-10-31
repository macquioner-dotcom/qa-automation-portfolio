*** Settings ***
Library     RequestsLibrary
Library     String
Library     ../../libraries/config_loader.py    AS    Config

*** Keywords ***
Crear Sesion Jsonplaceholder
    [Documentation]    Crea la sesion HTTP "jsonplaceholder" usando la base_url leida del config loader.
    ${base_url}=    Config.Get Nested Value    environment.base_url
    Create Session    jsonplaceholder    ${base_url}

POST Crear Post
    [Documentation]    Wrapper HTTP puro. Sin logica de negocio: la validacion
    ...    de status ocurre en la capa business, nunca aqui.
    [Arguments]    ${payload}
    ${endpoint}=    Config.Get Nested Value    endpoints.create_post
    ${response}=    POST On Session    jsonplaceholder    ${endpoint}    json=${payload}    expected_status=any
    RETURN    ${response}

GET Obtener Post
    [Documentation]    Wrapper HTTP puro: hace GET a /posts/${post_id} y devuelve la respuesta sin validarla.
    [Arguments]    ${post_id}
    ${path}=    Config.Get Nested Value    endpoints.get_post
    ${endpoint}=    Replace String    ${path}    {post_id}    ${post_id}
    ${response}=    GET On Session    jsonplaceholder    ${endpoint}    expected_status=any
    RETURN    ${response}
