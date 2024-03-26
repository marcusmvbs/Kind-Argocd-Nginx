from flask import Flask, render_template
from os import uname


app = Flask(__name__,
            template_folder='templates/html')

@app.route('/')
def index():

    return render_template('index.html', maquina=uname().nodename)

if __name__ == '__main__':   # Will not be executed from another script, only executed directly
    app.run()