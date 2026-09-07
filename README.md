# QA Automation Portfolio — Arquitectura de 4 capas + Triple Validación

Proyecto de portafolio que reproduce, contra una API pública gratuita
([jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com)), el mismo
estándar de automatización E2E que uso profesionalmente sobre microservicios
reales: **Robot Framework + Python**, arquitectura de 4 capas y una metodología
propia de **Triple Validación**.

No contiene código ni datos de ningún cliente/empleador — es una versión
genérica, construida para que cualquiera pueda clonarla y correrla sin
credenciales ni VPN.

## Por qué esta arquitectura

| Capa | Responsabilidad | Regla de oro |
|---|---|---|
| `resources/api/` | Wrappers HTTP puros | Nunca valida negocio, `expected_status=any` |
| `resources/entities/` | Builders de payload / datos dinámicos | Sin llamadas HTTP |
| `resources/business/` | Orquesta api + entities, valida contrato | BDD (`GIVEN`/`WHEN`/`THEN`/`AND`) |
| `resources/common/` | Setup, seguridad, utilidades transversales | Reusado por todos los tests |

Separar estas capas evita que un cambio de endpoint obligue a tocar la lógica
de negocio, y que un cambio de regla de negocio obligue a tocar las llamadas
HTTP.

## Triple Validación

Cada caso de prueba positivo valida tres frentes, no solo el código HTTP:

1. **Contrato HTTP** — status code y forma del body (`posts_business.resource`).
2. **Persistencia** — en un proyecto real, contra la base de datos del backend
   (MySQL/Oracle). Como `jsonplaceholder` no persiste de verdad, aquí se
   simula guardando el recurso creado en una SQLite local
   (`libraries/db_validator.py`), para demostrar el mismo patrón de
   verificación "se guardó de verdad, no solo respondió 201".
3. **Guardrail de seguridad** — escanea la respuesta buscando datos sensibles
   sin enmascarar (`libraries/security_scanner.py`). El caso `CP-003` es una
   **prueba negativa**: envía a propósito un token sin enmascarar y confirma
   que el guardrail lo detecta y falla el test — es decir, la suite también
   prueba que su propia herramienta de seguridad funciona.

## Cómo correrlo

```bash
python -m venv .venv
.venv\Scripts\activate          # Windows
pip install -r requirements.txt

robot --outputdir TestResults tests/
```

Prueba de carga (opcional, requiere conexión a internet):

```bash
locust -f load_tests/locustfile.py --host https://jsonplaceholder.typicode.com
```

## Resultado esperado

- `CP-001` y `CP-002`: **PASS**.
- `CP-003`: **PASS** (el test pasa porque *confirma correctamente* que el
  guardrail de seguridad lanza el error esperado — no es un test roto).

## Stack

Python · Robot Framework · RequestsLibrary · SQLite · Locust
