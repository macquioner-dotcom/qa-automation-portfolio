import os
import yaml


class config_loader:
    """Lee config/qa.yaml y expone sus valores a Robot Framework mediante notacion de punto.

    Ejemplo de uso en un .resource:
        Library    ../../libraries/config_loader.py    AS    Config
        ${base_url}=    Config.Get Nested Value    environment.base_url
    """

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, config_path=None):
        if config_path is None:
            here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            config_path = os.path.join(here, "config", "qa.yaml")
        with open(config_path, "r", encoding="utf-8") as f:
            self._config = yaml.safe_load(f)

    def get_nested_value(self, key_path):
        keys = key_path.split(".")
        value = self._config
        for key in keys:
            if not isinstance(value, dict) or key not in value:
                raise KeyError(f"Key path '{key_path}' not found in config (failed at '{key}')")
            value = value[key]
        return value
