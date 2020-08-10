defmodule Blog.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  alias Blog.Publications.Post
  alias Blog.Publications.Comment

  schema "users" do
    pow_user_fields()
    field :name, :string
    field :last_name, :string

    has_many :posts, Post
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:name, :last_name])
    |> validate_required([:name, :last_name])
  end
end
