defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Publications
  alias Blog.Publications.Post
  alias Blog.Publications.Comment

  def index(conn, _params) do
    posts = Publications.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Publications.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = Pow.Plug.current_user(conn)
    case Publications.create_post(current_user.id, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Publications.get_post!(id)
    comment_changeset = Publications.change_comment(%Comment{})
    render(conn, "show.html", post: post, changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Publications.get_post!(id)
    changeset = Publications.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Publications.get_post!(id)

    case Publications.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Publications.get_post!(id)
    {:ok, _post} = Publications.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    current_user = Pow.Plug.current_user(conn)

    new_comment = 
      comment_params
      |> Map.put("post_id", post_id)
      |> Map.put("user_id", current_user.id)

    case Publications.create_comment(new_comment) do
      {:ok, _comment} ->
        post = Publications.get_post!(post_id)

        conn
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        post = Publications.get_post!(post_id)
        render(conn, "show.html", post: post, changeset: changeset)
    end
  end
end
