@initial_positions =
  'Austria':
    'lands': ['vie', 'bud', 'tri', 'boh', 'gal', 'tyr']
    'forces': ['vie_mv', 'bud_mv', 'tri_xc']
  'England':
    'lands': ['lvp', 'lon', 'edi', 'wal', 'yor', 'cly']
    'forces': ['lvp_mv', 'lon_xc', 'edi_xc']
  'France':
    'lands': ['par', 'mar', 'bre', 'pic', 'bur', 'gas']
    'forces': ['par_mv', 'mar_mv', 'bre_xc']
  'Germany':
    'lands': ['ber', 'mun', 'kie', 'sil', 'pru', 'ruh']
    'forces': ['ber_mv', 'mun_mv', 'bal_xc']
  'Italy':
    'lands': ['rom', 'ven', 'nap', 'tus', 'apu', 'pie']
    'forces': ['rom_mv', 'ven_mv', 'nap_xc']
  'Russia':
    'lands': ['mos', 'war', 'sev', 'ukr', 'lvn', 'fin', 'stp']
    'forces': ['mos_mv', 'war_mv', 'bot_xc', 'sev_xc']
  'Turkey':
    'lands': ['con', 'smy', 'ank', 'arm', 'syr']
    'forces': ['con_mv', 'smy_mv', 'ank_xc']


orders =
  'Austria':
    'vie': #check if there is Austrian force
      type: 'hold'

    'bud':
      type: 'move'
      to: 'asd' #check if force can go there

    'tri':
      type: 'support'
      whom: 'bud'
      to: 'asd'
