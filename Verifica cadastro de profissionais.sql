CREATE OR REPLACE PROCEDURE        PRC_VERIFICA_CADASTRO_PRESTADOR_SEM_ESPECIALIDADE AS

	TEXTO CLOB;
	ENVIA NUMBER(10); 
BEGIN
	BEGIN

		TEXTO := '<html lang="pt-br">
				  <body>
				  <p>Os seguintes profissionais estão sem especialidade principal em seu cadastro ou não possuem especialidade cadastrada. Favor entrar em contato com o setor responsável pelo cadastro desses profissionais.</p>
				  <table>
				  <tr>
                    <th><p style="text-align: left;">Especialidade</p></th>
					<th><p style="text-align: left;">Código prestador</p></th>
                    <th><p style="text-align: left;">Prestador</p></th>
                    <th><p style="text-align: left;">Tipo pretador</p></th>
                    <th><p style="text-align: left;">Data cadastro</p></th>
				  </tr>';

		ENVIA := 0;


		FOR I IN (		  
                        SELECT CASE WHEN EM.COD_ESP IS NULL THEN 'SEM ESPECIALIDADE'
                               ELSE ES.ESPECIALIDADE END AS ESPECIALIDADE,
                               PR.CODIGO_PRESTADOR,
                               PR.NOME_PRESTADOR,
                               TP.TIPO_PRESTADOR AS TIPO_PRESTADOR,
                               TO_CHAR(PR.DATA_CADASTRO,'DD/MM/YYYY HH24:MI')||'h' AS DT_CADASTRO                              
                          FROM PRESTADORES_CONVENIADOS PR
                     LEFT JOIN ESPECIALIDADES_PRESTADORES EM       ON EM.CODIGO_PRESTADOR = PR.CODIGO_PRESTADOR
                     LEFT JOIN TIPOS_DE_PRESTADORES TP             ON TP.TIPO_PRESTADOR = PR.TIPO_PRESTADOR
                         WHERE ( EM.CODIGO_PRESTADOR NOT IN  (   SELECT ESM.CODIGO_PRESTADOR
                                                                   FROM ESPECIALIDADES_PRESTADORES ESM
                                                                  WHERE ESM.SN_ESPECIAL_PRINCIPAL = 'S'
                                                                            )
                            OR PR.CODIGO_PRESTADOR NOT IN (   SELECT ESM.CODIGO_PRESTADOR
                                                                FROM ESPECIALIDADES_PRESTADORES ESM
                                                               ) )
                           AND PR.TP_SITUACAO = 'ATIVO'
                        ORDER BY 2  )
        LOOP
                TEXTO := TEXTO||'<tr>
                                    <td>'||NVL(I.ESPECIALIDADE,'')||'</td>
                                    <td>'||NVL(I.CODIGO_PRESTADOR,'')||'</td>
                                    <td>'||NVL(I.NOME_PRESTADOR,'')||'</td>
                                    <td>'||NVL(I.TIPO_PRESTADOR,'')||'</td>
                                    <td>'||NVL(I.DT_CADASTRO,'')||'</td>
                                </tr>';
                ENVIA := 1;

        END LOOP;                

		IF ENVIA = 1 THEN
			DECLARE
				TYPE CARACTERES IS TABLE OF VARCHAR2(50);
				CARACTERES_ISO CARACTERES;
				CARACTERES_UTF CARACTERES;
			BEGIN   
				CARACTERES_ISO := CARACTERES('&Aacute;','&Eacute;','&Iacute;','&Oacute;','&Uacute;','&aacute;','&eacute;','&iacute;','&oacute;','&uacute;','&Acirc;','&Ecirc;','&Ocirc;',
											 '&acirc;','&ecirc;','&ocirc;','&Agrave;','&agrave;','&Uuml;','&uuml;','&Ccedil;','&ccedil;','&Atilde;','&Otilde;','&atilde;','&otilde;',
											 '&Ntilde;','&ntilde;');
				CARACTERES_UTF := CARACTERES('Á','É','Í','Ó','Ú','á','é','í','ó','ú','Â','Ê','Ô','â','ê','ô','À','à','Ü','ü','Ç','ç','Ã','Õ','ã','õ','Ñ','ñ');

				FOR ITEM IN CARACTERES_UTF.FIRST..CARACTERES_UTF.LAST
				LOOP
					TEXTO := REPLACE(TEXTO, CARACTERES_UTF(ITEM), CARACTERES_ISO(ITEM));
					--DBMS_OUTPUT.PUT_LINE(TEXTO);
				END LOOP;
			END;

		END IF;

	EXCEPTION WHEN OTHERS THEN
		--DBMS_OUTPUT.PUT_LINE(TEXTO);
		DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
	END;
END;