CREATE OR REPLACE FUNCTION financeiro.fc_mascarar_fluxocaixa(character varying, character varying)
  RETURNS character varying AS
$BODY$
     DECLARE   
       p_texto           	character varying := $1;
       p_mascara                character varying := $2;
       result                character varying;
     BEGIN           
     --
     SELECT INTO result REPLACE(regexp_replace((SELECT RPAD(p_texto, (SELECT length(REPLACE(p_mascara, '.', ''))), '0'))
                   ,(SELECT '(' || REPLACE(REPLACE(p_mascara, '.', ')('), '#', '.') || ')')
                   ,(SELECT string_agg('\'||cast (x as character varying), '.') FROM generate_series(1,array_length(regexp_split_to_array('#.##.##.##', '\.'), 1)) x)
                   ), '.00','');
     RETURN result;
     END
   $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION financeiro.fc_mascarar_fluxocaixa(character varying, character varying)
  OWNER TO postgres;