# ----------------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Foundations of Programming - Project 2
# ----------------------------------------------

###############
# TAD Posicao #
###############


def cria_posicao(abscissas, ordenadas):
    """
    cria posicao: int × int -> posicao

    Cria uma posicao com as coordenadas (abscissas, ordenadas)
    """
    if (
        not isinstance(abscissas, int)
        or not isinstance(ordenadas, int)
        or abscissas < 0
        or ordenadas < 0
    ):
        raise ValueError("cria_posicao: argumentos invalidos")
    return (abscissas, ordenadas)


def cria_copia_posicao(pos):
    """
    cria_copia_posicao: posicao -> int

    Cria uma cópia da posição
    """
    return (pos[0], pos[1])


def obter_pos_x(pos):
    """
    obter_pos_x: posicao -> int

    Obtém a coordenada x de uma posição
    """
    return pos[0]


def obter_pos_y(pos):
    """
    obter_pos_y: posicao -> int

    Obtém a coordenada y de uma posição
    """
    return pos[1]


def eh_posicao(pos):
    """
    eh_posicao: universal -> booleano

    Verifica se um objeto é uma posição
    """
    try:
        return bool(cria_posicao(obter_pos_x(pos), obter_pos_y(pos)))
    except:
        return False


def posicoes_iguais(p1, p2):
    """
    posicoes_iguais: posicao × posicao -> booleano

    Verifica se duas posições são iguais
    """
    if eh_posicao(p1):
        return p1 == p2
    return False


def posicao_para_str(pos):
    """
    posicao_para_str: posicao -> str

    Converte uma posição numa string
    """
    return str((obter_pos_x(pos), obter_pos_y(pos)))


def obter_posicoes_adjacentes(pos):
    """
    obter_posicoes_adjacentes: posicao -> tuplo

    Obtém as posições adjacentes à posição dada segundo as regras de movimento
    """
    x, y = obter_pos_x(pos), obter_pos_y(pos)
    pos = (cria_posicao(x, y - 1),) if y - 1 >= 0 else ()
    pos += (cria_posicao(x + 1, y),) + (cria_posicao(x, y + 1),)
    return pos if x - 1 < 0 else pos + (cria_posicao(x - 1, y),)


def ordenar_posicoes(pos):
    """
    ordenar_posicoes: tuplo -> tuplo

    Ordena as posições pela ordem de leitura do prado
    """
    return tuple(sorted(pos, key=lambda x: (obter_pos_y(x), obter_pos_x(x))))


###############
# TAD Animal #
###############


def cria_animal(especie, reproducao, alimentacao):
    """
    cria_animal: str × int × int -> animal

    Cria um animal
    """
    if (
        not isinstance(especie, str)
        or not isinstance(reproducao, int)
        or not isinstance(alimentacao, int)
        or not especie.isalpha()
        or reproducao <= 0
        or alimentacao < 0
    ):
        raise ValueError("cria_animal: argumentos invalidos")
    return {
        "especie": especie,
        "reproducao": reproducao,
        "alimentacao": alimentacao,
        "idade": 0,
        "fome": 0,
    }


def cria_copia_animal(animal):
    """
    cria_copia_animal: animal -> animal

    Cria uma cópia do animal
    """
    return {
        "especie": animal["especie"],
        "reproducao": animal["reproducao"],
        "alimentacao": animal["alimentacao"],
        "idade": animal["idade"],
        "fome": animal["fome"],
    }


def obter_especie(animal):
    """
    obter_especie: animal -> str

    Obtém a especie do animal
    """
    return animal["especie"]


def obter_freq_reproducao(animal):
    """
    obter_freq_reproducao: animal -> int

    Obtém a frequência de reprodução do animal
    """
    return animal["reproducao"]


def obter_freq_alimentacao(animal):
    """
    obter_freq_alimentacao: animal -> int

    Obtém a frequência de alimentação do animal
    """
    return animal["alimentacao"]


def obter_idade(animal):
    """
    obter_idade: animal -> int

    Obtém a idade do animal
    """
    return animal["idade"]


def obter_fome(animal):
    """
    obter_fome: animal -> int

    Obtém a fome do animal
    """
    return animal["fome"]


def aumenta_idade(animal):
    """
    aumenta_idade: animal -> animal

    Aumenta a idade do animal
    """
    animal["idade"] += 1
    return animal


def reset_idade(animal):
    """
    reset_idade: animal -> animal

    Dá reset da idade do animal
    """
    animal["idade"] = 0
    return animal


def aumenta_fome(animal):
    """
    aumenta_fome: animal -> animal

    Aumenta a fome do animal
    """
    if obter_freq_alimentacao(animal) > 0:
        animal["fome"] += 1
    return animal


def reset_fome(animal):
    """
    reset_fome: animal -> animal

    Dá reset da fome do animal
    """
    animal["fome"] = 0
    return animal


def eh_animal(animal):
    """
    eh_animal: universal -> booleano

    Verifica se um objeto é um animal
    """
    try:
        return (
            obter_idade(animal) >= 0
            and obter_fome(animal) >= 0
            and bool(
                cria_animal(
                    obter_especie(animal),
                    obter_freq_reproducao(animal),
                    obter_freq_alimentacao(animal),
                )
            )
        )
    except:
        return False


def eh_predador(animal):
    """
    eh_predador: universal -> booleano

    Verifica se um objeto é animal e predador
    """
    return eh_animal(animal) and obter_freq_alimentacao(animal) > 0


def eh_presa(animal):
    """
    eh_presa: universa -> booleano

    Verifica se um objeto é animal e presa
    """
    return eh_animal(animal) and obter_freq_alimentacao(animal) == 0


def animais_iguais(a1, a2):
    """
    animais_iguais: animal × animal -> booleano

    Verifica se dois animais são iguais
    """
    if eh_animal(a1):
        return a1 == a2
    return False


def animal_para_char(animal):
    """
    animal_para_char: animal -> str

    Converte um animal num char
    """
    return (
        obter_especie(animal)[0].lower()
        if eh_presa(animal)
        else obter_especie(animal)[0].upper()
    )


def animal_para_str(animal):
    """
    animal_para_str: animal -> str

    Converte um animal numa string
    """
    return (
        obter_especie(animal)
        + " ["
        + str(obter_idade(animal))
        + "/"
        + str(obter_freq_reproducao(animal))
        + (
            ";" + str(obter_fome(animal)) + "/" + str(obter_freq_alimentacao(animal))
            if eh_predador(animal)
            else ""
        )
        + "]"
    )


def eh_animal_fertil(animal):
    """
    eh_animal_fertil: animal -> booleano

    Verifica se um animal é fertil
    """
    return obter_idade(animal) >= obter_freq_reproducao(animal)


def eh_animal_faminto(animal):
    """
    eh_animal_faminto: animal -> booleano

    Verifica se um animal está faminto
    """
    return eh_predador(animal) and obter_fome(animal) >= obter_freq_alimentacao(animal)


def reproduz_animal(animal):
    """
    reproduz_animal: animal -> animal

    Reproduz um animal e dá reset da idade e fome
    """
    reset_idade(animal)
    novo_animal = cria_copia_animal(animal)
    reset_fome(novo_animal)
    return novo_animal


#############
# TAD Prado #
#############


def cria_prado(d, r, a, p):
    """
    cria_prado: posica × tuplo × tuplo × tuplo -> prado

    Cria um prado
    """
    if (
        not eh_posicao(d)
        or not isinstance(r, tuple)
        or not isinstance(a, tuple)
        or not isinstance(p, tuple)
        or len(a) != len(p)
        or ((obter_pos_x(d) - 1) * (obter_pos_y(d) - 1)) - len(r) - len(p) < 0
        or not all(eh_animal(animal) for animal in a)
        or not all(
            eh_posicao(pos)
            and 0 < obter_pos_x(pos) < obter_pos_x(d)
            and 0 < obter_pos_y(pos) < obter_pos_y(d)
            for pos in (r + p)
        )
    ):
        raise ValueError("cria_prado: argumentos invalidos")
    return {
        "dimensao": d,
        "rochedos": r,
        "animais": list(a),
        "posicoes": list(p),
    }


def cria_copia_prado(prado):
    """
    cria_copia_prado: prado -> prado

    Cria uma cópia do prado
    """
    return {
        "dimensao": prado["dimensao"],
        "rochedos": prado["rochedos"],
        "animais": tuple(prado["animais"]),
        "posicoes": tuple(prado["posicoes"]),
    }


def obter_tamanho_x(prado):
    """
    obter_tamanho_x: prado -> int

    Obtém o tamanho do prado em x
    """
    return obter_pos_x(prado["dimensao"]) + 1


def obter_tamanho_y(prado):
    """
    obter_tamanho_y: prado -> int

    Obtém o tamanho do prado em y
    """

    return obter_pos_y(prado["dimensao"]) + 1


def obter_numero_predadores(prado):
    """
    obter_numero_predadores: prado -> int

    Retorna o número de predadores no prado
    """
    return len(tuple(filter(eh_predador, prado["animais"])))


def obter_numero_presas(prado):
    """
    obter_numero_presas: prado -> int

    Retorna o número de presas no prado
    """
    return len(tuple(filter(eh_presa, prado["animais"])))


def obter_posicao_animais(prado):
    """
    obter_posicao_animais: prado -> tuplo

    Retorna as posições dos animais ordenadas pela ordem de leitura do prado
    """
    return ordenar_posicoes(prado["posicoes"])


def obter_animal(prado, pos):
    """
    obter_animal: prado × posicao -> animal

    Retorna o animal que está na posição pos
    """
    for i in range(len(prado["posicoes"])):
        if posicoes_iguais(prado["posicoes"][i], pos):
            return prado["animais"][i]


def eliminar_animal(prado, pos):
    """
    eliminar_animal: prado × posicao -> prado

    Elimina o animal que está na posição pos
    """
    counter = 0
    for i in range(len(prado["posicoes"])):
        if posicoes_iguais(prado["posicoes"][i], pos):
            break
        counter += 1
    prado["animais"].pop(i)
    prado["posicoes"].pop(i)
    return prado


def mover_animal(prado, p1, p2):
    """
    mover_animal: prado × posicao × posicao -> prado

    Move o animal para uma nova posição
    """
    for i in range(len(prado["posicoes"])):
        if posicoes_iguais(prado["posicoes"][i], p1):
            prado["posicoes"][i] = p2
            return prado


def inserir_animal(prado, animal, pos):
    """
    inserir_animal: prado × animal × posicao -> prado

    Insere um animal e a sua posição no prado
    """
    prado["animais"].append(animal)
    prado["posicoes"].append(pos)
    return prado


def eh_prado(prado):
    """
    eh_prado: prado -> booleano

    Verifica se o prado é válido
    """
    try:
        return bool(
            cria_prado(
                prado["dimensao"],
                prado["rochedos"],
                tuple(prado["animais"]),
                tuple(prado["posicoes"]),
            )
        )
    except:
        return False


def eh_posicao_animal(prado, pos):
    """
    eh_posicao_animal: prado × posicao -> booleano

    Verifica se a posição é um animal
    """
    for i in range(len(prado["posicoes"])):
        if posicoes_iguais(prado["posicoes"][i], pos):
            return True
    return False


def eh_posicao_obstaculo(prado, pos):
    """
    eh_posicao_obstaculo: prado × posicao -> booleano

    Verifica se a posição é um obstáculo (rochedo ou montanha)
    """
    for i in prado["rochedos"]:
        if posicoes_iguais(i, pos):
            return True
    return (
        obter_pos_x(pos) == 0
        or obter_pos_y(pos) == 0
        or obter_pos_x(pos) == obter_tamanho_x(prado) - 1
        or obter_pos_y(pos) == obter_tamanho_y(prado) - 1
    )


def eh_posicao_livre(prado, pos):
    """
    eh_posicao_livre: prado × posicao -> booleano

    Verifica se a posição está livre
    """
    return not (eh_posicao_obstaculo(prado, pos) or eh_posicao_animal(prado, pos))


def prados_iguais(p1, p2):
    """
    prados_iguais: prado × prado -> booleano

    Verifica se dois prados são iguais
    """
    return (
        eh_prado(p1)
        and eh_prado(p2)
        and obter_tamanho_x(p1) == obter_tamanho_x(p2)
        and obter_tamanho_y(p1) == obter_tamanho_y(p2)
        and ordenar_posicoes(p1["rochedos"]) == ordenar_posicoes(p2["rochedos"])
        and obter_posicao_animais(p1) == obter_posicao_animais(p2)
        and list(map(lambda i: obter_animal(p1, i), obter_posicao_animais(p1)))
        == list(map(lambda i: obter_animal(p2, i), obter_posicao_animais(p2)))
    )


def prado_para_str(prado):
    """
    prado_para_str: prado -> str

    Converte um prado para uma string
    """
    topos = "".join(["|\n+", "-" * (obter_tamanho_x(prado) - 2), "+\n|"])
    centro = "|\n|".join(
        map(
            lambda y: "".join(
                map(
                    lambda x: animal_para_char(obter_animal(prado, cria_posicao(x, y)))
                    if eh_posicao_animal(prado, cria_posicao(x, y))
                    else "@"
                    if eh_posicao_obstaculo(prado, cria_posicao(x, y))
                    else ".",
                    range(1, obter_tamanho_x(prado) - 1),
                )
            ),
            range(1, obter_tamanho_y(prado) - 1),
        )
    )
    return "".join([topos[2:], centro, topos[:-2]])


def obter_valor_numerico(prado, pos):
    """
    obter_valor_numerico: prado × posicao -> int

    Retorna o valor numérico de uma posição segundo a ordem de leitura do prado
    """
    return obter_tamanho_x(prado) * obter_pos_y(pos) + obter_pos_x(pos)


def obter_movimento(prado, pos):
    """
    obter_movimento: prado × posicao -> lista de posicoes

    Retorna uma lista com as posições que o animal se pode mover
    """
    pos_adj = list(
        filter(
            lambda i: not eh_posicao_obstaculo(prado, i), obter_posicoes_adjacentes(pos)
        )
    )
    if eh_predador(obter_animal(prado, pos)):
        presas = list(
            filter(
                lambda i: eh_posicao_animal(prado, i)
                and eh_presa(obter_animal(prado, i)),
                pos_adj,
            )
        )
        if len(presas) > 0:
            return presas[obter_valor_numerico(prado, pos) % len(presas)]
    pos_adj = list(filter(lambda i: not eh_posicao_animal(prado, i), pos_adj))
    return pos_adj[obter_valor_numerico(prado, pos) % len(pos_adj)] if pos_adj else pos


######################
# Funções Adicionais #
######################


def geracao(prado):
    """
    geracao: prado -> int

    Gera uma nova geração do prado
    """
    aux = []
    for pos in obter_posicao_animais(prado):
        move = obter_movimento(prado, pos)
        if all([not posicoes_iguais(i, pos) for i in aux]):
            animal = obter_animal(prado, pos)
            aumenta_fome(animal), aumenta_idade(animal)
            if not posicoes_iguais(pos, move):
                if eh_predador(animal) and eh_posicao_animal(prado, move):
                    eliminar_animal(prado, move), mover_animal(prado, pos, move)
                    reset_fome(animal)
                    eh_animal_fertil(animal) and inserir_animal(
                        prado, reproduz_animal(obter_animal(prado, move)), pos
                    )
                else:
                    mover_animal(prado, pos, move)
                    if eh_animal_fertil(animal) and not posicoes_iguais(move, pos):
                        inserir_animal(
                            prado, reproduz_animal(obter_animal(prado, move)), pos
                        )
            aux.append(move)
        eh_animal_faminto(animal) and eliminar_animal(prado, move)
    return prado


def simula_ecossistema(file, geracoes, mode):
    """
    simula_ecossistema: str × int × str -> None

    Lê um ficheiro e gera uma simulação do ecossistema
    """
    with open(file, "r") as file:
        lines = [eval(line) for line in file]
    animais = [cria_animal(i[0], i[1], i[2]) for i in lines[2:]]
    prado = cria_prado(
        cria_posicao(lines[0][0], lines[0][1]),
        tuple(cria_posicao(p[0], p[1]) for p in lines[1]),
        tuple(animais),
        tuple(cria_posicao(i[3][0], i[3][1]) for i in lines[2:]),
    )
    predadores, presas = obter_numero_predadores(prado), obter_numero_presas(prado)
    print(
        f"Predadores: {predadores} vs Presas: {presas} (Gen. {0})",
    )
    print(prado_para_str(prado))
    if not mode:
        for i in range(geracoes):
            geracao(prado)
        print(
            f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. {geracoes})",
        )
        print(prado_para_str(prado))
    else:
        for i in range(geracoes):
            geracao(prado)
            if (
                obter_numero_predadores(prado) != predadores
                or obter_numero_presas(prado) != presas
            ):
                print(
                    f"Predadores: {obter_numero_predadores(prado)} vs Presas: {obter_numero_presas(prado)} (Gen. {i + 1})",
                )

                prado_str = str(prado_para_str(prado))
                print(prado_str)
                predadores, presas = (
                    obter_numero_predadores(prado),
                    obter_numero_presas(prado),
                )
    return (obter_numero_predadores(prado), obter_numero_presas(prado))
