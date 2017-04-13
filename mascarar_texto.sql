CREATE OR REPLACE FUNCTION publico.fc_mascarar_string(character varying, character varying, character varying)
  RETURNS character varying AS
$BODY$
     DECLARE   
       p_texto           	character varying := $1;
       p_mascara                character varying := $2;
       p_atributmascara         character varying := $3;
       result                   character varying;
     BEGIN           
     --
	SELECT INTO result regexp_replace(p_texto
                   ,(SELECT '(' || REPLACE(regexp_replace(p_mascara, '[^[:alnum:]'||p_atributmascara||']', ')(', 'g'), p_atributmascara, '.') || ')')
                   ,(SELECT string_agg('\'||x+1, y[x]) FROM regexp_split_to_array(REPLACE(p_mascara, p_atributmascara, ''), '') y, generate_series(0,array_length(regexp_split_to_array(p_mascara, '[^[:alnum:]'||p_atributmascara||']'), 1)) x )
               );

	RETURN result;
     END
   $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION publico.fc_mascarar_string(character varying, character varying, character varying)
  OWNER TO postgres;