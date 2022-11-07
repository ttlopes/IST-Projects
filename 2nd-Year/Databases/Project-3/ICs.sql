--IC_1

DROP TRIGGER IF EXISTS ic_1_trigger on tem_outra;

CREATE OR REPLACE FUNCTION ic_1() RETURNS trigger AS $$
BEGIN
    IF NEW.nome = NEW.super_categoria THEN
        RAISE EXCEPTION 'A categoria % não pode ser subcategoria de si própria', NEW.nome;
    END IF;

    RETURN NEW;

END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_1_trigger BEFORE INSERT ON tem_outra FOR EACH ROW EXECUTE PROCEDURE ic_1();

--IC_4

DROP TRIGGER IF EXISTS ic_4_trigger ON evento_reposicao;

CREATE OR REPLACE FUNCTION ic_4() RETURNS trigger AS $$
BEGIN
    IF NEW.unidades > (SELECT planograma.unidades FROM planograma WHERE planograma.ean = NEW.ean
                        AND planograma.nro = NEW.nro
                        AND planograma.num_serie = NEW.num_serie
                        AND planograma.fabricante = NEW.fabricante) THEN
        RAISE EXCEPTION 'Não pode adicionar mais unidades do que o planograma possui';
    END IF;

    RETURN NEW;

END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_4_trigger BEFORE INSERT ON evento_reposicao FOR EACH ROW EXECUTE PROCEDURE ic_4();

--IC_5

DROP TRIGGER IF EXISTS ic_5_trigger ON evento_reposicao;

CREATE OR REPLACE FUNCTION ic_5() RETURNS trigger AS $$
BEGIN
    IF NOT NEW.ean IN (SELECT ean FROM evento_reposicao
                        NATURAL JOIN planograma
                        NATURAL JOIN produto)  THEN
        RAISE EXCEPTION 'Não pode adicionar um produto cuja categoria não está no planograma';
    END IF;

    RETURN NEW;

END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_5_trigger BEFORE INSERT ON evento_reposicao FOR EACH ROW EXECUTE PROCEDURE ic_5();