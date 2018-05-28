defmodule Farmbottest do
  alias Farmbot.Repo
  alias Farmbot.Item
  import Ecto.Changeset
  import Ecto.Query
#fonction pour ajouter un événement
  def add() do
    dt1 = %DateTime{year: 2018, month: 5, day: 26, zone_abbr: "UTC",hour: 17, minute: 0, second: 7, microsecond: {0, 0},utc_offset: 0, std_offset: 0, time_zone: "Etc/UTC"}
    farmbot_changeset = Item.changeset(%Item{}, %{ide: 7, startdate: dt1})
    {:ok, %Item{}=item}=Repo.insert(farmbot_changeset)
  end
#fonction qui supprime les événements antérieur à la date actuelle
  def sup() do
    actualdate = DateTime.utc_now()
    from(p in Item, where: p.startdate < ^actualdate) |> Repo.delete_all
  end

#fonction pour allumer et eteindre l Arduino
  def start(time) do
    IO.puts "l'Arduino va s'éteindre pendant  "
    IO.puts time
    IO.puts "secondes"
    :os.cmd('./hub-ctrl -h 0 -P 2 -p 1')
    :timer.sleep(time)
    :os.cmd('./hub-ctrl -h 0 -P 2 -p 0')
    
  end
#fonction parcourant la table et récupérant le temps avant le prochain événement
  def get1() do
    actualdate = DateTime.utc_now()     #recupere la date actuelle
    query = from p in Item,   #recupere toute les date de débuts d evenements plus tard que la date actuelle
          where: p.startdate > ^actualdate,
          select: p.startdate
    stream = Repo.stream(query)
    Repo.transaction(fn() ->
      Enum.to_list(stream)
      prochain = Enum.sort(stream, fn x, y ->
        case DateTime.compare(x, y) do
        :lt -> true
        _ -> false
        end
      end)
    dt = Enum.fetch!(prochain,0)
    IO.puts dt
    dt1 = DateTime.diff(dt,actualdate)
    #IO.puts dt1
    if dt1 < 5 do # si le temps récupéré est inférieur à 5 secondes
      IO.puts "temps trop court pour eteindre"
    end
    if dt1 > 5 do
      start(dt1)
    end
    end)
  end

  def powermana do
    sup()
    get1()
  end
end
