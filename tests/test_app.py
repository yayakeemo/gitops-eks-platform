from app.main import app


def client():
    app.config.update(TESTING=True)
    return app.test_client()


def test_index_returns_message():
    resp = client().get("/")
    assert resp.status_code == 200
    assert "message" in resp.get_json()


def test_healthz_is_ok():
    resp = client().get("/healthz")
    assert resp.status_code == 200
    assert resp.get_json() == {"status": "ok"}


def test_version_reports_a_version():
    resp = client().get("/version")
    assert resp.status_code == 200
    assert resp.get_json()["version"]
