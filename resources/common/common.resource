*** Settings ***
Library    ../../libraries/db_validator.py    data/portfolio.db    AS    DbValidator

*** Keywords ***
Registrar Caso De Prueba
    [Documentation]    Setup minimo por test. En el proyecto real este keyword
    ...    ademas inyecta Documentation/Tags dinamicos leidos desde un Excel
    ...    de casos de prueba (matriz GT-GP-F05); aqui se simplifica porque
    ...    es una demo de arquitectura, no de gestion de casos.
    [Arguments]    ${cp_id}
    Set Test Documentation    ${cp_id}
