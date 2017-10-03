# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Microblog.Repo.insert!(%Microblog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Microblog.Repo
alias Microblog.Social.User
alias Microblog.Social.Message
alias Microblog.Social.Follow

Repo.delete_all(User)
Repo.insert!(%User{name: "Max Corwin", email: "maxcorwin@abc.com"})
Repo.insert!(%User{name: "Bob Smith", email: "bobsmith@abc.com"})

Repo.delete_all(Message)
Repo.delete_all(Follow)
Repo.delete_all(Session)

