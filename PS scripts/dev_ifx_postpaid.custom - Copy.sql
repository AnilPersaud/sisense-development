Custom fields of ElastiCube dev_ifx_postpaid
informix.tfif|faci_omschr|Lookup([informix.facil],[omschr],[faci_code],[faci_code])
informix.tfif|faci_category|Lookup([informix.facil],[category],[faci_code],[faci_code])
informix.tfif|wvi|CASE WHEN IsNull([bank_code]) AND IsNull([bankreknr]) THEN 'KAS' ELSE 'BANK' END 
informix.tfif|beschfac_pk|Concat([dien_code],[faci_code])
informix.tfif|reke_naam|Lookup([informix.beschfac],[reke_naam],[beschfac_pk],[beschfac_pk])
informix.tfif|factuur_opboeking|Lookup([informix.debtrans_c],[datum],[fact_nr],[fact_nr])
informix.tfif|factuur_jaar|Lookup([informix.debtrans_c],[factuur_jaar],[fact_nr],[fact_nr])
informix.tfif|dien_omschr|Lookup([informix.dienst],[omschr],[dien_code],[dien_code])
informix.tfif|reke_nr|Lookup([informix.beschfac],[reke_nr],[beschfac_pk],[beschfac_pk])
informix.tfif|factuur_soort|Lookup([informix.debtrans_c],[factuur_soort],[fact_nr],[fact_nr])
informix.tfif|factuur_code|Lookup([informix.debtrans_c],[factuur_code],[fact_nr],[fact_nr])
informix.tfif|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
informix.tfnf|faci_omschr|Lookup([informix.facil],[omschr],[faci_code],[faci_code])
informix.tfnf|faci_category|Lookup([informix.facil],[category],[faci_code],[faci_code])
informix.tfnf|wvi|CASE WHEN IsNull([bank_code]) AND IsNull([bankreknr]) THEN 'KAS' ELSE 'BANK' END 
informix.tfnf|beschfac_pk|Concat([dien_code],[faci_code])
informix.tfnf|reke_naam|Lookup([informix.beschfac],[reke_naam],[beschfac_pk],[beschfac_pk])
informix.tfnf|factuur_opboeking|Lookup([informix.debtrans_c],[datum],[fact_nr],[fact_nr])
informix.tfnf|factuur_jaar|Lookup([informix.debtrans_c],[factuur_jaar],[fact_nr],[fact_nr])
informix.tfnf|dien_omschr|Lookup([informix.dienst],[omschr],[dien_code],[dien_code])
informix.tfnf|reke_nr|Lookup([informix.beschfac],[reke_nr],[beschfac_pk],[beschfac_pk])
informix.tfnf|factuur_soort|Lookup([informix.debtrans_c],[factuur_soort],[fact_nr],[fact_nr])
informix.tfnf|factuur_code|Lookup([informix.debtrans_c],[factuur_code],[fact_nr],[fact_nr])
informix.tfnf|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
informix.facil|category|CASE WHEN Upper([omschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([omschr]) LIKE '%VERK%' OR Upper([omschr]) LIKE '%VERB%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.beschfac|beschfac_pk|Concat([dien_code],[faci_code])
informix.beschfac|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.rekening|naam_c|ReplaceAll([naam],'"','')
informix.incicode|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.incicode|category|CASE WHEN Upper([inciomschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([inciomschr]) LIKE '%VERKE%' OR Upper([inciomschr]) LIKE '%VERBR%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.kvetarf|category|CASE WHEN Upper([omschr]) LIKE '%ABON%' THEN 'ABONNEMENT' WHEN Upper([omschr]) LIKE '%VERKE%' OR Upper([omschr]) LIKE '%VERBR%' THEN 'VERBRUIK' ELSE 'OVERIG' END
informix.kvetarf|reke_naam|Lookup([informix.rekening],[naam_c],[reke_nr],[reke_nr])
informix.debtrans_c|factuur_jaar|GetYear(AddMonths(datum,-1))
informix.debtrans_c|factuur_code|Lookup([informix.factuur],[batc_code],[fact_nr],[fact_nr])
informix.debtrans_c|factuur_soort|Left([factuur_code],2)
informix.tfof|wvi|CASE WHEN IsNull([bank_code]) AND IsNull([bankreknr]) THEN 'KAS' ELSE 'BANK' END 
informix.tfof|dien_omschr|Lookup([informix.dienst],[omschr],[dien_code],[dien_code])
informix.tfof|beschfac_pk|Concat([dien_code],[faci_code])
informix.tfof|beschfac_yn|Lookup([informix.beschfac],[reke_naam],[beschfac_pk],[beschfac_pk])
informix.tfof|faci_omschr|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[ki_omschr],[faci_code],[ki_code]) ELSE Lookup([informix.facil],[omschr],[faci_code],[faci_code]) END
informix.tfof|faci_category|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[category],[faci_code],[ki_code]) ELSE Lookup([informix.facil],[category],[faci_code],[faci_code]) END
informix.tfof|reke_naam|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[reke_naam],[faci_code],[ki_code]) ELSE Lookup([informix.beschfac],[reke_naam],[beschfac_pk],[beschfac_pk]) END
informix.tfof|reke_nr|CASE WHEN IsNull([beschfac_yn]) THEN Lookup([c_ki_codes],[reke_nr],[faci_code],[ki_code]) ELSE Lookup([informix.beschfac],[reke_nr],[beschfac_pk],[beschfac_pk]) END
informix.tfof|factuur_opboeking|Lookup([informix.debtrans_c],[datum],[fact_nr],[fact_nr])
informix.tfof|factuur_jaar|Lookup([informix.debtrans_c],[factuur_jaar],[fact_nr],[fact_nr])
informix.tfof|factuur_soort|Lookup([informix.debtrans_c],[factuur_soort],[fact_nr],[fact_nr])
informix.tfof|factuur_code|Lookup([informix.debtrans_c],[factuur_code],[fact_nr],[fact_nr])
informix.tfof|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
