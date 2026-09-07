import os
import socket
import sys

_REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _REPO_ROOT not in sys.path:
    sys.path.insert(0, _REPO_ROOT)

from toy_protocol_mock.framing import encode_frame, decode_frame  # noqa: E402


class toy_protocol_client:
    """Cliente TCP crudo para el protocolo de juguete, usado desde los tests
    de Robot Framework igual que un cliente real de socket."""

    ROBOT_LIBRARY_SCOPE = "TEST"

    def __init__(self):
        self._sock = None

    def conectar_al_servidor(self, host, port):
        self._sock = socket.create_connection((host, int(port)), timeout=5)

    def enviar_mensaje_y_recibir_respuesta(self, mensaje):
        self._sock.sendall(encode_frame(mensaje))
        return decode_frame(self._sock)

    def cerrar_conexion(self):
        if self._sock:
            self._sock.close()
            self._sock = None
