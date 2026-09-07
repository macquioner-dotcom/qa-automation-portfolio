import re

# Version simplificada, para portafolio, del guardrail de seguridad que uso en
# proyectos reales: escanea un texto (por ejemplo el body de una respuesta o
# un log) buscando datos sensibles que nunca deberian salir en claro.
_REGLAS = [
    ("TOKEN_EXPUESTO", re.compile(r"(?:token|authtoken|auth_token)[\"']?\s*[:=]\s*[\"']?([A-Za-z0-9_\-.]{8,})", re.IGNORECASE)),
    ("PASSWORD_EXPUESTO", re.compile(r"password[\"']?\s*[:=]\s*[\"']?([^\"'\s,}]{3,})", re.IGNORECASE)),
]


class security_scanner:
    """Escanea texto buscando fuga de datos sensibles (version demo)."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def escanear_texto(self, texto):
        hallazgos = []
        for nombre, patron in _REGLAS:
            for match in patron.finditer(texto or ""):
                hallazgos.append(f"{nombre}: valor sin enmascarar detectado ('{match.group(1)[:6]}...')")
        return hallazgos

    def validar_ausencia_de_datos_sensibles(self, texto):
        hallazgos = self.escanear_texto(texto)
        if hallazgos:
            raise AssertionError(
                "Se detecto fuga de datos sensibles:\n" + "\n".join(hallazgos)
            )
        return "Sin exposicion de datos sensibles detectada."
