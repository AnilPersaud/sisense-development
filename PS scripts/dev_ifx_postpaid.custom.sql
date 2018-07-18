Custom fields of ElastiCube dev_ifx_postpaid
informix.facil|category|CASE WHEN Upper([omschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([omschr]) LIKE '%VERK%' OR Upper([omschr]) LIKE '%VERB%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.facil|faci_code_c|Trim([faci_code])
informix.naw|debiteurnaam|CASE WHEN IsNullOrEmpty(Trim([vletter])) THEN [naam] ELSE Concat(Concat(Trim([naam]),','),Trim([vletter])) END
informix.naw|straatnaam|Trim(Lookup([informix.straat],[naam],[stra_code],[stra_code]))
informix.naw|debiteuradres|CASE WHEN IsNull([hnrnum]) AND IsNull([hnrchar]) THEN [straatnaam] WHEN IsNull([hnrnum]) THEN Concat(Concat([straatnaam],' '),[hnrchar]) WHEN IsNull([hnrchar]) THEN Concat(Concat([straatnaam],' '),ToString([hnrnum])) ELSE Concat(Concat(Concat([straatnaam],' '),ToString([hnrnum])),[hnrchar]) END
informix.beschfac|beschfac_pk|Concat(Trim([dien_code]),Trim([faci_code]))
informix.beschfac|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.rekening|naam_c|ReplaceAll([naam],'"','')
informix.incicode|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.incicode|category|CASE WHEN Upper([inciomschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([inciomschr]) LIKE '%VERKE%' OR Upper([inciomschr]) LIKE '%VERBR%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.kvetarf|category|CASE WHEN Upper([omschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([omschr]) LIKE '%VERKE%' OR Upper([omschr]) LIKE '%VERBR%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.kvetarf|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.debtrans_c|factuur_jaar|GetYear(AddMonths(datum,-1))
informix.debtrans_c|factuur_code|Lookup([informix.factuur],[batc_code],[fact_nr],[fact_nr])
informix.debtrans_c|factuur_soort|Left([factuur_code],2)
informix.debtrans_c|factuur_maand|GetMonth(AddMonths(datum,-1))
informix.factuur_detail|wvi|CASE WHEN IsNull([bank_code]) AND IsNull([bankreknr]) THEN 'KAS' ELSE 'BANK' END 
informix.factuur_detail|dien_omschr|Lookup([informix.dienst],[omschr],[dien_code],[dien_code])
informix.factuur_detail|beschfac_pk|Concat(Trim([dien_code]),Trim([faci_code]))
informix.factuur_detail|beschfac_yn|Lookup([informix.beschfac],[arti_code],[beschfac_pk],[beschfac_pk])
informix.factuur_detail|faci_omschr|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[ki_omschr],[faci_code],[ki_code]) ELSE Lookup([informix.facil],[omschr],[faci_code_c],[faci_code_c]) END
informix.factuur_detail|faci_category|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[category],[faci_code],[ki_code]) ELSE Lookup([informix.facil],[category],[faci_code_c],[faci_code_c]) END
informix.factuur_detail|reke_naam|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[reke_naam],[faci_code],[ki_code]) ELSE Lookup([informix.beschfac],[reke_naam],[beschfac_pk],[beschfac_pk]) END
informix.factuur_detail|reke_nr|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[reke_nr],[faci_code],[ki_code]) ELSE Lookup([informix.beschfac],[reke_nr],[beschfac_pk],[beschfac_pk]) END
informix.factuur_detail|factuur_opboeking|Lookup([informix.debtrans_c],[datum],[fact_nr],[fact_nr])
informix.factuur_detail|factuur_jaar|Lookup([informix.debtrans_c],[factuur_jaar],[fact_nr],[fact_nr])
informix.factuur_detail|factuur_soort|Lookup([informix.debtrans_c],[factuur_soort],[fact_nr],[fact_nr])
informix.factuur_detail|factuur_code|Lookup([informix.debtrans_c],[factuur_code],[fact_nr],[fact_nr])
informix.factuur_detail|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
informix.factuur_detail|parent_naw_nr|Lookup([informix.nawrel],[parentnaw_nr],[naw_nr],[childnaw_nr])
informix.factuur_detail|debiteurnaam|Lookup([informix.naw],[debiteurnaam],[naw_nr],[naw_nr])
informix.factuur_detail|debiteuradres|Lookup([informix.naw],[debiteuradres],[naw_nr],[naw_nr])
informix.factuur_detail|hoofddebiteurnaam|CASE WHEN IsNull([parent_naw_nr]) THEN [debiteurnaam] ELSE Lookup([informix.naw],[debiteurnaam],[parent_naw_nr],[naw_nr]) END
informix.factuur_detail|hoofddebiteuradres|CASE WHEN IsNull([parent_naw_nr]) THEN [debiteuradres] ELSE Lookup([informix.naw],[debiteuradres],[parent_naw_nr],[naw_nr]) END
informix.factuur_detail|faci_code_c|Trim([faci_code])
informix.factuur_detail|debiteursoort|Lookup([informix.naw],[soortdeb],[naw_nr],[naw_nr])
informix.factuur_detail|hoofddebiteurnummer|CASE WHEN IsNull([parent_naw_nr]) THEN [naw_nr] ELSE [parent_naw_nr] END
informix.factuur_detail|factuur_maand|Lookup([informix.debtrans_c],[factuur_maand],[fact_nr],[fact_nr])
postpaid_traffic|factuur_code_c|CASE WHEN [factuur_code] IS NULL THEN 'UNBILLED' ELSE [factuur_code] END
postpaid_traffic|dien_code_a|Lookup([informix.aansluit],[dien_code],[aansluitnr],[aans_nr])
postpaid_traffic|dien_code_b|CASE WHEN [bestemnr_categorie] = 'INTL' THEN 'INTL' ELSE Lookup([informix.aansluit],[dien_code],[bestemnr],[aans_nr]) END
postpaid_traffic|dienst_a|Lookup([informix.aansluit],[dienst],[aansluitnr],[aans_nr])
postpaid_traffic|dienst_b|CASE WHEN [bestemnr_categorie] = 'INTL' THEN 'INTL' ELSE Lookup([informix.aansluit],[dienst],[bestemnr],[aans_nr]) END
postpaid_traffic|rayon|Lookup([informix.abonnrs],[rayon],[aansluitnr],[abon_nr])
postpaid_traffic|verzorgingsgebied|Lookup([informix.abonnrs],[verzorgingsgebied],[aansluitnr],[abon_nr])
postpaid_traffic|debiteurnummer|Lookup([informix.aansluit],[abonnaw_nr],[aansluitnr],[aans_nr])
postpaid_traffic|debiteurnaam|Lookup([informix.aansluit],[debiteurnaam],[aansluitnr],[aans_nr])
postpaid_traffic|debiteuradres|Lookup([informix.aansluit],[debiteuradres],[aansluitnr],[aans_nr])
informix.aansluit|dienst|Lookup([informix.dienst],[omschr],[dien_code],[dien_code])
informix.aansluit|debiteurnaam|Lookup([informix.naw],[debiteurnaam],[abonnaw_nr],[naw_nr])
informix.aansluit|debiteuradres|Lookup([informix.naw],[debiteuradres],[abonnaw_nr],[naw_nr])
informix.abonnrs|rayon|Lookup([informix.rayon],[omschr],[rayo_code],[rayo_code])
informix.abonnrs|verzorgingsgebied|Lookup([informix.cengeb],[verzorgingsgebied],[ceng_code],[ceng_code])
informix.cengeb|verzorgingsgebied|Lookup([informix.verzgeb],[omschr],[verzg_code],[verzg_code])
