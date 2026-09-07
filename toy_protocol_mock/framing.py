"""Framing binario simple: prefijo de longitud (2 bytes, big-endian) + payload
UTF-8. Es el mismo principio que uso en protocolos de mensajeria bancaria
reales (ISO8583 sobre TCP), simplificado aqui a un protocolo de juguete propio
para no exponer nada especifico de ningun empleador/cliente.
"""
import struct

_HEADER_FORMAT = ">H"  # unsigned short, big-endian: hasta 65535 bytes de payload
_HEADER_SIZE = struct.calcsize(_HEADER_FORMAT)


def encode_frame(payload: str) -> bytes:
    data = payload.encode("utf-8")
    header = struct.pack(_HEADER_FORMAT, len(data))
    return header + data


def decode_frame(sock) -> str:
    header = _recv_exact(sock, _HEADER_SIZE)
    (length,) = struct.unpack(_HEADER_FORMAT, header)
    data = _recv_exact(sock, length)
    return data.decode("utf-8")


def _recv_exact(sock, n):
    buf = b""
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("Conexion cerrada antes de recibir el frame completo")
        buf += chunk
    return buf
