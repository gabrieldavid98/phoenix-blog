defmodule BlogWeb.UserHelper do
  alias Blog.Users.User

  def user_complete_name(%User{} = user) do
    "#{user.name} #{user.last_name}"
  end

  def is_the_author?(%User{} = user_1, %User{} = user_2) do
    user_1.id == user_2.id
  end
end
