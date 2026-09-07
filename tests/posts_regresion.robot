*** Settings ***
Resource    ../resources/business/posts_steps.resource
Resource    ../resources/business/posts_business.resource
Resource    ../resources/common/common.resource

*** Test Cases ***
CP-001 Crear un post exitosamente con Triple Validacion
    [Setup]    Registrar Caso De Prueba    CP-001
    GIVEN Existe Conexion Con El Servicio De Posts
    WHEN Se Crea Un Post Nuevo
    AND Se Guarda El Post En La Capa De Persistencia
    THEN La Respuesta De Creacion Es Exitosa    ${RESPONSE}
    AND El Post Quedo Persistido    ${RESPONSE.json()}[id]
    AND La Respuesta No Expone Datos Sensibles    ${RESPONSE}

CP-002 Consultar un post existente
    [Setup]    Registrar Caso De Prueba    CP-002
    GIVEN Existe Conexion Con El Servicio De Posts
    WHEN Se Consulta Un Post Existente    1
    THEN La Consulta Es Exitosa    ${RESPONSE}

CP-003 Prueba negativa: el guardrail de seguridad detecta un token expuesto
    [Documentation]    Confirma que el guardrail de seguridad SI detecta y
    ...    falla ante un dato sensible expuesto en la respuesta.
    [Setup]    Registrar Caso De Prueba    CP-003
    GIVEN Existe Conexion Con El Servicio De Posts
    WHEN Se Crea Un Post Con Un Token Expuesto
    THEN Run Keyword And Expect Error
    ...    Se detecto fuga de datos sensibles:*
    ...    La Respuesta No Expone Datos Sensibles    ${RESPONSE}
