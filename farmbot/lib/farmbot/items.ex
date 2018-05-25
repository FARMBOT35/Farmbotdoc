defmodule Farmbot.Item do 
	use Ecto.Schema
	import Ecto
	import Ecto.Changeset
	import Ecto.Query

	schema "farmbdd" do 	
		field :ide, :integer
		field :startdate, :utc_datetime
		field :enddate, :utc_datetime
	end


	 @fields ~w(ide startdate enddate)

  	def changeset(data, params \\ %{}) do
  	  data
  	  |> cast(params, @fields)
  	  |> validate_required([:ide])
 	end

end 



