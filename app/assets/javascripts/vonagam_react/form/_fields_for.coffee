modulejs.define 'vr.form.fieldsFor', ['vr.form.Field'], ( Field )->
  ( fields_common, fields_options )->
    fields = {}

    for attr, field_options of fields_options
      fields[attr] = Field $.extend attr: attr, fields_common, field_options

    fields
