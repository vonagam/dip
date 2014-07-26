modulejs.define 'm.User', ['m.Base'], (Base)->
  class extends Base
    model_name: 'user'
    attrs: [
      'id'
      'login'
      'role'
      'participated_games'
    ]
