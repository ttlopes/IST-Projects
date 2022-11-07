#!/usr/bin/python3
from wsgiref.handlers import CGIHandler

from numpy import empty
from flask import Flask
from flask import render_template, request, redirect, url_for, flash
import psycopg2
import psycopg2.extras


## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist1102139"
DB_DATABASE = DB_USER
DB_PASSWORD = "hbim3458"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)

@app.route("/")
def index():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)

@app.route("/sucesso_adicionar")
def sucesso_adicionar():
    try:
        return render_template("sucesso_adicionar.html")
    except Exception as e:
        return str(e)

@app.route("/adicionar_categoria")
def adicionar_categoria():
    try:
        return render_template("adicionar_categoria.html")
    except Exception as e:
        return str(e)

@app.route("/adicionar_categoria/update", methods=["POST"])
def adicionar_categoria_update():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        nome = request.form["nome"]
        tipo = request.form["cat"]
        if nome == "":
            return redirect(url_for("adicionar_categoria"))
        if tipo == "super_categoria":
            query = 'START TRANSACTION; INSERT INTO categoria VALUES (%s); INSERT INTO super_categoria VALUES (%s); COMMIT;'
        else:
            query = 'START TRANSACTION; INSERT INTO categoria VALUES (%s); INSERT INTO categoria_simples VALUES (%s); COMMIT;'
        data = (nome, nome)
        cursor.execute(query, data)
        return redirect(url_for("sucesso_adicionar")) 
    except Exception as e:
        return str(e)


@app.route('/remover_categoria')
def remover_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria ORDER BY nome;"
        cursor.execute(query)
        return render_template("remover_categoria.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/remover_categoria/update')
def remover_categoria_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "START TRANSACTION;DELETE FROM tem_outra WHERE super_categoria=%s;DELETE FROM evento_reposicao WHERE evento_reposicao.ean IN (SELECT produto.ean FROM produto WHERE produto.cat=%s);DELETE FROM tem_outra WHERE categoria=%s;DELETE FROM planograma WHERE planograma.ean IN (SELECT produto.ean FROM produto WHERE produto.cat=%s);DELETE FROM responsavel_por WHERE nome_cat=%s;DELETE FROM prateleira WHERE nome=%s;DELETE FROM produto WHERE cat=%s;DELETE FROM super_categoria WHERE nome=%s;DELETE FROM categoria WHERE nome=%s; COMMIT;"
        data = (request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"],request.args["nome"])
        cursor.execute(query, data)
        return redirect(url_for('remover_categoria'))
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/remover_sub_categoria')
def remover_sub_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM categoria_simples ORDER BY nome;"
        cursor.execute(query)
        return render_template("remover_categoria.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/remover_sub_categoria/update')
def remover_sub_categoria_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "START TRANSACTION;DELETE FROM categoria_simples WHERE nome=%s;DELETE FROM categoria WHERE nome=%s; COMMIT;"
        data = (request.args["nome"],request.args["nome"])
        cursor.execute(query, data)
        return redirect(url_for('remover_sub_categoria'))
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/adicionar_retalhista")
def adicionar_retalhista():
    try:
        return render_template("adicionar_retalhista.html")
    except Exception as e:
        return str(e)

@app.route("/adicionar_retalhista/update", methods=["POST"])
def adicionar_retalhista_update():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        nome = request.form["nome"]
        tin = request.form["tin"]
        if nome == "" or tin == "":
            return redirect(url_for("adicionar_retalhista"))
        query = 'START TRANSACTION; INSERT INTO retalhista VALUES (%s,%s); COMMIT;'
        data = (tin, nome)
        cursor.execute(query, data)
        return redirect(url_for("sucesso_adicionar")) 
    except Exception as e:
        return str(e)

@app.route('/remover_retalhista')
def remover_retalhista():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retalhista;"
        cursor.execute(query)
        return render_template("remover_retalhista.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/remover_retalhista/update')
def remover_retalhista_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "START TRANSACTION;DELETE FROM responsavel_por WHERE tin=%s;DELETE FROM evento_reposicao WHERE tin=%s;DELETE FROM retalhista WHERE tin=%s;COMMIT;"
        data = (request.args["tin"],request.args["tin"],request.args["tin"])
        cursor.execute(query, data)
        return redirect(url_for('remover_retalhista'))
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/sub_categorias')
def sub_categorias():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria ORDER BY nome;"
        cursor.execute(query)
        return render_template("sub_categorias.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/sub_categorias/update')
def sub_categorias_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "START TRANSACTION;DELETE FROM responsavel_por WHERE tin=%s;DELETE FROM evento_reposicao WHERE tin=%s;DELETE FROM retalhista WHERE tin=%s;COMMIT;"
        data = (request.args["tin"],request.args["tin"],request.args["tin"])
        cursor.execute(query, data)
        return render_template("sub_categorias_update.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/ivms')
def ivms():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM IVM ORDER BY num_serie;"
        cursor.execute(query)
        return render_template("ivms.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/ivms/update')
def ivms_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT cat, SUM(unidades) AS unidades FROM produto NATURAL JOIN evento_reposicao WHERE num_serie = %s GROUP BY cat;"
        data = (request.args["num_serie"],)
        cursor.execute(query, data)
        return render_template("ivms_update.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/hierarquia')
def hierarquia():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria;"
        cursor.execute(query)
        return render_template("hierarquia.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/hierarquia/update')
def hierarquia_update():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "WITH RECURSIVE sub_tem_outra(super_categoria, categoria) AS (SELECT super_categoria, categoria FROM tem_outra UNION SELECT tem_outra.categoria, sub_tem_outra.super_categoria FROM tem_outra, sub_tem_outra where sub_tem_outra.super_categoria = sub_tem_outra.categoria) SELECT * FROM sub_tem_outra WHERE super_categoria = %s;"
        data = (request.args["nome"],)
        cursor.execute(query,data)
        return render_template("hierarquia_update.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/adicionar_sub_categoria')
def adicionar_sub_categoria():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria;"
        cursor.execute(query)
        return render_template("adicionar_sub_categoria.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/adicionar_sub_categoria/update', methods=["POST"])
def adicionar_sub_categoria_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        nome = request.args["nome"]
        tipo = request.args["cat"]
        categoria_pai = request.args["categoria_pai"]
        if nome == "":
            return redirect(url_for("adicionar_sub_categoria"))
        elif tipo == "super_categoria":
            query = "START TRANSACTION; INSERT INTO categoria VALUES (%s); INSERT INTO super_categoria VALUES (%s); INSERT INTO tem_outra VALUES (%s, %s); COMMIT;"
        else:
            query = "START TRANSACTION; INSERT INTO categoria VALUES (%s); INSERT INTO categoria_simples VALUES (%s); INSERT INTO tem_outra VALUES (%s, %s);  COMMIT;"
        data = (nome, nome, categoria_pai, nome)
        cursor.execute(query, data)

        return redirect(url_for("sucesso_adicionar"))
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

CGIHandler().run(app)