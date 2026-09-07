"""Servidor TCP de un protocolo propio de juguete (no es ISO8583 real): mensajes
tipo 'MTI|campo1|campo2|...', mismo espiritu (framing binario + dispatch por
tipo de mensaje + codigo de respuesta) que un mock de protocolo bancario real,
pero con datos y reglas 100% inventados para portafolio.
"""
import socketserver
import threading

from toy_protocol_mock.framing import encode_frame, decode_frame

# "Base de datos" de cuentas de juguete, solo para esta demo
_CUENTAS = {
    "1001": 500000,
    "1002": 0,
}


class ToyProtocolHandler(socketserver.BaseRequestHandler):
    def handle(self):
        while True:
            try:
                mensaje = decode_frame(self.request)
            except (ConnectionError, OSError):
                break
            respuesta = _procesar_mensaje(mensaje)
            self.request.sendall(encode_frame(respuesta))


def _procesar_mensaje(mensaje: str) -> str:
    campos = mensaje.split("|")
    mti = campos[0]

    if mti == "0800":
        # Sign On / heartbeat, igual patron que un Sign On real de ISO8583
        return "0810|PING|OK"

    if mti == "0200" and len(campos) >= 3 and campos[1] == "BAL":
        cuenta = campos[2]
        if cuenta in _CUENTAS:
            return f"0210|BAL|{cuenta}|{_CUENTAS[cuenta]}|00"
        return f"0210|BAL|{cuenta}|0|91"

    return "0210|99"  # MTI/operacion no reconocida


def iniciar_servidor(port=0):
    server = socketserver.ThreadingTCPServer(("127.0.0.1", port), ToyProtocolHandler)
    server.allow_reuse_address = True
    hilo = threading.Thread(target=server.serve_forever, daemon=True)
    hilo.start()
    return server


def detener_servidor(server):
    server.shutdown()
    server.server_close()
