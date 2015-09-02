defmodule LunchDetectiveServer.Luncher do
  use LunchDetectiveServer.Web, :model

  schema "lunchers" do
    field :name, :string
    field :email, :string
    belongs_to :lunch_group, LunchDetectiveServer.LunchGroup

    timestamps
  end

  @required_fields ~w(name email)
  @optional_fields ~w(lunch_group_id)

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
