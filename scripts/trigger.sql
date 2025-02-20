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