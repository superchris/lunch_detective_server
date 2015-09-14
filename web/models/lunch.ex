defmodule LunchDetectiveServer.Lunch do
  use LunchDetectiveServer.Web, :model

  schema "lunches" do
    field :title, :string
    field :url, :string
    belongs_to :lunch_group, LunchDetectiveServer.LunchGroup

    timestamps
  end

  @required_fields ~w(title)
  @optional_fields ~w(url lunch_group_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
