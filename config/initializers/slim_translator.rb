require 'slim/translator'

class Slim::Translator
  def self.i18n_text(text)
    I18n.t!("views.#{text.sub(/\s*%\d+\s*/,'')}")
  rescue I18n::MissingTranslationData
    text
  end
end
