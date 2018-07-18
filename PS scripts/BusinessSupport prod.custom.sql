Custom fields of ElastiCube BusinessSupport prod
debtrans.txt|soortdeb|Lookup([naw.txt],[soortdeb],[naw_nr],[naw_nr])
debtrans.txt|factuur_code|Lookup([factuur.txt],[batc_code],[fact_nr],[fact_nr])
debtrans.txt|factuur_soort|SubString([factuur_code],1,2)
debtrans.txt|factuur_jaar|Lookup([factuur_info],[factuur_jaar],[factuur_code],[factuur_code])
debtrans.txt|datum_peil|CASE WHEN [bron] = 'F' AND [beta_stuknr] = 999 AND [debtbedrag] > 0 THEN AddDays(CreateDate(GetYear([datum]),GetMonth([datum]),1),-1) ELSE AddDays(AddMonths(CreateDate(GetYear([datum]),GetMonth([datum]),1),1),-1) END 
debtrans.txt|afsc_nr|Lookup([debtafsc.txt],[afsc_nr],[debt_nr],[debt_nr])
debtrans.txt|transactie_soort|CASE WHEN [debtbedrag] > 0 THEN CASE WHEN [bron] = 'F' THEN 'Opboeking Factuur' WHEN [bron] = 'I' AND [beta_stuknr] = 999 THEN 'Opboeking Rente' WHEN [bron] = 'I' THEN 'Correctie Rente (debet)' WHEN [bron] IN ('C', 'R') AND [afsc_nr] LIKE 'RETO%' THEN 'Retour Factuur (debet)' WHEN [bron] = 'K' THEN 'Restitutie Factuur (debet)' WHEN [bron] = 'C' AND [afsc_nr] NOT LIKE 'RETO%' THEN 'Correctie Factuur (debet)' ELSE 'Onbekend (debet)' END WHEN [debtbedrag] < 0 THEN CASE WHEN [bron] = 'C' AND [afsc_nr] LIKE '"CREDT%' THEN 'Creditnota' WHEN [bron] = 'C' AND [afsc_nr] NOT LIKE '"CREDT%' THEN 'Correctie Factuur (credit)' WHEN [bron] NOT IN ('C', 'F', 'I', 'R') THEN 'Ontvangst Factuur' WHEN [bron] = 'I' AND [beta_stuknr] = 999 THEN 'Correctie Rente (credit)' WHEN [bron] = 'I' THEN 'Ontvangst Rente' ELSE 'Onbekend (credit)' END ELSE 'Nul Transactie' END 
debtrans.txt|jaarlagen_opboeking|CASE WHEN [bron] = 'F' AND [beta_stuknr] = 999 AND [debtbedrag] > 0 THEN [debtbedrag] ELSE 0 END
debtrans.txt|jaarlagen_afboeking|CASE WHEN [bron] = 'F' AND [beta_stuknr] = 999 AND [debtbedrag] > 0 THEN 0 WHEN [bron] = 'I' THEN 0 ELSE [debtbedrag] END
debtrans.txt|debiteur_naam|Lookup([naw.txt],[debiteur_naam],[naw_nr],[naw_nr])
debtrans.txt|debiteur_adres|Lookup([naw.txt],[debiteur_adres],[naw_nr],[naw_nr])
debtrans.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
debtrans.txt|rente_opboeking|CASE WHEN [bron] = 'I' AND [debtbedrag] > 0 AND [beta_stuknr] = 999 THEN [debtbedrag] ELSE 0 END
debtrans.txt|rente_afboeking|CASE WHEN [bron] = 'I' AND [debtbedrag] > 0 AND [beta_stuknr] = 999 THEN 0 WHEN [bron] = 'I' THEN [debtbedrag] ELSE 0 END
debtrans.txt|bron_omschrijving|Lookup([bron.txt],[omschrijving],[bron],[bron_code])
debtrans.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
debtrans.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
debtrans.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
debtrans.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
debtrans.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
debtrans.txt|cf_betaal_bedrag|[debtbedrag] * [cf_factor]
debtrans.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [datum] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
debtrans.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
debtrans.txt|SRDbedrag|[SRDfactor]*[debtbedrag]
debtrans.txt|debiteur_afsluitbaar|Lookup([naw.txt],[afsluitbaar],[naw_nr],[naw_nr])
debtrans.txt|betregel_pk|Concat([naw_nr],[valu_code_c])
debtrans.txt|debiteur_bc_account|Lookup([naw.txt],[bc_account],[naw_nr],[naw_nr])
debtrans.txt|debiteur_cbr_account|Lookup([naw.txt],[cbr_account],[naw_nr],[naw_nr])
debtrans.txt|debiteur_contact|Lookup([naw.txt],[cf_contact],[naw_nr],[naw_nr])
debtrans.txt|debiteur_opmerking|Lookup([naw.txt],[cf_opmerking],[naw_nr],[naw_nr])
debtrans.txt|debiteur_district|Lookup([naw.txt],[dist_code],[naw_nr],[naw_nr])
debtrans.txt|debiteur_wvb|Lookup([naw.txt],[cf_wvb],[naw_nr],[naw_nr])
debtrans.txt|betr_stuknr|Lookup([ct_betregel],[betr_stuknr],[betregel_pk],[betregel_pk])
naw.txt|debiteur_naam|CASE WHEN IsNull([vletter]) THEN [naam] ELSE Concat(Concat([naam], ' '), [vletter]) END
naw.txt|straat_naam|Lookup([straat.txt],[naam],[stra_code],[stra_code])
naw.txt|debiteur_adres|CASE WHEN IsNull([hnrchar]) AND IsNull([hnrnum]) THEN [straat_naam] WHEN IsNull([hnrchar]) THEN Concat(Concat([straat_naam], ' '), ToString([hnrnum])) WHEN IsNull([hnrnum]) THEN Concat(Concat([straat_naam], ' '), [hnrchar]) ELSE Concat(Concat(Concat([straat_naam], ' '), ToString([hnrnum])),[hnrchar]) END
naw.txt|cf_contact|Lookup([predikaten.txt],[contact],[naw_nr],[naw_nr])
naw.txt|cf_opmerking|Lookup([predikaten.txt],[opmerking],[naw_nr],[naw_nr])
naw.txt|bc_account|Lookup([maccn.txt],[omschrijving],[mktacc],[macc_code])
naw.txt|cbr_account|Lookup([maccn.txt],[omschrijving],[flag],[macc_code])
naw.txt|dist_code|Lookup([straat.txt],[dist_code],[stra_code],[stra_code])
naw.txt|cf_wvb|CASE WHEN IsNull(Lookup([valnaw.txt],[cf_wvb],[naw_nr],[naw_nr])) THEN 'Onbekend' ELSE Lookup([valnaw.txt],[cf_wvb],[naw_nr],[naw_nr]) END
telfax.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
telfax.txt|categorie2|CASE WHEN [faci_code] = 'FAX' THEN 'Fax' WHEN [faci_code] = 'TLG' THEN 'Telegram' ELSE 'Niet gedefinieerd' END
telfax.txt|categorie3|CASE WHEN [richting] = 'I' THEN 'Inkomend' WHEN [richting] = 'O' THEN 'Uitgaand' ELSE 'Niet gedefinieerd' END
telfax.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [datum] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
telfax.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
telfax.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
telfax.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
telfax.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
telfax.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
telfax.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
telfax.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
restitut.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
restitut.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [resdatum] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
restitut.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
restitut.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
restitut.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
restitut.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
restitut.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
restitut.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
restitut.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
prodverk.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
prodverk.txt|prod_categorie|Lookup([product.txt],[categorie],[prod_code],[prod_code])
prodverk.txt|prod_omschrijving|Lookup([product.txt],[omschr],[prod_code],[prod_code])
prodverk.txt|cf_shiftdat|Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])
prodverk.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
prodverk.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
prodverk.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
prodverk.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
prodverk.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
prodverk.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
prodverk.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
ovbetal.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
ovbetal.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
ovbetal.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
ovbetal.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
ovbetal.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
ovbetal.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
ovbetal.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
ovbetal.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [gesprekdat] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
ovbetal.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
product.txt|categorie|CASE WHEN IsNull([soort]) THEN 'Product overig' WHEN Upper([soort]) IN ('BB', 'GSM') THEN 'Toestel' WHEN Upper([soort]) = 'CARD' THEN CASE WHEN [prod_code] LIKE 'GSME%' THEN 'TMN voucher' WHEN [prod_code] LIKE 'GSMU%' THEN 'Beltegoed SIM' WHEN [prod_code] LIKE 'GSM%' THEN 'Beltegoed mobiel' WHEN [prod_code] LIKE 'PCC%' OR [prod_code] LIKE 'PPC%' THEN 'Calling card' ELSE Concat(Concat('CARD','_'),[prod_code]) END WHEN [soort] = 'VB' THEN 'Beltegoed virtueel' ELSE Concat(Concat([soort],'_'),[prod_code]) END
nota.txt|kve_omschrijving|CASE WHEN Upper([kve_code]) LIKE 'SIM%' THEN 'Simkaarten' WHEN IsNull(Lookup([tstltab.txt],[kve_code],[kve_code],[kve_code])) THEN Lookup([c_kvetarf],[omschr],[kve_code],[kve_code]) ELSE 'Toestel Postpaid' END
nota.txt|kve_omschrijving2|CASE WHEN [kve_omschrijving] IN ('Toestel Postpaid', 'Simkaarten') THEN Lookup([c_kvetarf],[omschr],[kve_code],[kve_code]) ELSE 'Nota GC3' END
nota.txt|valu_code_c|Lookup([c_kvetarf],[valu_code],[kve_code],[kve_code])
nota.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [datbet] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
nota.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
nota.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
nota.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
nota.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
nota.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
nota.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
nota.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
kasbewijs.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
kasbewijs.txt|categorie2|CASE WHEN [afdeling] IS NOT NULL OR [werk_persnr] IS NOT NULL THEN 'Intern' ELSE 'Extern' END
kasbewijs.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [acc_datum] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
kasbewijs.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
kasbewijs.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
kasbewijs.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
kasbewijs.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
kasbewijs.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
kasbewijs.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
filiaal.txt|verzg_code|CASE WHEN [filinaam] LIKE 'KAS%' THEN 'EXTERN' WHEN [fili_nr] IN (1,12) THEN 'TVP' WHEN [fili_nr] IN (2,9) THEN 'TLA' WHEN [fili_nr] IN (3,4) THEN 'TWS' WHEN [fili_nr] IN (5,8) THEN 'TVO' WHEN [fili_nr] IN (6,13) THEN 'TVW' WHEN [fili_nr] IN (11,14,18) THEN 'TVL' WHEN [fili_nr] IN (15,16) THEN 'TVN' ELSE 'INTERN' END
incibeta.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
incibeta.txt|inci_omschrijving|Lookup([incicode.txt],[inciomschr],[inci_code],[inci_code])
incibeta.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
incibeta.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
incibeta.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
incibeta.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
incibeta.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
incibeta.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
incibeta.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [incidatum] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
incibeta.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
divrest.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
divrest.txt|rest_omschrijving|Lookup([restoms.txt],[omschrijving],[rest_code],[rest_code])
divrest.txt|soort|Lookup([restoms.txt],[soort],[rest_code],[rest_code])
divrest.txt|cf_shiftdat|CASE WHEN IsNull(Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr])) THEN [datres] ELSE Lookup([betaling.txt],[shiftdat],[beta_stuknr],[beta_stuknr]) END
divrest.txt|cf_datum|(GetYear([cf_shiftdat]) * 10000) + (GetMonth([cf_shiftdat]) * 100) + GetDay([cf_shiftdat])
divrest.txt|cf_betaal_valuta|CASE WHEN [beta_stuknr] = 999 THEN [valu_code_c] ELSE Lookup([betaling.txt],[valu_code_c],[beta_stuknr],[beta_stuknr]) END
divrest.txt|cf_exchrate_pk|Concat(ToString([cf_datum]),[valu_code_c])
divrest.txt|cf_exchrate_pk2|Concat(ToString([cf_datum]),[cf_betaal_valuta])
divrest.txt|cf_factor|CASE WHEN [beta_stuknr] = 999 THEN 0 WHEN [valu_code_c] = [cf_betaal_valuta] THEN 1 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] IN ('SRD') THEN 0.001 WHEN [valu_code_c] IN ('SFL') AND [cf_betaal_valuta] NOT IN ('SRD') THEN CASE WHEN GetYear([cf_shiftdat]) > 2003 THEN Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]) * 0.001 ELSE (1/(Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk]))) END WHEN [valu_code_c] IN ('SRD') AND [cf_betaal_valuta] IN ('SFL') THEN 1000 WHEN [valu_code_c] IN ('SFL', 'SRD') THEN (1/Lookup([c_exchange_rate],[rate_sell],[cf_exchrate_pk2],[exchrate_pk])) WHEN [cf_betaal_valuta] IN ('SFL', 'SRD') THEN Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk2],[exchrate_pk]) / Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
divrest.txt|cf_betaal_bedrag|[bedrag] * [cf_factor]
divrest.txt|SRDfactor|CASE WHEN [valu_code_c] = 'SRD' THEN 1 WHEN [valu_code_c] = 'SFL' THEN 0.001 ELSE Lookup([c_exchange_rate],[rate_buy],[cf_exchrate_pk],[exchrate_pk]) END
betterm.txt|cf_total|[bedrag]+[rente]
cheque.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
cheque.txt|categorie2|CASE WHEN [naw_nr] IS NULL AND [bedrag] < 0 THEN 'Personeel' WHEN [naw_nr] IS NOT NULL AND [bedrag] > 0 THEN 'Klant' ELSE 'Niet gedefinieerd' END
crednota.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
betaling.txt|shiftdat|Lookup([kasshift.txt],[shiftdat],[kass_nr],[kass_nr])
betaling.txt|kas_nr|Lookup([kasshift.txt],[kas_nr],[kass_nr],[kass_nr])
betaling.txt|fili_nr|Lookup([kas.txt],[fili_nr],[kas_nr],[kas_nr])
betaling.txt|incasso_bron|CASE WHEN IsNull([kass_nr]) THEN CASE WHEN IsNull([bank_code]) THEN 'Onbekend' ELSE [bank_code] END ELSE Lookup([filiaal.txt],[filinaam],[fili_nr],[fili_nr]) END
betaling.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END 
betaling.txt|betwijze_c|CASE WHEN IsNull([kass_nr]) THEN 'Giro' WHEN IsNull([betwijze]) THEN 'Transactie mislukt' WHEN [betwijze] = 'C' THEN 'Cheque' WHEN [betwijze] = 'K' THEN 'Kontant' WHEN [betwijze] = 'P' THEN 'POS' WHEN [betwijze] = 'S' THEN 'Storting' ELSE [betwijze] END
betaling.txt|incasso_wijze|CASE WHEN IsNull([kass_nr]) THEN 'Bank' ELSE 'Kas' END 
betaling.txt|cf_exchrate_pk|Concat(ToString([cf_shiftdat]),[valu_code_c])
betaling.txt|cf_shiftdat|(GetYear([shiftdat]) * 10000) + (GetMonth([shiftdat]) * 100) + GetDay([shiftdat])
afslfac.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
abonnrs.txt|ceng_omschrijving|Lookup([cengeb.txt],[omschr],[ceng_code],[ceng_code])
abonnrs.txt|verzg_code|Lookup([cengeb.txt],[verzg_code],[ceng_code],[ceng_code])
aansluit.txt|cf_status_omschrijving|Lookup([aansstat.txt],[omschrijving],[stat_code],[stat_code])
restoms.txt|categorie2|CASE WHEN [soort] = 'DA' THEN 'B&C' ELSE 'Kas' END
ifx_users.txt|groupname_c|CASE WHEN [groupname] = 'tvla' THEN 'TLA' WHEN [groupname] = 'nrd' THEN 'TVN' ELSE Upper([groupname]) END
ifx_users.txt|groupname_c2|CASE WHEN Right([username],4) = 'tvla' THEN 'TLA' ELSE Upper(Right([username],3)) END
ifx_users.txt|verzg_code|CASE WHEN NOT IsNull(Lookup([verzgeb.txt], [verzg_code],[groupname_c],[verzg_code])) THEN [groupname_c] WHEN NOT IsNull(Lookup([verzgeb.txt], [verzg_code], [groupname_c2], [verzg_code])) THEN [groupname_c2] ELSE [username] END
rekening.txt|c_valu_code|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
valnaw.txt|cf_wvb|CASE WHEN IsNull([bank_code]) THEN 'Kas' WHEN IsNull([bankreknr]) THEN 'Kas' ELSE 'Bank' END
hopref.txt|debiteur_naam|Lookup([naw.txt],[debiteur_naam],[naw_nr],[naw_nr])
factstat.txt|cf_enddatum|CreateDate(ToInt(Left([enddatum],4)),ToInt(SubString([enddatum],6,2)),ToInt(SubString([enddatum],9,2)))
betregel.txt|valu_code_c|CASE WHEN [valu_code] = 'SR$' THEN 'SRD' ELSE [valu_code] END
aanvragen.txt|aanvraag_soort|CASE WHEN IsNull([srt_aanvcd]) THEN 'Geen Info(leeg)' WHEN IsNull(Lookup([srtaanvr.txt],[omschr],[srt_aanvcd],[srt_aanvcd])) THEN Concat(Concat('Geen info(',[srt_aanvcd]),')') ELSE Lookup([srtaanvr.txt],[omschr],[srt_aanvcd],[srt_aanvcd]) END
aanvragen.txt|aanvraag_dienst|CASE WHEN IsNull([dien_code]) THEN 'Geen Info(leeg)' WHEN IsNull(Lookup([dienst.txt],[omschr],[dien_code],[dien_code])) THEN Concat(Concat('Geen Info(',[dien_code]),')') ELSE Lookup([dienst.txt],[omschr],[dien_code],[dien_code]) END
aanvragen.txt|userid_filler|CASE WHEN IsNull([userid]) THEN 'Geen Verzgeb' WHEN NOT IsNull(ToInt([userid])) THEN CASE WHEN IsNull(Lookup([ifx_users.txt],[groupname_c2],[userid],[userid])) THEN 'Geen Verzgeb' ELSE Lookup([ifx_users.txt],[verzg_code],[userid],[userid]) END ELSE CASE WHEN IsNull(Lookup([ifx_users.txt],[groupname_c2],[userid],[username])) THEN CASE WHEN [userid] LIKE '%dvd' THEN 'MD' WHEN [userid] LIKE '%hvn' THEN 'TVP' WHEN [userid] LIKE '%imd' THEN 'IMD' WHEN [userid] LIKE '%md' THEN 'MD' WHEN [userid] LIKE '%nrd' THEN 'TVN' WHEN [userid] LIKE '%tvla' THEN 'TLA' ELSE Upper(Right([userid],3)) END ELSE Lookup([ifx_users.txt],[verzg_code],[userid],[username]) END END
aanvragen.txt|aanvraag_tijd|CASE WHEN IsNull([aanvrgtyd]) THEN 'Geen Tijd' WHEN IsNull(ToInt(SubString([aanvrgtyd],1,2))) THEN 'Geen Tijd' ELSE CASE WHEN ToInt(SubString([aanvrgtyd],1,2)) < 12 THEN '''s Morgens' WHEN ToInt(SubString([aanvrgtyd],1,2)) > 17 THEN '''s Avonds' ELSE '''s Middags' END END
aanvragen.txt|aanvraag_verzgeb|CASE WHEN IsNull(Lookup([verzgeb.txt],[verzg_code],[userid_filler],[verzg_code])) THEN 'Geen Verzgeb' ELSE [userid_filler] END
subaanv.txt|subaanv_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([deel_volgnr]))
subaanv.txt|aanvraag_soort|CASE WHEN IsNull(Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr])) THEN 'Geen Soort' ELSE Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_dienst|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[aanvraag_dienst],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_userid|Lookup([aanvragen.txt],[userid],[aanv_nr],[aanv_nr])
subaanv.txt|aanvraag_tijd|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Tijd' ELSE Lookup([aanvragen.txt],[aanvraag_tijd],[aanv_nr],[aanv_nr]) END
subaanv.txt|aans_nr_filler|CASE WHEN aans_nr LIKE 'ADSL%' THEN SubString(aans_nr,5) ELSE aans_nr END
subaanv.txt|dien_code|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[dien_code],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_verzgeb|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Verzgeb' ELSE Lookup([aanvragen.txt],[aanvraag_verzgeb],[aanv_nr],[aanv_nr]) END
subaanv.txt|abonnr_cengeb|CASE WHEN IsNull(Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr_filler],[abon_nr])) THEN 'Geen Cengeb' ELSE Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr_filler],[abon_nr]) END
subaanv.txt|abonnr_verzgeb|CASE WHEN [abonnr_cengeb] = 'Geen Cengeb' THEN 'Geen Verzgeb' ELSE Lookup([abonnrs.txt],[verzg_code],[aans_nr_filler],[abon_nr]) END
subaanv.txt|bestemd_voor|CASE WHEN [aanvraag_verzgeb] = 'Geen Verzgeb' THEN 'Geen Verzgeb' WHEN [abonnr_verzgeb] = 'Geen Verzgeb' THEN 'Eigen Verzgeb' WHEN [aanvraag_verzgeb] = [abonnr_verzgeb] THEN 'Eigen Verzgeb' ELSE 'Ander Verzgeb' END
subaanv.txt|aanvraag_datum|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN CreateDate(ToInt(Left(ToString([aanv_nr]),4)),1,1) ELSE Lookup([aanvragen.txt],[aanvrgdat],[aanv_nr],[aanv_nr]) END
subaanv.txt|wo_datumaf|CASE WHEN [dien_code] IN ('ADSL','DOMEIN', 'GPON', 'INT', 'LAS', 'LVS', 'P2P', 'WIRE') THEN Lookup([aanvraag_tbpm_status],[datwoaf],[aanv_nr],[aanv_nr]) ELSE Lookup([wrkorder.txt],[datwoaf],[subaanv_pk],[wrkorder_pk]) END
subaanv.txt|aanvraag_status|CASE WHEN IsNull(Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr])) THEN 'Geen Status' ELSE Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr]) END
subaanv.txt|afmelding_duur|CASE WHEN [aanvraag_status] IN ('Gerealiseerd') THEN CASE WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 0 THEN '1 dag' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 7 THEN '1 week' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 30 THEN '30 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 60 THEN '60 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 90 THEN '90 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 120 THEN '120 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 365 THEN '1 jaar' ELSE '> 1 jaar' END ELSE [aanvraag_status] END
subaanv.txt|aanvraag_duur|CASE WHEN [aanvraag_status] IN ('Geen Status', 'Gerealiseerd', 'Geen Workorder') THEN [aanvraag_status] WHEN DayDiff(Now(),[aanvraag_datum]) <= 0 THEN '1 dag' WHEN DayDiff(Now(),[aanvraag_datum]) <= 7 THEN '1 week' WHEN DayDiff(Now(),[aanvraag_datum]) <= 30 THEN '30 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 60 THEN '60 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 90 THEN '90 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 120 THEN '120 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 365 THEN '1 jaar' ELSE '> 1 jaar' END
wrkorder.txt|wrkorder_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([deel_volgnr]))
wrkorder.txt|wrkorder_status|CASE WHEN IsNull([datwoaf]) THEN 'Openstaand' ELSE 'Gerealiseerd' END
gbaanvr.txt|gbaanvr_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([volg_nr]))
gbaanvr.txt|aanvraag_soort|CASE WHEN IsNull(Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr])) THEN 'Geen Soort' ELSE Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|aanvraag_dienst|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[aanvraag_dienst],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|aanvraag_verzgeb|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Verzgeb' ELSE Lookup([aanvragen.txt],[aanvraag_verzgeb],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|wo_datumaf|Lookup([wrkorder.txt],[datwoaf],[gbaanvr_pk],[wrkorder_pk])
gbaanvr.txt|aanvraag_status|CASE WHEN IsNull(Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr])) THEN 'Geen Status' ELSE Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|aanvraag_userid|Lookup([aanvragen.txt],[userid],[aanv_nr],[aanv_nr])
gbaanvr.txt|aanvraag_tijd|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Tijd' ELSE Lookup([aanvragen.txt],[aanvraag_tijd],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|abonnr_cengeb|CASE WHEN IsNull(Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr],[abon_nr])) THEN 'Geen Cengeb' ELSE Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr],[abon_nr]) END
gbaanvr.txt|abonnr_verzgeb|CASE WHEN [abonnr_cengeb] = 'Geen Cengeb' THEN 'Geen Verzgeb' ELSE Lookup([abonnrs.txt],[verzg_code],[aans_nr],[abon_nr]) END
gbaanvr.txt|bestemd_voor|CASE WHEN [aanvraag_verzgeb] = 'Geen Verzgeb' THEN 'Geen Verzgeb' WHEN [abonnr_verzgeb] = 'Geen Verzgeb' THEN 'Eigen Verzgeb' WHEN [aanvraag_verzgeb] = [abonnr_verzgeb] THEN 'Eigen Verzgeb' ELSE 'Ander Verzgeb' END
gbaanvr.txt|dien_code|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[dien_code],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|aanvraag_datum|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN CreateDate(ToInt(Left(ToString([aanv_nr]),4)),1,1) ELSE Lookup([aanvragen.txt],[aanvrgdat],[aanv_nr],[aanv_nr]) END
