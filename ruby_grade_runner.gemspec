# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: ruby_grade_runner 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby_grade_runner".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Raghu Betina".freeze, "Jelani Woods".freeze]
  s.date = "2022-10-17"
  s.description = "This gem runs your RSpec test suite and posts the JSON output to grades.firstdraft.com.".freeze
  s.email = ["raghu@firstdraft.com".freeze, "jelani@firstdraft.com".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/ruby_grade_runner.rb",
    "lib/ruby_grade_runner/runner.rb",
    "lib/tasks/grade.rake",
    "lib/tasks/ruby_grade_runner.rake",
    "ruby_grade_runner.gemspec",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/firstdraft/ruby_grade_runner".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A Ruby client for [firstdraft Grades](https://grades.firstdraft.com)".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<oj>.freeze, ["~> 3.10.6"])
    s.add_runtime_dependency(%q<octokit>.freeze, ["~> 5.0"])
    s.add_runtime_dependency(%q<faraday-retry>.freeze, ["~> 1.0.3"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<juwelier>.freeze, ["~> 2.1.0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, ["~> 0"])
    s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3"])
    s.add_development_dependency(%q<pry-doc>.freeze, ["~> 0"])
    s.add_development_dependency(%q<pry-remote>.freeze, ["~> 0"])
    s.add_development_dependency(%q<pry-rescue>.freeze, ["~> 1"])
    s.add_development_dependency(%q<pry-stack_explorer>.freeze, ["~> 0"])
  else
    s.add_dependency(%q<oj>.freeze, ["~> 3.10.6"])
    s.add_dependency(%q<octokit>.freeze, ["~> 5.0"])
    s.add_dependency(%q<faraday-retry>.freeze, ["~> 1.0.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<juwelier>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, ["~> 0"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3"])
    s.add_dependency(%q<pry-doc>.freeze, ["~> 0"])
    s.add_dependency(%q<pry-remote>.freeze, ["~> 0"])
    s.add_dependency(%q<pry-rescue>.freeze, ["~> 1"])
    s.add_dependency(%q<pry-stack_explorer>.freeze, ["~> 0"])
  end
end

