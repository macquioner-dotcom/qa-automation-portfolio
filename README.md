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

## Protocolo propio sobre TCP (socket crudo)

Además del flujo REST, `toy_protocol_mock/` implementa un protocolo de
mensajería propio de juguete sobre TCP (framing binario con prefijo de
longitud de 2 bytes + payload UTF-8, dispatch por tipo de mensaje y códigos de
respuesta) — el mismo principio que uso en protocolos bancarios reales tipo
ISO8583, aquí simplificado y con datos 100% inventados. El servidor arranca
dentro del propio proceso de la suite (`Suite Setup`), así que no depende de
ningún proceso externo: `robot tests/` lo levanta y lo apaga solo.

## CI

Cada push/PR a `main` dispara `.github/workflows/tests.yml`, que instala
dependencias y corre toda la suite (REST + TCP) en GitHub Actions, publicando
el reporte de Robot Framework como artifact descargable.

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

```
Tests.Posts Regresion          | PASS |
3 tests, 3 passed, 0 failed
Tests.Toy Protocol Regresion    | PASS |
3 tests, 3 passed, 0 failed
Tests                           | PASS |
6 tests, 6 passed, 0 failed
```

`CP-003` pasa porque *confirma correctamente* que el guardrail de seguridad
lanza el error esperado — no es un test roto.

## Stack

Python · Robot Framework · RequestsLibrary · sockets TCP (framing binario propio) · SQLite · Locust · GitHub Actions
