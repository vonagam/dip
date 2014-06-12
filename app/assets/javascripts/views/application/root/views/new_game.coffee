class r.view.NewGame extends r.view.Base
  constructor: ( root )->
    super root, 'new_game'

    @form = @find 'form'
    @durations = @form.find '[name="game[time_mode]"]'
    @is_public = @form.find '.field.game_is_public'

    @durations.on 'change', =>
      choosen = @durations.filter ':checked'

      public_possible = choosen.val() != 'manual'

      @is_public.toggle public_possible

      unless public_possible
        @is_public.find('input').prop 'checked', false

      return

  is_enable: ->
    @root.user != undefined
