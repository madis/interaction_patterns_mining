BootstrapNavbar.configure do |config|
  config.current_url_method = 'request.original_url'
  config.bootstrap_version = '3.1.1'
end

module BootstrapNavbar::Helpers
  def prepare_html(html)
    html.html_safe
  end
end

ActionView::Base.send :include, BootstrapNavbar::Helpers
