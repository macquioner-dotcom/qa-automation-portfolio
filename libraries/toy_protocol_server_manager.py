import os
import sys

_REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _REPO_ROOT not in sys.path:
    sys.path.insert(0, _REPO_ROOT)

from toy_protocol_mock.server import iniciar_servidor, detener_servidor  # noqa: E402


class toy_protocol_server_manager:
    """Arranca/detiene el mock TCP dentro del propio proceso de Robot Framework,
    para que la suite sea autocontenida (no requiere un proceso aparte)."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self._server = None

    def iniciar_servidor_mock_de_prueba(self):
        self._server = iniciar_servidor(port=0)
        return self._server.server_address[1]

    def detener_servidor_mock_de_prueba(self):
        if self._server:
            detener_servidor(self._server)
            self._server = None
