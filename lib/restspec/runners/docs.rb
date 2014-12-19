class RestspecDocs < Thor::Group
  include Thor::Actions

  argument :file

  def generate_docs
    require 'restspec'
    require config_file
    require 'restspec/doc_generators/markdown'

    generator = Restspec::DocGenerators::Markdown.new
    File.write(file, generator.generate)
  end

  private

  def config_file
    Pathname.new(Dir.pwd).join('spec/api/restspec/restspec_config.rb')
  end
end
