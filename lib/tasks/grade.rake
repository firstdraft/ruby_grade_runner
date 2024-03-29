require 'yaml'
require 'net/http'
require "json"
require "oj"
require "octokit"
require_relative "../ruby_grade_runner/runner"

# desc "Alias for \"grade:next\"."
# task grade: "grade:all" do
# end

  desc "Run all tests and submit a build report."
  task :grade do
    ARGV.each { |a| task a.to_sym do ; end }
    input_token = ARGV[1]
    file_token = nil

    sync_specs_with_source

    config_dir_name = find_or_create_config_dif
    config_file_name = "#{config_dir_name}/.ltici_apitoken.yml"

    student_config = {}
    student_config["submission_url"] = "https://grades.firstdraft.com"

    if File.file?(config_file_name)
      begin
        config = YAML.load_file(config_file_name)
      rescue
        abort "It looks like there's something wrong with your token in `#{config_dir_name}/.ltici_apitoken.yml`. Please delete that file and try `rails grade` again, and be sure to provide the access token for THIS project.".red
      end
      submission_url = config["submission_url"]
      file_token = config["personal_access_token"]
      student_config["submission_url"] = config["submission_url"]
    else
      submission_url = "https://grades.firstdraft.com"
    end
    if file_token.nil? && ENV.has_key?("LTICI_GITPOD_APITOKEN")
      input_token = ENV.fetch("LTICI_GITPOD_APITOKEN")
    end
    if !input_token.nil? && input_token != "" && input_token != " "
      token = input_token
      student_config["personal_access_token"] = input_token
      update_config_file(config_file_name, student_config)
    elsif input_token.nil? && !file_token.nil?
      token = file_token
    elsif input_token.nil? && file_token.nil?
      puts "Enter your access token for this project"
      new_personal_access_token = ""
      while new_personal_access_token == "" do
        print "> "
        new_personal_access_token = $stdin.gets.chomp.strip

        if new_personal_access_token!= "" && is_valid_token?(submission_url, new_personal_access_token) == false
          puts "Please enter valid token"
          new_personal_access_token = ""
        end

        if new_personal_access_token != ""
          student_config["personal_access_token"] = new_personal_access_token
          update_config_file(config_file_name, student_config)
          token = new_personal_access_token
        end
      end
    end
    
    if !token.nil? && token != "" && token != " "

      if is_valid_token?(submission_url, token) == false
        student_config["personal_access_token"] = nil
        update_config_file(config_file_name, student_config)
        puts "Your access token looked invalid, so we've reset it to be blank. Please re-run rails grade and, when asked, copy-paste your token carefully from the assignment page."
      else
        path = File.join(project_root, "/tmp/output/#{Time.now.to_i}.json")
        if File.file?("bin/rake")
          `bin/rake db:migrate`
        end
        `bundle exec rspec --order default -I spec/support -f JsonOutputFormatter --out #{path}`
        rspec_output_json = Oj.load(File.read(path))
        username = `git config user.name`
        reponame = Dir.pwd.to_s.split("/").last
        sha = `git rev-parse HEAD`.slice(0..7)

        RubyGradeRunner::Runner.new(submission_url, token, rspec_output_json, username, reponame, sha, "manual").process
      end
    else
      puts "We couldn't find your access token, so we couldn't record your grade. Please click on the assignment link again and run the rails grade ...  command shown there."
    end
  end

def sync_specs_with_source
  reponame = `basename -s .git \`git config --get remote.origin.url\``.chomp
  full_reponame = "appdev-projects/#{reponame}"

  repo_contents = Octokit.contents(full_reponame)
  remote_spec_folder = repo_contents.find { |git_object| git_object[:name] == 'spec' }
  remote_sha = remote_spec_folder[:sha]
  # Discard unstaged changes in spec folder
  `git checkout spec -q`
  `git clean spec -f -q`
  local_sha = `git ls-tree HEAD #{project_root.join('spec')}`.chomp.split[2]

  unless remote_sha == local_sha
    `git fetch upstream`
    # Remove local contents of spec folder
    `rm -rf spec/*`
    default_branch = `git remote show upstream | grep 'HEAD branch' | cut -d' ' -f5`.chomp
    # Overwrite local contents of spec folder with contents from upstream branch
    `git checkout upstream/#{default_branch} spec/ -q`
  end
end

def update_config_file(config_file_name, config)
  File.write(config_file_name, YAML.dump(config))
end

def find_or_create_config_dif
  config_dir_name = File.join(project_root, ".vscode")
  Dir.mkdir(config_dir_name) unless Dir.exist?(config_dir_name)
  config_dir_name
end

def is_valid_token?(root_url, token)
  return false unless token.is_a?(String) && token =~ /^[1-9A-Za-z][^OIl]{23}$/
  url = "#{root_url}/submissions/validate_token?token=#{token}"
  uri = URI.parse(url)
  req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  result = Oj.load(res.body)
  result["success"]
rescue => e
  return false
end

def project_root
  if defined?(Rails)
    return Rails.root
  end

  if defined?(Bundler)
    return Bundler.root
  end
  Dir.pwd
end
