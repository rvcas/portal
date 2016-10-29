defmodule Portal do
  use Application

  alias Portal.Door

  defstruct [:left, :right]

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Door, []),
    ]

    opts = [strategy: :simple_one_for_one, name: Portal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    # add all data to the portal on the left
    for item <- data do
      Door.push left, item
    end

    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right(portal) do
    do_push portal.left, portal.right
    portal
  end

  def push_left(portal) do
    do_push portal.right, portal.left

    portal
  end

  defp do_push(from, to) do
    case Door.pop(from) do
      :error -> :ok
      {:ok, h} -> Door.push(to, h)
    end
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data =
      left
      |> Portal.Door.get
      |> Enum.reverse
      |> inspect

    right_data =
      right
      |> Portal.Door.get
      |> inspect

    max = max String.length(left_door), String.length(left_data)
    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
