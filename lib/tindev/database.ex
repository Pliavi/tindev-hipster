defmodule Tindev.Database do
  def get do
    dbcluster = Application.get_env(:tindev, :dbcluster)
    dbbase = Application.get_env(:tindev, :dbbase)
    dbuser = Application.get_env(:tindev, :dbuser)
    dbpass = Application.get_env(:tindev, :dbpass)

    Mongo.start_link(
      url: "mongodb+srv://#{dbuser}:#{dbpass}@#{dbcluster}/#{dbbase}?retryWrites=true&w=majority"
    )
  end
end
