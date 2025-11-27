# -*- encoding: utf-8 -*-
# stub: gimei 1.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gimei".freeze
  s.version = "1.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["willnet".freeze]
  s.date = "1980-01-02"
  s.description = "random Japanese name and address generator".freeze
  s.email = ["netwillnet@gmail.com".freeze]
  s.homepage = "https://github.com/willnet/gimei".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "random Japanese name and address generator. support kanji, hiragana, and katakana".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
end
