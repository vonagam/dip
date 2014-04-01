ActionController::Base.view_paths = ActionView::FileSystemResolver.new(
  Rails.root.join("app/views"),
  ":prefix/:action{,/index}{.:formats,}{.:handlers,}"
)
