from flask import Flask, send_from_directory
from flask_socketio import SocketIO, emit
import subprocess

app = Flask(__name__, static_folder='site', static_url_path='')
socketio = SocketIO(app, cors_allowed_origins="*")

@app.route('/')
def index():
    return send_from_directory('site', 'index.html')

@socketio.on('executar_script')
def executar_script():
    try:
        process = subprocess.Popen(
            ['./oai_5g_core_install.sh'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        for linha in process.stdout:
            socketio.emit('saida', {'mensagem': linha, 'erro': False})
        
        for linha in process.stderr:
            socketio.emit('saida', {'mensagem': 'ERRO: ' + linha, 'erro': True})

    except Exception as e:
        socketio.emit('saida', {'mensagem': f'Erro ao executar: {str(e)}', 'erro': True})

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, debug=True)
