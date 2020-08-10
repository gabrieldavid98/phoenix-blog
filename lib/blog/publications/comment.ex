defmodule Blog.Publications.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Users.User
  alias Blog.Publications.Post

  schema "comments" do
    field :body, :string

    belongs_to :user, User 
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :user_id])
    |> validate_required([:body])
  end
end
