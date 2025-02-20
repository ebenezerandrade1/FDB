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

-- Executar procedure
CALL atualizar_idade_obitos();
