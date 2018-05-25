defmodule Farmbot.Repo.Migrations.CreateFarmbdd do
  use Ecto.Migration

  def change do
	create table(:farmbdd)do
		add :ide, :integer
		add :startdate, :utc_datetime
		add :enddate, :utc_datetime
	end
  end
end
