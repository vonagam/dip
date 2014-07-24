modulejs.define 'vr.form.fieldsFor', ['vr.form.Field'], ( Field )->
  ( whom, fields_options )->
    fields = {}

    labels = fields_options._labels || {}

    for attr, field_options of fields_options
      fields_options = fields_options() if typeof fields_options == 'function'
      continue if /^_/.test(attr) || fields_options == null
      fields[attr] = Field $.extend 
        attr: attr 
        for: whom
        label: labels[attr] || attr
        field_options

    fields
