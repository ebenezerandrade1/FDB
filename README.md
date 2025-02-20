# 📊 Sistema de Informação de Mortalidade - Banco de Dados Relacional

## Introdução

Este projeto tem como objetivo a criação de um **banco de dados relacional** para armazenar e analisar informações sobre óbitos, utilizando dados extraídos do Sistema de Informação de Mortalidade (SIM). A implementação inclui **ETL**, **views**, **procedures**, **triggers** e diversas consultas SQL para explorar os dados.

## Modelo de Dados Relacional

O banco de dados foi estruturado seguindo os princípios da **modelagem relacional**, garantindo **integridade referencial** e **normalização**. O esquema contém as seguintes tabelas:

- **`obitos`** - Registros dos óbitos com detalhes como local, hora, causa da morte, entre outros.
- **`localizacoes`** - Municípios e estados onde os óbitos ocorreram.
- **`causas`** - Código CID e descrição das causas de morte.



## View

```sql
CREATE OR REPLACE VIEW vw_obitos_detalhado AS
SELECT 
    o.id_obito,
    o.data AS data_obito,
    o.data_nascimento,
    o.idade,
    o.sexo,
    rc.descricao AS raca_cor,
    c.codigo_cid,
    c.descricao AS causa_morte,
    l.municipio,
    l.estado,
    l.regiao,
    o.assist_med,
    o.necropsia
FROM public.obitos o
LEFT JOIN public.raca_cor rc ON o.id_raca_cor = rc.id_raca_cor
LEFT JOIN public.causas c ON o.id_causa_principal = c.id_causa
LEFT JOIN public.localizacoes l ON o.id_local = l.id_local;
```

## Procedure

```sql
CREATE OR REPLACE PROCEDURE atualizar_idade_obitos()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    nova_idade INTEGER;
BEGIN
    -- Percorre todos os registros onde a idade está nula
    FOR rec IN 
        SELECT id_obito, data_nascimento, data
        FROM public.obitos 
        WHERE idade IS NULL
    LOOP
        -- Verifica se a data de nascimento e a data do óbito não são nulas
        IF rec.data_nascimento IS NOT NULL AND rec.data IS NOT NULL THEN
            -- Calcula a idade com base no ano do óbito
            nova_idade := EXTRACT(YEAR FROM AGE(rec.data, rec.data_nascimento));

            -- Verifica se a idade calculada é válida
            IF nova_idade >= 0 THEN
                UPDATE public.obitos
                SET idade = nova_idade
                WHERE id_obito = rec.id_obito;

                RAISE NOTICE 'Idade do óbito ID % atualizada para %', rec.id_obito, nova_idade;
            ELSE
                RAISE WARNING 'Óbito ID % tem uma data de nascimento inválida!', rec.id_obito;
            END IF;
        ELSE
            RAISE WARNING 'Óbito ID % não tem data de nascimento ou data de óbito, idade não pode ser calculada!', rec.id_obito;
        END IF;
    END LOOP;

    RAISE NOTICE 'Atualização de idades concluída!';
END;
$$;
```

## Trigger



```sql
CREATE OR REPLACE FUNCTION fn_auditar_obitos()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Auditoria de INSERT
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.auditoria (operacao, id_obito, data_nova, idade_nova, sexo_novo, data_modificacao)
        VALUES ('INSERT', NEW.id_obito, NEW.data, NEW.idade, NEW.sexo, now());

        RETURN NEW;
    END IF;

    -- Auditoria de UPDATE
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO public.auditoria (operacao, id_obito, data_antiga, data_nova, idade_antiga, idade_nova, sexo_antigo, sexo_novo, data_modificacao)
        VALUES ('UPDATE', OLD.id_obito, OLD.data, NEW.data, OLD.idade, NEW.idade, OLD.sexo, NEW.sexo, now());

        RETURN NEW;
    END IF;

    -- Auditoria de DELETE
    IF TG_OP = 'DELETE' THEN
        INSERT INTO public.auditoria (operacao, id_obito, data_antiga, idade_antiga, sexo_antigo, data_modificacao)
        VALUES ('DELETE', OLD.id_obito, OLD.data, OLD.idade, OLD.sexo, now());

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;


CREATE TRIGGER trg_auditoria_obitos
AFTER INSERT OR UPDATE OR DELETE
ON public.obitos
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_obitos();
```

## Consultas SQL

## Consultas em álgebra relacional