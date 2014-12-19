class RestspecInstaller < Thor::Group
  include Thor::Actions

  argument :project

  class_option :api_prefix, :desc => "api prefix to use", :required => true

  def self.source_root
    Pathname.new(File.dirname(__FILE__)).join('../../../bin')
  end

  def create_project_dir
    empty_directory project
  end

  def copy_gemfile
    copy_file 'templates/Gemfile', "#{project}/Gemfile"
  end

  def create_spec_folders
    empty_directory "#{project}/spec"
    empty_directory "#{project}/spec/api"
    empty_directory "#{project}/spec/support"
  end

  def create_spec_helper
    template 'templates/spec_helper.rb', "#{project}/spec/spec_helper.rb"
  end

  def create_rspec_config
    template 'templates/restspec_config.rb', "#{project}/spec/api/restspec/restspec_config.rb"
  end

  def create_api_dsl_files
    create_file "#{project}/spec/api/restspec/api_endpoints.rb"
    create_file "#{project}/spec/api/restspec/api_schemas.rb"
    create_file "#{project}/spec/api/restspec/api_requirements.rb"
  end

  def create_support_files
    create_file "#{project}/spec/support/custom_matchers.rb"
    copy_file "templates/custom_macros.rb", "#{project}/spec/support/custom_macros.rb"
  end

  def install_gems
    inside(project) { run 'bundle install' }
  end
end
