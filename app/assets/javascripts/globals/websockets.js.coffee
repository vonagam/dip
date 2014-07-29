modulejs.define 'WebSockets', ->
  host = if /dip/.test(location.host) then 'ws://dip.kerweb.ru' else location.host
  new WebSocketRails host + '/websocket'
