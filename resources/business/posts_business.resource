*** Settings ***
Library    Collections
Resource   ../common/common.resource
Resource   ../common/security.resource

*** Keywords ***
La Respuesta De Creacion Es Exitosa
    [Documentation]    Triple Validacion, paso 1: contrato HTTP.
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Dictionary Should Contain Key    ${response.json()}    title

El Post Quedo Persistido
    [Documentation]    Triple Validacion, paso 2: persistencia (simulada en
    ...    SQLite local, ver libraries/db_validator.py).
    [Arguments]    ${post_id}
    ${guardado}=    DbValidator.Obtener Post Guardado    ${post_id}
    Should Not Be Equal    ${guardado}    ${None}    msg=El post no quedo guardado en la capa de persistencia

La Consulta Es Exitosa
    [Documentation]    Validacion de contrato para operaciones de lectura (GET).
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    id

La Respuesta No Expone Datos Sensibles
    [Documentation]    Triple Validacion, paso 3: guardrail de seguridad sobre
    ...    el body de la respuesta (en el proyecto real, tambien sobre logs
    ...    de Kubernetes).
    [Arguments]    ${response}
    Validar Ausencia De Datos Sensibles En Respuesta    ${response.text}
