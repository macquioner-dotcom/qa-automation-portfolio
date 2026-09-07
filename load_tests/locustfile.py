from locust import HttpUser, task, between


class PostsUser(HttpUser):
    """Escenario de carga de portafolio contra la API publica jsonplaceholder.

    Uso:
        locust -f load_tests/locustfile.py --host https://jsonplaceholder.typicode.com
    """

    wait_time = between(1, 2)

    @task(3)
    def consultar_post(self):
        self.client.get("/posts/1", name="GET /posts/:id")

    @task(1)
    def crear_post(self):
        self.client.post(
            "/posts",
            json={"title": "carga", "body": "prueba de carga", "userId": 1},
            name="POST /posts",
        )
