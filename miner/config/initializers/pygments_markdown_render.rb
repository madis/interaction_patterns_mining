# Override the default renderer to add syntax highlighting with Pygments.
class PygmentsHTML < Redcarpet::Render::HTML

  def block_code code, language
    Pygments.highlight code, :lexer => language
  end
end

MarkdownRails.configure do |config|

  # See https://github.com/vmg/redcarpet for options.
  markdown = Redcarpet::Markdown.new(PygmentsHTML,
    :tables => true,
    :fenced_code_blocks => true,
    :autolink => true
  )

  config.render do |markdown_source|
    markdown.render markdown_source
  end
end
