# ----------------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Foundations of Programming - Project 1
# ----------------------------------------------

# 1.2.1
def corrigir_palavra(string):
    """
    corrigir_palavra: cad. carateres → cad. carateres

    Corrige a string, removendo o surto de palavras.
    """
    aux = []
    for char in string:
        if len(aux) != 0 and (
            (aux[-1].islower() and char.isupper() and aux[-1] == char.lower())
            or (aux[-1].isupper() and char.islower() and aux[-1].lower() == char)
        ):
            aux.pop(-1)
        else:
            aux.append(char)
    return "".join(aux)


# 1.2.2
def eh_anagrama(first, second):
    """
    eh_anagrama: cad. carateres × cad. carateres → booleano

    Deteta se duas strings são anagramas uma da outra
    """
    return sorted(first.lower()) == sorted(second.lower())


# 1.2.3
def corrigir_doc(doc):
    """
    corrigir_doc: cad. carateres → cad. carateres

    Verifica se o argumento é valido, depois corrige o surto de palavras e no final remove todos os
    anagramas diferentes da primeira ocorrência desse mesmo anagrama.
    """
    if (
        not isinstance(doc, str)
        or len(doc) == 0
        or (len(doc) == 1 and doc.isspace())
        or doc.count("  ") >= 1
        or not all(x.isalpha() or x.isspace() for x in doc)
    ):
        raise ValueError("corrigir_doc: argumento invalido")
    doc = corrigir_palavra(doc).split(" ")
    for i in range(len(doc)):
        for j in range(i, len(doc)):
            if (
                eh_anagrama(doc[i], doc[j])
                and j != i
                and doc[i].lower() != doc[j].lower()
            ):
                doc[j] = ""
    return " ".join(list(filter(None, doc)))


# 2.2.1
def obter_posicao(pos, origem):
    """
    obter_posicao: cad. carateres × inteiro → inteiro

    Obtém a posição da origem depois de ela ter sido alterada por um movimento; pos é o movimento
    e a origem é a posição inicial.
    """
    rules = {
        "C": (-3, (1, 2, 3)),
        "B": (3, (7, 8, 9)),
        "E": (-1, (1, 4, 7)),
        "D": (1, (3, 6, 9)),
    }
    if pos in rules and origem not in rules[pos][1]:
        origem += rules[pos][0]
    return origem


# 2.2.2
def obter_digito(pos, origem):
    """
    obter_digito: cad. carateres × inteiro → inteiro

    Obtém a posição da origem depois de ela ter sido alterada por uma cadeia de movimentos; pos é a
    cadeia de movimentos e a origem é a posição inicial.
    """
    for char in pos:
        origem = obter_posicao(char, origem)
    return origem


# 2.2.3
def obter_pin(moves):
    """
    obter_pin: tuplo → tuplo

    Verifica se o argumento é válido e depois obtém a posição da origem de cada um dos movimentos do tuplo.
    """
    if (
        not isinstance(moves, tuple)
        or not all(isinstance(x, str) for x in moves)
        or not 4 <= len(moves) <= 10
        or "" in moves
        or len(list(filter(None, [s.strip("CBED") for s in moves]))) != 0
    ):
        raise ValueError("obter_pin: argumento invalido")

    origem = obter_digito(moves[0], 5)
    for i in range(1, len(moves)):
        origem = origem * 10 + obter_digito(moves[i], origem % 10)
    return tuple([int(x) for x in str(origem)])


# 3.2.1 e 4.2.1
def eh_entrada(entrada):
    """
    eh entrada: universal → booleano

    Verifica se a entrada é válida.
    """
    return (
        isinstance(entrada, tuple)
        and len(entrada) == 3
        and isinstance(entrada[0], str)
        and isinstance(entrada[1], str)
        and isinstance(entrada[2], tuple)
        and len(entrada[0]) > 0
        and len(entrada[1]) == 7
        and len(entrada[2]) > 1
        and entrada[0].islower()
        and entrada[1].islower()
        and all(x.isalpha() or x == "-" for x in entrada[0])
        and entrada[1][1:6].isalpha()
        and all(isinstance(x, int) and x > 0 for x in entrada[2])
        and entrada[0].count("--") == 0
        and not (entrada[0].startswith("-") or entrada[0].endswith("-"))
        and (entrada[1].startswith("[") and entrada[1].endswith("]"))
    )


# 3.2.2
def validar_cifra(cifra, checksum):
    """
    validar_cifra: cad. carateres × cad. carateres → booleano

    Verifica se o checksum é correto com base na cifra dada, seguindo a regra explicada no
    enunciado.
    """
    cifra = sorted("".join([i for i in cifra if i.isalpha()]))
    cifra = list(dict.fromkeys(sorted(cifra, key=cifra.count, reverse=True)))
    return cifra[:5] == list(checksum[1:-1])


# 3.2.3
def filtrar_bdb(bdb):
    """
    filtrar_bdb: lista → lista

    Verifica se o argumento é valido e depois devolve as entradas em que o checksum não é
    coerente com a cifra correspondente
    """
    if (
        not isinstance(bdb, list)
        or len(bdb) == 0
        or all(not eh_entrada(x) for x in bdb)
    ):
        raise ValueError("filtrar_bdb: argumento invalido")

    for i in range(len(bdb)):
        if validar_cifra(bdb[i][0], bdb[i][1]):
            bdb[i] = ""
    return list(filter(None, bdb))


# 4.2.2
def obter_num_seguranca(nr):
    """
    obter_num_seguranca: tuplo → inteiro

    Devolve o menor valor entre qualquer par de números do tuplo.
    """
    nr = sorted(nr)
    res = nr[1] - nr[0]
    for i in range(2, len(nr)):
        if nr[i] - nr[i - 1] < res:
            res = nr[i] - nr[i - 1]
    return res


# 4.2.3
def decifrar_texto(cifra, seguranca):
    """
    decifrar_texto: cad. carateres × inteiro → cad. carateres

    Devolve o texto decifrado.
    """
    cifra = list(cifra)
    alpha = "abcdefghijklmnopqrstuvwxyz"
    while seguranca > 26:
        seguranca -= 26
    for i in range(len(cifra)):
        aux = alpha.find(cifra[i]) + seguranca
        if cifra[i] == "-":
            cifra[i] = " "
        elif i % 2 == 0:
            if aux + 1 > 25:
                cifra[i] = alpha[alpha.find("a") + aux + 1 - 26]
            else:
                cifra[i] = alpha[alpha.find(cifra[i]) + seguranca + 1]
        else:
            if aux - 1 > 25:
                cifra[i] = alpha[alpha.find("a") + aux - 1 - 26]
            else:
                cifra[i] = alpha[aux - 1]
    return "".join(list(filter(None, cifra)))


# 4.2.4
def decifrar_bdb(bdb):
    """
    decifrar_bdb: lista → lista

    Verificar se o argumento é valido e depois devolve as entradas decifradas do tuplo.
    """
    if not isinstance(bdb, list) or all(not eh_entrada(x) for x in bdb):
        raise ValueError("decifrar_bdb: argumento invalido")
    for i in range(len(bdb)):
        bdb[i] = decifrar_texto(bdb[i][0], obter_num_seguranca(bdb[i][2]))
    return bdb


# 5.2.1
def eh_utilizador(utilizador):
    """
    eh_utilizador: universal → booleano

    Verifica se o utilizador é válido.
    """
    return (
        isinstance(utilizador, dict)
        and len(utilizador) == 3
        and utilizador.keys() == {"name", "pass", "rule"}
        and isinstance(utilizador["name"], str)
        and isinstance(utilizador["pass"], str)
        and isinstance(utilizador["rule"], dict)
        and len(utilizador["name"]) > 0
        and len(utilizador["pass"]) > 0
        and len(utilizador["rule"]) == 2
        and utilizador["rule"].keys() == {"vals", "char"}
        and isinstance(utilizador["rule"]["vals"], tuple)
        and isinstance(utilizador["rule"]["char"], str)
        and len(utilizador["rule"]["vals"]) == 2
        and len(utilizador["rule"]["char"]) == 1
        and all(isinstance(x, int) and 0 < x for x in utilizador["rule"]["vals"])
        and utilizador["rule"]["vals"][0] <= utilizador["rule"]["vals"][1]
        and utilizador["rule"]["char"][0].isalpha()
        and utilizador["rule"]["char"][0].islower()
    )


# 5.2.2
def eh_senha_valida(senha, regra):
    """
    eh_senha_valida: cad. carateres × dicionário → booleano

    Verifica se a senha é válida.
    """
    return (
        len([i for i in senha if i in ["a", "e", "i", "o", "u"]]) >= 3
        and any(c1 == c2 for c1, c2 in zip(senha, senha[1:]))
        and regra["vals"][0] <= senha.count(regra["char"]) <= regra["vals"][1]
    )


# 5.2.3
def filtrar_senhas(bdb):
    """
    filtrar_senhas: lista → lista

    Devolve todos os utilizadores com senhas erradas alfabeticamente.
    """
    if (
        not isinstance(bdb, list)
        or len(bdb) == 0
        or not all(eh_utilizador(x) for x in bdb)
    ):
        raise ValueError("filtrar_senhas: argumento invalido")
    users = []
    for entrada in bdb:
        if not eh_senha_valida(entrada["pass"], entrada["rule"]):
            users.append(entrada["name"])
    return sorted(users)
