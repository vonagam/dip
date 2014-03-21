@regions =
  'adr':
    full:'Adriatic Sea'  
    xc:['alb','apu','ven','tri','ion']
  'aeg':
    full:'Aegean Sea'  
    xc:['gre','bul_sc','con','smy','eas','ion']
  'alb':
    full:'Albania'   
    mv:['tri','gre','ser']
    xc:['adr','tri','gre','ion']
  'ank':
    full:'Ankara'   
    mv:['arm','con','smy']
    xc:['bla','arm','con']
  'apu':
    full:'Apulia'   
    mv:['ven','nap','rom']
    xc:['ven','adr','ion','nap']
  'arm':
    full:'Armenia'   
    mv:['smy','syr','ank','sev']
    xc:['ank','sev','bla']
  'bal':
    full:'Baltic Sea'  
    xc:['lvn','pru','ber','kie','den','swe','bot']
  'bar':
    full:'Barents Sea'  
    xc:['nwg','stp_nc','nor']
  'bel':
    full:'Belgium'   
    mv:['hol','pic','ruh','bur']
    xc:['eng','nth','hol','pic']
  'ber':
    full:'Berlin'   
    mv:['kie','pru','sil','mun']
    xc:['kie','bal','pru']
  'bla':
    full:'Black Sea'  
    xc:['rum','sev','arm','ank','con','bul_ec']
  'boh':
    full:'Bohemia'  
    mv:['mun','sil','gal','vie','tyr']
  'bot':
    full:'Gulf of Bothnia'  
    xc:['swe','fin','stp_sc','lvn','bal']
  'bre':
    full:'Brest'   
    mv:['pic','gas','par']
    xc:['mao','eng','pic','gas']
  'bud':
    full:'Budapest'  
    mv:['vie','gal','rum','ser','tri']
  'bul':
    full:'Bulgaria'    
    ec:['con','bla','rum']
    mv:['gre','con','ser','rum']
    sc:['gre','aeg','con']
  'bur':
    full:'Burgundy'  
    mv:['mar','gas','par','pic','bel','ruh','mun']
  'cly':
    full:'Clyde'   
    mv:['edi','lvp']
    xc:['edi','lvp','nao','nwg']
  'con':
    full:'Constantinople'   
    mv:['bul','ank','smy']
    xc:['bul_sc','bul_ec','bla','ank','smy','aeg']
  'den':
    full:'Denmark'   
    mv:['swe','kie']
    xc:['hel','nth','swe','bal','kie','ska']
  'eas':
    full:'Eastern Mediterranean'  
    xc:['syr','smy','aeg','ion']
  'edi':
    full:'Edinburgh'   
    mv:['lvp','yor','cly']
    xc:['nth','nwg','cly','yor']
  'eng':
    full:'English Channel'  
    xc:['mao','iri','wal','lon','nth','bel','pic','bre']
  'fin':
    full:'Finland'   
    mv:['swe','stp','nor']
    xc:['swe','stp_sc','bot']
  'gal':
    full:'Galicia'  
    mv:['war','ukr','rum','bud','vie','boh','sil']
  'gas':
    full:'Gascony'   
    mv:['par','bur','mar','spa','bre']
    xc:['spa_nc','mao','bre']
  'gre':
    full:'Greece'   
    mv:['bul','alb','ser']
    xc:['bul_sc','aeg','ion','alb']
  'hel':
    full:'Helgoland Bight'  
    xc:['nth','den','kie','hol']
  'hol':
    full:'Holland'   
    mv:['bel','kie','ruh']
    xc:['bel','nth','hel','kie']
  'ion':
    full:'Ionian Sea'  
    xc:['tun','tys','nap','apu','adr','alb','gre','aeg','eas']
  'iri':
    full:'Irish Sea'  
    xc:['nao','lvp','wal','eng','mao']
  'kie':
    full:'Kiel'   
    mv:['hol','den','ber','mun','ruh']
    xc:['hol','hel','den','bal','ber']
  'lon':
    full:'London'   
    mv:['yor','wal']
    xc:['yor','nth','eng','wal']
  'lvn':
    full:'Livonia'   
    mv:['pru','stp','mos','war']
    xc:['pru','bal','bot','stp_sc']
  'lvp':
    full:'Liverpool'   
    mv:['wal','edi','yor','cly']
    xc:['wal','iri','nao','cly']
  'lyo':
    full:'Gulf of Lyon'  
    xc:['spa_sc','mar','pie','tus','tys','wes']
  'mao':
    full:'Mid-Atlantic Ocean'  
    xc:['nao','iri','eng','bre','gas','spa_nc','por','spa_sc','naf','wes']
  'mar':
    full:'Marseilles'   
    mv:['spa','pie','gas','bur']
    xc:['spa_sc','lyo','pie']
  'mos':
    full:'Moscow'  
    mv:['stp','lvn','war','ukr','sev']
  'mun':
    full:'Munich'  
    mv:['bur','ruh','kie','ber','sil','boh','tyr']
  'naf':
    full:'North Africa'   
    mv:['tun']
    xc:['mao','wes','tun']
  'nao':
    full:'North Atlantic Ocean'  
    xc:['nwg','lvp','iri','mao','cly']
  'nap':
    full:'Naples'   
    mv:['rom','apu']
    xc:['rom','tys','ion','apu']
  'nor':
    full:'Norway'   
    mv:['fin','stp','swe']
    xc:['ska','nth','nwg','bar','stp_nc','swe']
  'nth':
    full:'North Sea'  
    xc:['yor','edi','nwg','nor','ska','den','hel','hol','bel','eng','lon']
  'nwg':
    full:'Norwegian Sea'  
    xc:['nao','bar','nor','nth','cly','edi']
  'par':
    full:'Paris'  
    mv:['bre','pic','bur','gas']
  'pic':
    full:'Picardy'   
    mv:['bur','par','bre','bel']
    xc:['bre','eng','bel']
  'pie':
    full:'Piedmont'   
    mv:['mar','tus','ven','tyr']
    xc:['mar','lyo','tus']
  'por':
    full:'Portugal'   
    mv:['spa']
    xc:['mao','spa_nc','spa_sc']
  'pru':
    full:'Prussia'    
    mv:['war','sil']
    mv:['ber','lvn']
    xc:['ber','bal','lvn']
  'rom':
    full:'Rome'   
    mv:['tus','nap','ven','apu']
    xc:['tus','tys','nap']
  'ruh':
    full:'Ruhr'  
    mv:['bur','bel','hol','kie','mun']
  'rum':
    full:'Rumania'   
    mv:['ser','bud','gal','ukr','sev','bul']
    xc:['sev','bla','bul_ec']
  'ser':
    full:'Serbia'  
    mv:['tri','bud','rum','bul','gre','alb']
  'sev':
    full:'Sevastopol'   
    mv:['ukr','mos','rum','arm']
    xc:['rum','bla','arm']
  'sil':
    full:'Silesia'  
    mv:['mun','ber','pru','war','gal','boh']
  'ska':
    full:'Skagerrak'  
    xc:['nth','nor','den','swe']
  'smy':
    full:'Smyrna'   
    mv:['syr','con','ank','arm']
    xc:['syr','eas','aeg','con']
  'spa':
    full:'Spain'    
    mv:['gas','por','mar']
    nc:['gas','mao','por']
    sc:['por','wes','lyo','mar','mao']
  'stp':
    full:'St Petersburg'    
    mv:['fin','lvn','nor','mos']
    nc:['bar','nor']
    sc:['fin','lvn','bot']
  'swe':
    full:'Sweden'   
    mv:['fin','den','nor']
    xc:['fin','bot','bal','den','ska','nor']
  'syr':
    full:'Syria'   
    mv:['smy','arm']
    xc:['eas','smy']
  'tri':
    full:'Trieste'   
    mv:['tyr','vie','bud','ser','alb','ven']
    xc:['alb','adr','ven']
  'tun':
    full:'Tunis'   
    mv:['naf']
    xc:['naf','wes','tys','ion']
  'tus':
    full:'Tuscany'   
    mv:['rom','pie','ven']
    xc:['rom','tys','lyo','pie']
  'tyr':
    full:'Tyrolia'  
    mv:['mun','boh','vie','tri','ven','pie']
  'tys':
    full:'Tyrrhenian Sea'  
    xc:['wes','lyo','tus','rom','nap','ion','tun']
  'ukr':
    full:'Ukraine'  
    mv:['rum','gal','war','mos','sev']
  'ven':
    full:'Venice'   
    mv:['tyr','tus','rom','pie','apu','tri']
    xc:['apu','adr','tri']
  'vie':
    full:'Vienna'  
    mv:['tyr','boh','gal','bud','tri']
  'wal':
    full:'Wales'   
    mv:['lvp','lon','yor']
    xc:['lvp','iri','eng','lon']
  'war':
    full:'Warsaw'  
    mv:['sil','pru','lvn','mos','ukr','gal']
  'wes':
    full:'Western Mediterranean'  
    xc:['mao','spa_sc','lyo','tys','tun','naf']
  'yor':
    full:'Yorkshire'   
    mv:['edi','lon','lvp','wal']
    xc:['edi','nth','lon']
