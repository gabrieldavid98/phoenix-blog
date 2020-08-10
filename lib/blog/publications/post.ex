defmodule Blog.Publications.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Users.User
  alias Blog.Publications.Comment

  schema "posts" do
    field :body, :string
    field :title, :string

    belongs_to :user, User 
    has_many :comments, Comment 

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
