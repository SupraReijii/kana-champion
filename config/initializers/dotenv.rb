if defined? Dotenv
  if ENV["RAILS_ENV"] == "production"
    Dotenv.load! "/home/devops/kana-champion/.env"
  else
    Dotenv.load! "./.env"
  end
end