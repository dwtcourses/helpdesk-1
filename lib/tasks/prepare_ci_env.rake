namespace :helpdesk do
  desc "Prepare Continuous Integration environment"
  task :prepare_ci_env do
    ENV['SKIP_HELPDESK_INITIALIZER'] = 'true'
    adapter = ENV["CI_DB_ADAPTER"] || "sqlite3"
    database = ENV["CI_DB_DATABASE"] || ("sqlite3" == adapter ? "db/development.sqlite3" : "ci_helpdesk")

    configuration = {
      "test" => {
        "adapter" => adapter,
        "database" => database,
        "username" => ENV["CI_DB_USERNAME"],
        "password" => ENV["CI_DB_PASSWORD"],
        "host" => ENV["CI_DB_HOST"] || "localhost",
        "encoding" => ENV["CI_DB_ENCODING"] || "utf8",
        "pool" => (ENV["CI_DB_POOL"] || 5).to_int,
        "timeout" => (ENV["CI_DB_TIMEOUT"] || 5000).to_int
      }
    }

    filename = Rails.root.join("config/database.yml")

    File.open(filename, "w") do |f|
      f.write(configuration.to_yaml)
    end
  end
end