modulejs.define 'vr.form.fieldsFor', ['vr.form.Field'], ( Field )->
  ( whom, fields_options )->
    fields = {}

    for attr, field_options of fields_options
      fields[attr] = Field $.extend attr: attr, { for: whom }, field_options

    fields
