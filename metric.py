from flask import Flask, jsonify
from flask_cors import CORS
import psutil
import threading
import time

app = Flask(__name__)
CORS(app)  # Habilita CORS para permitir requisições cruzadas

def get_system_metrics():
    """Obtém os dados de consumo do sistema."""
    return {
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_usage": psutil.virtual_memory()._asdict(),
        "disk_usage": psutil.disk_usage('/')._asdict(),
        "network_usage": psutil.net_io_counters(pernic=False)._asdict()
    }

@app.route('/metrics', methods=['GET'])
def metrics():
    """Endpoint para retornar os dados de consumo do sistema."""
    return jsonify(get_system_metrics())

def run_api():
    """Executa a API Flask em uma thread separada."""
    app.run(host='0.0.0.0', port=5001, debug=False, use_reloader=False)

if __name__ == "__main__":
    api_thread = threading.Thread(target=run_api)
    api_thread.daemon = True
    api_thread.start()

    try:
        while True:
            time.sleep(1)  # Mantém o script rodando em background
    except KeyboardInterrupt:
        print("Encerrando o monitor...")
