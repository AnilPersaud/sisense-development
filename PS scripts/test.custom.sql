Custom fields of ElastiCube test
aanvragen.txt|aanvraag_soort|CASE WHEN IsNull([srt_aanvcd]) THEN 'Geen Info(leeg)' WHEN IsNull(Lookup([srtaanvr.txt],[omschr],[srt_aanvcd],[srt_aanvcd])) THEN Concat(Concat('Geen info(',[srt_aanvcd]),')') ELSE Lookup([srtaanvr.txt],[omschr],[srt_aanvcd],[srt_aanvcd]) END
aanvragen.txt|aanvraag_dienst|CASE WHEN IsNull([dien_code]) THEN 'Geen Info(leeg)' WHEN IsNull(Lookup([dienst.txt],[omschr],[dien_code],[dien_code])) THEN Concat(Concat('Geen Info(',[dien_code]),')') ELSE Lookup([dienst.txt],[omschr],[dien_code],[dien_code]) END
aanvragen.txt|aanvraag_verzgeb|CASE WHEN IsNull(Lookup([verzgeb.txt],[verzg_code],[userid_filler],[verzg_code])) THEN 'Geen Verzgeb' ELSE [userid_filler] END
aanvragen.txt|userid_filler|CASE WHEN IsNull([userid]) THEN 'Geen Verzgeb' WHEN NOT IsNull(ToInt([userid])) THEN CASE WHEN IsNull(Lookup([ifx_users.txt],[groupname_c2],[userid],[userid])) THEN 'Geen Verzgeb' ELSE Lookup([ifx_users.txt],[verzg_code],[userid],[userid]) END ELSE CASE WHEN IsNull(Lookup([ifx_users.txt],[groupname_c2],[userid],[username])) THEN CASE WHEN [userid] LIKE '%dvd' THEN 'MD' WHEN [userid] LIKE '%hvn' THEN 'TVP' WHEN [userid] LIKE '%imd' THEN 'IMD' WHEN [userid] LIKE '%md' THEN 'MD' WHEN [userid] LIKE '%nrd' THEN 'TVN' WHEN [userid] LIKE '%tvla' THEN 'TLA' ELSE Upper(Right([userid],3)) END ELSE Lookup([ifx_users.txt],[verzg_code],[userid],[username]) END END
aanvragen.txt|aanvraag_tijd|CASE WHEN IsNull([aanvrgtyd]) THEN 'Geen Tijd' WHEN IsNull(ToInt(SubString([aanvrgtyd],1,2))) THEN 'Geen Tijd' ELSE CASE WHEN ToInt(SubString([aanvrgtyd],1,2)) < 12 THEN '''s Morgens' WHEN ToInt(SubString([aanvrgtyd],1,2)) > 17 THEN '''s Avonds' ELSE '''s Middags' END END
ifx_users.txt|groupname_c|CASE WHEN [groupname] = 'dvd' OR Lower([username]) LIKE '%dvd' THEN 'MD' WHEN [groupname] = 'hvn' OR Lower([username]) LIKE '%hvn' THEN 'TVP' WHEN [groupname] = 'imd' OR Lower([username]) LIKE '%imd' THEN 'IMD' WHEN [groupname] = 'md' OR Lower([username]) LIKE '%md' THEN 'MD' WHEN [groupname] = 'nrd' OR Lower([username]) LIKE '%nrd' THEN 'TVN' WHEN [groupname] = 'tvla' OR Lower([username]) LIKE '%tvla' THEN 'TLA' ELSE Upper([groupname]) END
ifx_users.txt|groupname_c2|CASE WHEN NOT IsNull(Lookup([verzgeb.txt],[verzg_code],[groupname_c],[verzg_code])) THEN [groupname_c] ELSE Upper(Right([username],3)) END
ifx_users.txt|verzg_code|CASE WHEN NOT IsNull(Lookup([verzgeb.txt], [verzg_code], [groupname_c2], [verzg_code])) THEN [groupname_c2] ELSE 'Geen Verzgeb' END
subaanv.txt|subaanv_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([deel_volgnr]))
subaanv.txt|aanvraag_soort|CASE WHEN IsNull(Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr])) THEN 'Geen Soort' ELSE Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_datum|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN CreateDate(ToInt(Left(ToString([aanv_nr]),4)),1,1) ELSE Lookup([aanvragen.txt],[aanvrgdat],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_dienst|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[aanvraag_dienst],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_verzgeb|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Verzgeb' ELSE Lookup([aanvragen.txt],[aanvraag_verzgeb],[aanv_nr],[aanv_nr]) END
subaanv.txt|wo_datumaf|CASE WHEN [dien_code] IN ('ADSL','DOMEIN', 'GPON', 'INT', 'LAS', 'LVS', 'P2P', 'WIRE') THEN Lookup([aanvraag_tbpm_status],[datwoaf],[aanv_nr],[aanv_nr]) ELSE Lookup([wrkorder.txt],[datwoaf],[subaanv_pk],[wrkorder_pk]) END
subaanv.txt|aanvraag_status|CASE WHEN IsNull(Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr])) THEN 'Geen Status' ELSE Lookup([aanvragen_status],[aanvraag_status],[aanv_nr],[aanv_nr]) END
subaanv.txt|aanvraag_userid|Lookup([aanvragen.txt],[userid],[aanv_nr],[aanv_nr])
subaanv.txt|aanvraag_tijd|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Tijd' ELSE Lookup([aanvragen.txt],[aanvraag_tijd],[aanv_nr],[aanv_nr]) END
subaanv.txt|abonnr_cengeb|CASE WHEN IsNull(Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr_filler],[abon_nr])) THEN 'Geen Cengeb' ELSE Lookup([abonnrs.txt],[ceng_omschrijving],[aans_nr_filler],[abon_nr]) END
subaanv.txt|abonnr_verzgeb|CASE WHEN [abonnr_cengeb] = 'Geen Cengeb' THEN 'Geen Verzgeb' ELSE Lookup([abonnrs.txt],[verzg_code],[aans_nr_filler],[abon_nr]) END
subaanv.txt|bestemd_voor|CASE WHEN [aanvraag_verzgeb] = 'Geen Verzgeb' THEN 'Geen Verzgeb' WHEN [abonnr_verzgeb] = 'Geen Verzgeb' THEN 'Eigen Verzgeb' WHEN [aanvraag_verzgeb] = [abonnr_verzgeb] THEN 'Eigen Verzgeb' ELSE 'Ander Verzgeb' END
subaanv.txt|aans_nr_filler|CASE WHEN aans_nr LIKE 'ADSL%' THEN SubString(aans_nr,5) ELSE aans_nr END
subaanv.txt|afmelding_duur|CASE WHEN [aanvraag_status] IN ('Gerealiseerd') THEN CASE WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 0 THEN '1 dag' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 7 THEN '1 week' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 30 THEN '30 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 60 THEN '60 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 90 THEN '90 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 120 THEN '120 dagen' WHEN DayDiff([wo_datumaf],[aanvraag_datum]) <= 365 THEN '1 jaar' ELSE '> 1 jaar' END ELSE [aanvraag_status] END
subaanv.txt|aanvraag_duur|CASE WHEN [aanvraag_status] IN ('Geen Status', 'Gerealiseerd', 'Geen Workorder') THEN [aanvraag_status] WHEN DayDiff(Now(),[aanvraag_datum]) <= 0 THEN '1 dag' WHEN DayDiff(Now(),[aanvraag_datum]) <= 7 THEN '1 week' WHEN DayDiff(Now(),[aanvraag_datum]) <= 30 THEN '30 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 60 THEN '60 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 90 THEN '90 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 120 THEN '120 dagen' WHEN DayDiff(Now(),[aanvraag_datum]) <= 365 THEN '1 jaar' ELSE '> 1 jaar' END
subaanv.txt|dien_code|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN 'Geen Dienst' ELSE Lookup([aanvragen.txt],[dien_code],[aanv_nr],[aanv_nr]) END
wrkorder.txt|wrkorder_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([deel_volgnr]))
wrkorder.txt|wrkorder_status|CASE WHEN IsNull([datwoaf]) THEN 'Openstaand' ELSE 'Gerealiseerd' END
gbaanvr.txt|gbaanvr_pk|Concat(Concat(ToString([aanv_nr]),'-'),ToString([volg_nr]))
gbaanvr.txt|aanvraag_soort|CASE WHEN IsNull(Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr])) THEN 'Geen Soort' ELSE Lookup([aanvragen.txt],[aanvraag_soort],[aanv_nr],[aanv_nr]) END
gbaanvr.txt|aanvraag_datum|CASE WHEN [aanvraag_soort] = 'Geen Soort' THEN CreateDate(ToInt(Left(ToString([aanv_nr]),4)),1,1) ELSE Lookup([aanvragen.txt],[aanvrgdat],[aanv_nr],[aanv_nr]) END
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
abonnrs.txt|ceng_omschrijving|Lookup([cengeb.txt],[omschr],[ceng_code],[ceng_code])
abonnrs.txt|verzg_code|Lookup([cengeb.txt],[verzg_code],[ceng_code],[ceng_code])
