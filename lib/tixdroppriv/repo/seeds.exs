# Script for populating the database. You can run it as:
#
#     mix run lib/tixdroppriv/repo/seeds.exs
#
# It is also run when you use `mix ecto.setup` or `mix ecto.reset`
#

users = [
  %{email: "jane.doe@example.com", password: "password"},
  %{email: "john.smith@example.org", password: "password"}
]

for user <- users do
  {:ok, user} = Tixdrop.Accounts.create_user(user)
  Tixdrop.Accounts.confirm_user(user)
end
