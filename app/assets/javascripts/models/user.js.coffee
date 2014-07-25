modulejs.define 'm.User', ['m.Base'], (Base)->
  class extends Base
    name: 'user'
    attrs: [
      'id'
      'login'
      'role'
      'participated_games'
    ]
