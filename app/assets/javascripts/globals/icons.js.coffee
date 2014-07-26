modulejs.define 'icons',
  Game:
    fields:
      status: 'lightbulb-o'
      sides_count: 'male'
      time_mode: 'clock-o'
      chat_mode: 'envelope-o'
      powers_is_random: 'flag'
      is_public: 'eye'
      is_participated: 'gamepad'
      created_at: 'calendar'
      map: 'globe'
    values:
      time_mode:
        manual: 'wrench'
      chat_mode:
        only_public: 'comment-o'
        only_private: 'comment'
        rotation: 'refresh'
        both: 'comments-o'
      powers_is_random:
        true: 'hand-o-right'
        false: 'random'
      is_public:
        true: 0
        false: 'eye-slash'
      is_participated:
        true: 'check'
        false: 0
  Layout:
    actions:
      sign_up: 'pencil-square-o'
      sign_in: 'sign-in'
      sign_out: 'sign-out'
      rules: 'book'
      new_game: 'plus'
  get: ( icon, title = null )->
    React.DOM.i className: ('fa fa-'+icon), title: title