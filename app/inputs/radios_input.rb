class RadiosInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input
    label_method, value_method = detect_collection_methods

    changed_input_html = input_html_options
    changed_input_html[:class].delete :input
    changed_input_html[:class].push :label

    @builder.send(
      'collection_radio_buttons',
      attribute_name, 
      collection, 
      value_method, 
      label_method,
      input_options, 
      changed_input_html, 
      &collection_block_for_nested_boolean_style
    )
  end
end
