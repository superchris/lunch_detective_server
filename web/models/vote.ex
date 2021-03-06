defmodule LunchDetectiveServer.Vote do
  use LunchDetectiveServer.Web, :model

  schema "votes" do
    field :yes_no, :boolean, default: false
    field :email, :string
    field :name, :string
    belongs_to :lunch, LunchDetectiveServer.Lunch

    timestamps
  end

  @required_fields ~w(yes_no email name)
  @optional_fields ~w(lunch_id)

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
