defmodule ZombieApocalypseSurvival.Repo do
  use Ecto.Repo,
    otp_app: :zombie_apocalypse_survival,
    adapter: Ecto.Adapters.Postgres
end
