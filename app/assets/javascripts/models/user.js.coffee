modulejs.define 'm.User', ['m.Base'], (Base)->
  class User extends Base
    attrs: [
      'id'
      'login'
      'role'
      'participated_games'
    ]
