import os
import sqlite3


class db_validator:
    """Simula la capa de 'persistencia' de la metodologia de Triple Validacion.

    En un proyecto real esta libreria consultaria la base de datos real del
    backend (MySQL/Oracle/Mongo) para confirmar que la transaccion quedo
    persistida. Como esta es una version de portafolio contra una API publica
    que NO persiste de verdad (jsonplaceholder.typicode.com simula las
    respuestas pero no guarda nada), esta libreria guarda una copia local en
    SQLite del recurso creado, para poder demostrar el mismo patron de
    verificacion: "hago la llamada HTTP" -> "confirmo que quedo guardado".
    """

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, db_path="data/portfolio.db"):
        self._db_path = db_path
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        self._init_schema()

    def _connect(self):
        return sqlite3.connect(self._db_path)

    def _init_schema(self):
        with self._connect() as conn:
            conn.execute(
                """
                CREATE TABLE IF NOT EXISTS posts_creados (
                    post_id INTEGER PRIMARY KEY,
                    title TEXT NOT NULL,
                    body TEXT NOT NULL,
                    user_id INTEGER NOT NULL,
                    auth_token TEXT
                )
                """
            )
            conn.commit()

    def guardar_post_creado(self, post_id, title, body, user_id, auth_token):
        with self._connect() as conn:
            conn.execute(
                "INSERT OR REPLACE INTO posts_creados (post_id, title, body, user_id, auth_token) "
                "VALUES (?, ?, ?, ?, ?)",
                (int(post_id), title, body, int(user_id), auth_token),
            )
            conn.commit()

    def obtener_post_guardado(self, post_id):
        with self._connect() as conn:
            conn.row_factory = sqlite3.Row
            row = conn.execute(
                "SELECT * FROM posts_creados WHERE post_id = ?", (int(post_id),)
            ).fetchone()
            return dict(row) if row else None
