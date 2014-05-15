@regions =
  'adr':
    type:'water'
    xc:['alb','apu','ven','tri','ion']
  'aeg':
    type:'water'
    xc:['bul_sc','gre','con','smy','eas','ion']
  'alb':
    type:'coast'
    xc:['tri','gre','ser','adr','ion']
  'ank':
    type:'coast'
    xc:['arm','con','smy','bla']
    supply: true
  'apu':
    type:'coast'
    xc:['ven','nap','rom','adr','ion']
  'arm':
    type:'coast'
    xc:['smy','syr','ank','sev','bla']
  'bal':
    type:'water'
    xc:['lvn','pru','ber','kie','den','swe','bot']
  'bar':
    type:'water'
    xc:['stp_nc','nwg','nor']
  'bel':
    type:'coast'
    xc:['hol','pic','ruh','bur','eng','nth']
    supply: true
  'ber':
    type:'coast'
    xc:['kie','pru','sil','mun','bal']
    supply: true
  'bla':
    type:'water'
    xc:['bul_ec','rum','sev','arm','ank','con']
  'boh':
    type:'land'
    xc:['mun','sil','gal','vie','tyr']
  'bot':
    type:'water'
    xc:['stp_sc','swe','fin','lvn','bal']
  'bre':
    type:'coast'
    xc:['pic','gas','par','mao','eng']
    supply: true
  'bud':
    type:'land'
    xc:['vie','gal','rum','ser','tri']
    supply: true
  'bul':
    type:'coast'
    xc:['con','bla','rum','gre','ser','aeg']
    ec:['con','bla','rum']
    sc:['gre','aeg','con']
    supply: true
  'bur':
    type:'land'
    xc:['mar','gas','par','pic','bel','ruh','mun']
  'cly':
    type:'coast'
    xc:['edi','liv','nao','nwg']
  'con':
    type:'coast'
    xc:['bul_sc','bul_ec','ank','smy','bla','aeg']
    supply: true
  'den':
    type:'coast'
    xc:['swe','kie','hel','nth','bal','ska']
    supply: true
  'eas':
    type:'water'
    xc:['syr','smy','aeg','ion']
  'edi':
    type:'coast'
    xc:['liv','yor','cly','nth','nwg']
    supply: true
  'eng':
    type:'water'
    xc:['mao','iri','wal','lon','nth','bel','pic','bre']
  'fin':
    type:'coast'
    xc:['stp_sc','swe','nor','bot']
  'gal':
    type:'land'
    xc:['war','ukr','rum','bud','vie','boh','sil']
  'gas':
    type:'coast'
    xc:['spa_nc','par','bur','mar','bre','mao']
  'gre':
    type:'coast'
    xc:['bul_sc','alb','ser','aeg','ion']
    supply: true
  'hel':
    type:'water'
    xc:['nth','den','kie','hol']
  'hol':
    type:'coast'
    xc:['bel','kie','ruh','nth','hel']
    supply: true
  'ion':
    type:'water'
    xc:['tun','tys','nap','apu','adr','alb','gre','aeg','eas']
  'iri':
    type:'water'
    xc:['nao','liv','wal','eng','mao']
  'kie':
    type:'coast'
    xc:['hol','den','ber','mun','ruh','hel','bal']
    supply: true
  'lon':
    type:'coast'
    xc:['yor','wal','nth','eng']
    supply: true
  'lvn':
    type:'coast'
    xc:['stp_sc','pru','mos','war','bal','bot']
  'liv':
    type:'coast'
    xc:['wal','edi','yor','cly','iri','nao']
    supply: true
  'lyo':
    type:'water'
    xc:['spa_sc','mar','pie','tus','tys','wes']
  'mao':
    type:'water'
    xc:['nao','iri','eng','bre','gas','spa_nc','por','spa_sc','naf','wes']
  'mar':
    type:'coast'
    xc:['spa_sc','pie','gas','bur','lyo']
    supply: true
  'mos':
    type:'land'
    xc:['stp','lvn','war','ukr','sev']
    supply: true
  'mun':
    type:'land'
    xc:['bur','ruh','kie','ber','sil','boh','tyr']
    supply: true
  'naf':
    type:'coast'
    xc:['tun','mao','wes']
  'nao':
    type:'water'
    xc:['nwg','liv','iri','mao','cly']
  'nap':
    type:'coast'
    xc:['rom','apu','tys','ion']
    supply: true
  'nor':
    type:'coast'
    xc:['stp_nc','fin','swe','ska','nth','nwg','bar']
    supply: true
  'nth':
    type:'water'
    xc:['yor','edi','nwg','nor','ska','den','hel','hol','bel','eng','lon']
  'nwg':
    type:'water'
    xc:['nao','bar','nor','nth','cly','edi']
  'par':
    type:'land'
    xc:['bre','pic','bur','gas']
    supply: true
  'pic':
    type:'coast'
    xc:['bur','par','bre','bel','eng']
  'pie':
    type:'coast'
    xc:['mar','tus','ven','tyr','lyo']
  'por':
    type:'coast'
    xc:['spa_nc','spa_sc','mao']
    supply: true
  'pru':
    type:'coast'
    xc:['war','sil','ber','lvn','bal']
  'rom':
    type:'coast'
    xc:['tus','nap','ven','apu','tys']
    supply: true
  'ruh':
    type:'land'
    xc:['bur','bel','hol','kie','mun']
  'rum':
    type:'coast'
    xc:['bul_ec','ser','bud','gal','ukr','sev','bla']
    supply: true
  'ser':
    type:'land'
    xc:['tri','bud','rum','bul','gre','alb']
    supply: true
  'sev':
    type:'coast'
    xc:['ukr','mos','rum','arm','bla']
    supply: true
  'sil':
    type:'land'
    xc:['mun','ber','pru','war','gal','boh']
  'ska':
    type:'water'
    xc:['nth','nor','den','swe']
  'smy':
    type:'coast'
    xc:['syr','con','ank','arm','eas','aeg']
    supply: true
  'spa':
    type:'coast'
    xc:['gas','por','wes','lyo','mar','mao']
    nc:['gas','mao','por']
    sc:['por','wes','lyo','mar','mao']
    supply: true
  'stp':
    type:'coast'
    xc:['fin','lvn','nor','mos','bot','bar']
    nc:['bar','nor']
    sc:['fin','lvn','bot']
    supply: true
  'swe':
    type:'coast'
    xc:['fin','den','nor','bot','bal','ska']
    supply: true
  'syr':
    type:'coast'
    xc:['smy','arm','eas']
  'tri':
    type:'coast'
    xc:['tyr','vie','bud','ser','alb','ven','adr']
    supply: true
  'tun':
    type:'coast'
    xc:['naf','wes','tys','ion']
    supply: true
  'tus':
    type:'coast'
    xc:['rom','pie','ven','tys','lyo']
  'tyr':
    type:'land'
    xc:['mun','boh','vie','tri','ven','pie']
  'tys':
    type:'water'
    xc:['wes','lyo','tus','rom','nap','ion','tun']
  'ukr':
    type:'land'
    xc:['rum','gal','war','mos','sev']
  'ven':
    type:'coast'
    xc:['tyr','tus','rom','pie','apu','tri','adr']
    supply: true
  'vie':
    type:'land'
    xc:['tyr','boh','gal','bud','tri']
    supply: true
  'wal':
    type:'coast'
    xc:['liv','lon','yor','iri','eng']
  'war':
    type:'land'
    xc:['sil','pru','lvn','mos','ukr','gal']
    supply: true
  'wes':
    type:'water'
    xc:['spa_sc','mao','lyo','tys','tun','naf']
  'yor':
    type:'coast'
    xc:['edi','lon','liv','wal','nth']
