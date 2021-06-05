import MySQLdb.cursors
from flask import Flask, render_template, request, url_for, session, redirect
from flask_mysqldb import MySQL

# DÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©finition de l'application + de la clÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â© secrete premetant la communication entre la bdd et l'application
app = Flask(__name__)


def page_not_found(e):
    """
    Args:
        e:
    """
    return render_template('error/404.html'), 404


def internal_server_error(e):
    """
    Args:
        e:
    """
    return render_template('error/500.html'), 500


app.register_error_handler(404, page_not_found)
app.register_error_handler(500, internal_server_error)
app.secret_key = '6261'

# Base de donnees
# Initialisation de MySQL
mysql = MySQL(app)

# Definition de la base de donnees
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'badminton'


# Route vers l'index
@app.route('/')
@app.route('/accueil')
def index():
    if not session:  # Si il n'y a pas de session active alors on affiche la page de login
        return render_template(
            'index.html',
            title='Accueil'
        )
    else:  # Si une session est active alors on affiche le menu
        return redirect(url_for('menu'))

        # Route permettant de s'identifier + une fois loggÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â© -> entre dans l'application
@app.route('/auth', methods=['GET', 'POST'])
def auth():
    if request.method == 'POST' and 'login' in request.form and 'mdp' in request.form:  # Recupere les donnÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©es du formulaire HTML
        login = request.form['login']
        mdp = request.form['mdp']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('select * from compte where login=%s and mdp=%s', (login, mdp,))  # Execution de la requete
        compte = cursor.fetchone()  # Recuperation des donnÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©es

        if compte:
            session['loggedin'] = True
            session['id'] = compte['id']
            session['login'] = compte['login']
            return redirect(url_for('menu'))
    else:
        return render_template(
            'index.html',
            title='Connexion',
        )


# Route vers la partie gestion des adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rents
@app.route('/menu', methods=['GET', 'POST'])
def menu():
    # RÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©cupÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©ration des donnÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©es adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rent + ajout dans une liste
    cursor = mysql.connection.cursor()
    cursor.execute("select * from v_listadh")
    adh = cursor.fetchall()
    cursor.close()

    # RÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©cupÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©ration des informatins "Type" de la table Type + ajouts dans une liste
    cursType = mysql.connection.cursor()
    cursType.execute("select * from type")
    type = cursType.fetchall()
    cursType.close()

    # RÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©cupÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©ration des informations de la table Niveau + ajouts dans une liste
    cursNiveau = mysql.connection.cursor()
    cursNiveau.execute("select * from niveau")
    niveau = cursNiveau.fetchall()
    cursNiveau.close()

    return render_template(
        'menu.html',
        title='Gestion des adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rents',
        adh=adh,
        type=type,
        nivo=niveau
    )


# Route permattant la modification d'un adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rent
@app.route('/update', methods=['POST'])
def update():
    matricule = request.form['matricule']
    nom = request.form['nom']
    prenom = request.form['prenom']
    ville = request.form['ville']
    cp = request.form['cp']
    type = request.form['type']
    niveau = request.form['niveau']

    cursor = mysql.connection.cursor()
    cursor.callproc('sp_updateAdh', (nom, prenom, ville, cp, type, niveau, matricule))
    mysql.connection.commit()
    return redirect(url_for('menu'))


# Route permettant la suppression d'un adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rent
@app.route('/delete/<string:id>', methods=['GET'])
def delete(id):
    """
    Args:
        id:
    """
    cursor = mysql.connection.cursor()
    cursor.callproc('sp_deleteAdh', (id,))
    mysql.connection.commit()
    return redirect(url_for('menu'))


# Route permettant j'ajout d'un adhÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©rent dans la base de donnÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©es
@app.route('/add', methods=['POST', 'GET'])
def add():
    cursor = mysql.connection.cursor()
    nom = request.form['nom']
    prenom = request.form['prenom']
    ville = request.form['ville']
    cp = request.form['cp']
    type = request.form['type']
    niveau = request.form['niveau']

    cursor.callproc('sp_addAdh', (nom, prenom, ville, cp, niveau, type))
    mysql.connection.commit()
    return redirect(url_for('menu'))


# Route permettant de se dÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â©connecter
@app.route('/logout')
def logout():
    session.pop('loggedin', None),
    session.pop('id', None),
    session.pop('login', None),
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run()
