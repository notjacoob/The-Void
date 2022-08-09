desc "Deploy server"
namespace :heroku do
    task :deploy do
        sh("heroku", "ps:scale", "web=0")
        sh("git", "push", "heroku", "HEAD:master")
        sh("heroku", "ps:scale", "web=1")
        sh("git", "push", "origin", "master")
    end
end
