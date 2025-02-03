from flask import Flask, jsonify, request, send_from_directory
import subprocess
import os

app = Flask(__name__, static_folder='site', static_url_path='')

@app.route('/')
def index():
    # Serve o arquivo HTML principal
    return send_from_directory('site', 'index.html')

@app.route('/executar', methods=['POST'])
def executar_script():
    try:
        # Executa o script Bash e captura a saída
        resultado = subprocess.run(['./oai_tools.sh'], capture_output=True, text=True, shell=True)
        return jsonify({
            'status': 'success',
            'saida': resultado.stdout,
            'erro': resultado.stderr
        })
    except Exception as e:
        return jsonify({'status': 'error', 'mensagem': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
