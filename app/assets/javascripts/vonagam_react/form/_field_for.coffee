modulejs.define 'vr.form.fieldFor', ['vr.form.Field'], ( Field )->
  ( fields_common )->
    ( field_options )->
      Field $.extend {}, fields_common, field_options
